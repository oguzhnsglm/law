import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/parse/uyap_html_parser.dart';

const _htmlSimple = '''
<html><body>
<table>
  <tr><th>Esas No</th><th>Mahkeme</th><th>Durum</th></tr>
  <tr><td>2025/1234</td><td>İstanbul 1. Asliye Hukuk</td><td>Açık</td></tr>
  <tr><td>2024/5678</td><td>Ankara 3. İş</td><td>Kapalı</td></tr>
</table>
</body></html>
''';

const _htmlNoTable = '<html><body><p>boş</p></body></html>';

const _htmlEmptyHeaders = '''
<html><body>
<table>
  <tr><th>X</th><th>Y</th></tr>
  <tr><td>a</td><td>b</td></tr>
</table>
</body></html>
''';

void main() {
  final parser = UyapHtmlParser();

  group('UyapHtmlParser', () {
    test('basit dosya tablosu parse eder', () {
      final r = parser.parse(_htmlSimple);
      expect(r.cases, hasLength(2));
      expect(r.cases.first.dosyaNo.value, '2025/1234');
      expect(r.cases.first.mahkemeAdi.value, 'İstanbul 1. Asliye Hukuk');
      expect(r.cases.first.durum.value, 'Açık');
    });

    test('tablo yoksa warning + boş cases', () {
      final r = parser.parse(_htmlNoTable);
      expect(r.cases, isEmpty);
      expect(r.warnings, isNotEmpty);
    });

    test('tanınmayan header\'larla tablo atlanır', () {
      final r = parser.parse(_htmlEmptyHeaders);
      expect(r.cases, isEmpty);
    });
  });
}
