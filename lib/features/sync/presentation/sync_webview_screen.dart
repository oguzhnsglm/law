import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/parse/uyap_html_parser.dart';
import '../../../core/parse/uyap_xml_parser.dart';
import '../data/sync_service.dart';

/// e-Devlet → UYAP login akışı + veri çekme.
///
/// Akış:
/// 1. Kullanıcı e-Devlet'e kendi şifresiyle giriş yapar.
/// 2. WebView UYAP host'una vardığında "Senkronize Et" butonu aktifleşir.
/// 3. Kullanıcı butona basar; sırasıyla aday endpoint'ler denenir:
///    - `/avukat/dosyaListesiXmlExport` (XML)
///    - `/avukat/dosyalarim/xml` (XML)
///    - mevcut sayfa HTML'i (fallback)
/// 4. İlk başarılı response parse edilir, SyncService ile DB'ye merge edilir.
class SyncWebViewScreen extends ConsumerStatefulWidget {
  const SyncWebViewScreen({super.key});

  @override
  ConsumerState<SyncWebViewScreen> createState() => _SyncWebViewScreenState();
}

class _SyncWebViewScreenState extends ConsumerState<SyncWebViewScreen> {
  static const _eDevletLogin = 'https://giris.turkiye.gov.tr/Giris/gir';
  static const _uyapHostFragment = 'uyap.gov.tr';

  // Aday XML export endpoint'leri — biri çalışana kadar denenir.
  static const _xmlEndpoints = <String>[
    '/avukat/dosyaListesiXmlExport',
    '/avukat/dosyalarim/xml',
    '/main/dosyaListesiXmlExport',
  ];

  InAppWebViewController? _controller;
  bool _onUyap = false;
  String _statusMessage = 'e-Devlet giriş ekranına yönlendiriliyor…';
  bool _syncing = false;

  Future<String?> _tryFetch(String path) async {
    if (_controller == null) return null;
    final js = '''
      (async () => {
        try {
          const r = await fetch('$path', {
            method: 'POST',
            credentials: 'include',
            headers: { 'Accept': 'application/xml,text/html;q=0.9' },
          });
          if (!r.ok) return '__HTTP_' + r.status + '__';
          return await r.text();
        } catch (e) {
          return '__ERROR__: ' + e.message;
        }
      })()
    ''';
    final result = await _controller!.evaluateJavascript(source: js);
    final s = result?.toString() ?? '';
    if (s.isEmpty || s.startsWith('__ERROR__') || s.startsWith('__HTTP_')) {
      return null;
    }
    return s;
  }

  Future<String?> _fetchPageHtml() async {
    if (_controller == null) return null;
    final result = await _controller!.evaluateJavascript(
      source: 'document.documentElement.outerHTML',
    );
    return result?.toString();
  }

  Future<void> _runSync() async {
    if (_controller == null || !_onUyap) return;
    setState(() {
      _syncing = true;
      _statusMessage = 'UYAP\'tan veri çekiliyor…';
    });

    try {
      // 1) XML endpoint'lerini sırayla dene
      String? xml;
      String? lastTriedPath;
      for (final ep in _xmlEndpoints) {
        lastTriedPath = ep;
        setState(() => _statusMessage = 'Endpoint deneniyor: $ep');
        xml = await _tryFetch(ep);
        if (xml != null && xml.contains('<')) break;
      }

      if (xml != null && xml.contains('<')) {
        setState(() => _statusMessage = 'XML parse ediliyor…');
        final parsed = UyapXmlParser().parse(xml);
        if (parsed.cases.isEmpty) {
          // XML parse etmiş ama bilinen şema değil — HTML fallback'e geç
          await _runHtmlFallback();
          return;
        }
        final summary = await ref.read(syncServiceProvider).merge(parsed);
        setState(() {
          _statusMessage = '${summary.added} yeni · ${summary.updated} '
              'güncellenen · ${summary.warnings.length} uyarı '
              '(${summary.durationMs} ms)';
          _syncing = false;
        });
        return;
      }

      // 2) HTML fallback
      await _runHtmlFallback(lastTriedPath: lastTriedPath);
    } catch (e) {
      setState(() {
        _statusMessage = 'Senkron hatası: $e';
        _syncing = false;
      });
    }
  }

  Future<void> _runHtmlFallback({String? lastTriedPath}) async {
    setState(() => _statusMessage = 'HTML sayfa parse ediliyor (fallback)…');
    final html = await _fetchPageHtml();
    if (html == null || html.isEmpty) {
      setState(() {
        _statusMessage = 'Veri alınamadı. Dosya listesi sayfasında olduğunuzdan '
            'emin olun ve tekrar deneyin.${lastTriedPath != null ? ' (Son denenen: $lastTriedPath)' : ''}';
        _syncing = false;
      });
      return;
    }
    final parsed = UyapHtmlParser().parse(html);
    if (parsed.cases.isEmpty) {
      setState(() {
        _statusMessage = 'Bu sayfada dosya tablosu bulunamadı. UYAP\'ta '
            '"Dosyalarım" sayfasına gidip tekrar deneyin.';
        _syncing = false;
      });
      return;
    }
    final summary = await ref.read(syncServiceProvider).merge(parsed);
    setState(() {
      _statusMessage = 'HTML fallback: ${summary.added} yeni · '
          '${summary.updated} güncellenen';
      _syncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senkronize Et'),
        actions: [
          if (_onUyap)
            IconButton(
              icon: _syncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
              onPressed: _syncing ? null : _runSync,
              tooltip: 'Verileri çek',
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Text(
              _statusMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(_eDevletLogin)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                thirdPartyCookiesEnabled: true,
                sharedCookiesEnabled: true,
              ),
              onWebViewCreated: (c) => _controller = c,
              onLoadStop: (c, url) async {
                if (url == null) return;
                final isUyap = url.host.contains(_uyapHostFragment);
                if (isUyap != _onUyap) {
                  setState(() {
                    _onUyap = isUyap;
                    _statusMessage = isUyap
                        ? 'UYAP\'a giriş başarılı. Sağ üstten "Verileri çek" butonuna basın.'
                        : 'e-Devlet\'e giriş yapın; UYAP\'a otomatik yönlendirileceksiniz.';
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
