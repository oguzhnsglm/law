import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/parse/uyap_xml_parser.dart';
import '../data/sync_service.dart';

/// e-Devlet → UYAP login akışı + XML export tetikleyici.
///
/// Kullanıcı kendi parmaklarıyla e-Devlet'e girer; uygulama URL/cookie
/// değişimini takip ederek UYAP Avukat Portal'a vardığını anlar ve
/// "Senkronize Et" butonu aktif olur.
class SyncWebViewScreen extends ConsumerStatefulWidget {
  const SyncWebViewScreen({super.key});

  @override
  ConsumerState<SyncWebViewScreen> createState() => _SyncWebViewScreenState();
}

class _SyncWebViewScreenState extends ConsumerState<SyncWebViewScreen> {
  static const _eDevletLogin = 'https://giris.turkiye.gov.tr/Giris/gir';
  static const _uyapHost = 'avukatbeta.uyap.gov.tr';

  InAppWebViewController? _controller;
  bool _onUyap = false;
  String _statusMessage = 'e-Devlet giriş ekranına yönlendiriliyor…';
  bool _syncing = false;

  Future<void> _runSync() async {
    if (_controller == null || !_onUyap) return;
    setState(() {
      _syncing = true;
      _statusMessage = 'UYAP\'tan veri çekiliyor…';
    });

    try {
      // UYAP'ın XML export endpoint'i — kullanıcı oturumu içinde fetch
      final result = await _controller!.evaluateJavascript(source: '''
        (async () => {
          try {
            const r = await fetch('/avukat/dosyaListesiXmlExport', {
              method: 'POST',
              credentials: 'include',
              headers: { 'Accept': 'application/xml' },
            });
            return await r.text();
          } catch (e) {
            return '__ERROR__: ' + e.message;
          }
        })()
      ''');

      final xml = result?.toString() ?? '';
      if (xml.startsWith('__ERROR__') || xml.isEmpty) {
        setState(() {
          _statusMessage = 'XML alınamadı. UYAP henüz endpoint\'i değiştirmiş '
              'olabilir.';
          _syncing = false;
        });
        return;
      }

      final parsed = UyapXmlParser().parse(xml);
      final summary = await ref.read(syncServiceProvider).merge(parsed);
      setState(() {
        _statusMessage = '${summary.added} yeni · ${summary.updated} '
            'güncellenen · ${summary.warnings.length} uyarı';
        _syncing = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Senkron hatası: $e';
        _syncing = false;
      });
    }
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
                final isUyap = url.host.contains(_uyapHost);
                if (isUyap != _onUyap) {
                  setState(() {
                    _onUyap = isUyap;
                    _statusMessage = isUyap
                        ? 'UYAP\'a giriş başarılı. Sağ üstten "Verileri çek".'
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
