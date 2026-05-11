import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/parse/uyap_html_parser.dart';
import '../../../core/parse/uyap_xml_parser.dart';
import '../data/sync_service.dart';

/// Senkron akış adımları.
enum _SyncStage {
  edevletLogin('e-Devlet\'e giriş yapın'),
  redirectingToUyap('UYAP Avukat Portal\'a yönlendiriliyor…'),
  onUyap('UYAP\'a giriş başarılı — "Verileri çek" butonuna basın'),
  fetching('UYAP\'tan veri çekiliyor…'),
  parsing('Veri işleniyor…'),
  done('Tamamlandı'),
  error('Hata');

  const _SyncStage(this.message);
  final String message;
}

/// e-Devlet → UYAP login + veri çekme ekranı.
///
/// Akış:
/// 1. WebView e-Devlet giriş sayfasında açılır.
/// 2. Kullanıcı kendi e-Devlet bilgileriyle giriş yapar.
/// 3. e-Devlet ana sayfasına düşünce uygulama **otomatik olarak**
///    UYAP Avukat Portal'a yönlendirir (SSO zaten aktif).
/// 4. UYAP portalına varınca "Verileri çek" butonu aktifleşir.
/// 5. Çekme sonrası sonuç bir kart olarak gösterilir
///    ("Takviminiz güncellendi: X yeni" / "Yeni duruşma yok" / "Hata…").
class SyncWebViewScreen extends ConsumerStatefulWidget {
  const SyncWebViewScreen({super.key});

  @override
  ConsumerState<SyncWebViewScreen> createState() => _SyncWebViewScreenState();
}

class _SyncWebViewScreenState extends ConsumerState<SyncWebViewScreen> {
  static const _eDevletLoginUrl = 'https://giris.turkiye.gov.tr/Giris/gir';
  static const _uyapPortalUrl = 'https://avukatbeta.uyap.gov.tr/';

  static const _xmlEndpoints = <String>[
    '/avukat/dosyaListesiXmlExport',
    '/avukat/dosyalarim/xml',
    '/main/dosyaListesiXmlExport',
  ];

  InAppWebViewController? _controller;
  _SyncStage _stage = _SyncStage.edevletLogin;
  String? _resultText; // sonuç kartı metni
  bool _resultIsError = false;
  bool _redirectedOnce = false;

  bool get _busy =>
      _stage == _SyncStage.fetching ||
      _stage == _SyncStage.parsing ||
      _stage == _SyncStage.redirectingToUyap;

  void _setStage(_SyncStage s) {
    if (mounted) setState(() => _stage = s);
  }

  // ---- URL akışı ----

  Future<void> _onUrlChanged(WebUri? url) async {
    if (url == null) return;
    final host = url.host;
    final path = url.path;

    // UYAP'a vardık mı?
    if (host.contains('uyap.gov.tr')) {
      if (_stage != _SyncStage.onUyap &&
          _stage != _SyncStage.fetching &&
          _stage != _SyncStage.parsing &&
          _stage != _SyncStage.done) {
        _setStage(_SyncStage.onUyap);
      }
      return;
    }

    // e-Devlet ana sayfasına düştük mü? (login başarılı) → UYAP'a yönlendir
    final loggedInToEdevlet = host.contains('turkiye.gov.tr') &&
        (path.contains('Anasayfa') || path == '/' || path.isEmpty);
    if (loggedInToEdevlet && !_redirectedOnce) {
      _redirectedOnce = true;
      _setStage(_SyncStage.redirectingToUyap);
      await _controller?.loadUrl(
        urlRequest: URLRequest(url: WebUri(_uyapPortalUrl)),
      );
      return;
    }

    // Hâlâ e-Devlet giriş sayfasındayız
    if (host.contains('giris.turkiye.gov.tr')) {
      _setStage(_SyncStage.edevletLogin);
    }
  }

  // ---- Veri çekme ----

  Future<String?> _tryFetchEndpoint(String path) async {
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

  Future<String?> _currentPageHtml() async {
    final r = await _controller
        ?.evaluateJavascript(source: 'document.documentElement.outerHTML');
    return r?.toString();
  }

  Future<void> _runSync() async {
    if (_controller == null) return;
    setState(() {
      _stage = _SyncStage.fetching;
      _resultText = null;
    });

    try {
      // 1) XML endpoint'lerini sırayla dene
      String? xml;
      for (final ep in _xmlEndpoints) {
        xml = await _tryFetchEndpoint(ep);
        if (xml != null && xml.contains('<')) break;
      }

      _setStage(_SyncStage.parsing);

      var parsed = (xml != null && xml.contains('<'))
          ? UyapXmlParser().parse(xml)
          : null;

      // XML başarısız ya da bilinen şema değilse HTML fallback
      if (parsed == null || parsed.cases.isEmpty) {
        final html = await _currentPageHtml();
        if (html != null && html.isNotEmpty) {
          parsed = UyapHtmlParser().parse(html);
        }
      }

      if (parsed == null || parsed.cases.isEmpty) {
        _showResult(
          'UYAP\'tan dosya verisi alınamadı.\n\n'
          'UYAP\'ta "Dosyalarım" sayfasına gidip tekrar deneyin. '
          'Sorun sürerse uygulama UYAP\'ın güncel veri formatına henüz '
          'uyarlanmamış olabilir.',
          isError: true,
        );
        return;
      }

      final summary = await ref.read(syncServiceProvider).merge(parsed);

      if (summary.added == 0 && summary.updated == 0) {
        _showResult('Senkronizasyon tamam — yeni veya değişen duruşma yok.');
      } else {
        final parts = <String>[];
        if (summary.added > 0) parts.add('${summary.added} yeni');
        if (summary.updated > 0) parts.add('${summary.updated} güncellenen');
        _showResult(
          '✓ Takviminiz güncellendi\n${parts.join(' · ')} duruşma '
          '(${summary.warnings.length} uyarı).',
        );
      }
    } catch (e) {
      _showResult('Senkron sırasında hata oluştu:\n$e', isError: true);
    }
  }

  void _showResult(String text, {bool isError = false}) {
    if (!mounted) return;
    setState(() {
      _stage = isError ? _SyncStage.error : _SyncStage.done;
      _resultText = text;
      _resultIsError = isError;
    });
  }

  // ---- UI ----

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showResultCard = _resultText != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Senkronize Et'),
        actions: [
          if (_stage == _SyncStage.onUyap ||
              _stage == _SyncStage.done ||
              _stage == _SyncStage.error)
            IconButton(
              icon: const Icon(Icons.cloud_download_outlined),
              tooltip: 'Verileri çek',
              onPressed: _busy ? null : _runSync,
            ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Durum şeridi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                if (_busy)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                if (_busy) const SizedBox(width: 10),
                Expanded(
                  child: Text(_stage.message, style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          ),

          // Sonuç kartı (varsa)
          if (showResultCard)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _resultIsError
                    ? theme.colorScheme.errorContainer
                    : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _resultIsError
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                        color: _resultIsError
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _resultText!,
                          style: TextStyle(
                            color: _resultIsError
                                ? theme.colorScheme.onErrorContainer
                                : theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_resultIsError)
                        TextButton(
                          onPressed: _busy ? null : _runSync,
                          child: const Text('Tekrar Dene'),
                        ),
                      TextButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Bugün Ekranına Dön'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(_eDevletLoginUrl)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                thirdPartyCookiesEnabled: true,
                sharedCookiesEnabled: true,
                useOnLoadResource: true,
              ),
              onWebViewCreated: (c) => _controller = c,
              onLoadStop: (c, url) => _onUrlChanged(url),
              onUpdateVisitedHistory: (c, url, _) => _onUrlChanged(url),
            ),
          ),
        ],
      ),
    );
  }
}
