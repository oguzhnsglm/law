import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/parse/uyap_xml_parser.dart';

const _xmlSimple = '''
<UyapDosyalar>
  <Dosya>
    <DosyaNo>2025/1234</DosyaNo>
    <MahkemeAdi>İstanbul 1. Asliye Hukuk Mahkemesi</MahkemeAdi>
    <MahkemeTuru>Asliye Hukuk</MahkemeTuru>
    <Durum>Açık</Durum>
    <SonIslemTarihi>15.04.2026</SonIslemTarihi>
    <Taraflar>
      <Taraf>
        <Ad>Ahmet Yılmaz</Ad>
        <Tip>Davacı</Tip>
      </Taraf>
      <Taraf>
        <Ad>Mehmet Demir</Ad>
        <Tip>Davalı</Tip>
        <Vekil>Av. Zeynep Kaya</Vekil>
      </Taraf>
    </Taraflar>
    <Durusma>
      <Tarih>01.05.2026 14:30</Tarih>
      <Salon>Salon 3</Salon>
      <Gundem>Tanık dinleme</Gundem>
    </Durusma>
    <Durusma>
      <Tarih>15.06.2026 10:00</Tarih>
      <Salon>Salon 3</Salon>
    </Durusma>
  </Dosya>
</UyapDosyalar>
''';

const _xmlMissingDosyaNo = '''
<UyapDosyalar>
  <Dosya>
    <MahkemeAdi>X Mahkemesi</MahkemeAdi>
  </Dosya>
</UyapDosyalar>
''';

const _xmlBadDate = '''
<UyapDosyalar>
  <Dosya>
    <DosyaNo>2025/9999</DosyaNo>
    <MahkemeAdi>Y Mahkemesi</MahkemeAdi>
    <Durusma>
      <Tarih>not-a-date</Tarih>
    </Durusma>
  </Dosya>
</UyapDosyalar>
''';

void main() {
  final parser = UyapXmlParser();

  group('UyapXmlParser', () {
    test('temel dosya + duruşma + taraflar parse eder', () {
      final r = parser.parse(_xmlSimple);
      expect(r.cases, hasLength(1));
      expect(r.hearings, hasLength(2));
      expect(r.warnings, isEmpty);

      final c = r.cases.first;
      expect(c.dosyaNo.value, '2025/1234');
      expect(c.mahkemeAdi.value, 'İstanbul 1. Asliye Hukuk Mahkemesi');
      expect(c.durum.value, 'Açık');
      expect(c.taraflarJson.value, hasLength(2));
      expect(c.taraflarJson.value.first.ad, 'Ahmet Yılmaz');
      expect(c.taraflarJson.value[1].vekil, 'Av. Zeynep Kaya');

      final h0 = r.hearings.first;
      expect(h0.dosyaNo, '2025/1234');
      expect(h0.salon, 'Salon 3');
      expect(h0.gundem, 'Tanık dinleme');
    });

    test('DosyaNo eksik kayıt warning üretir, atlar', () {
      final r = parser.parse(_xmlMissingDosyaNo);
      expect(r.cases, isEmpty);
      expect(r.warnings, isNotEmpty);
    });

    test('parse edilemeyen tarih warning üretir, hearing atılır', () {
      final r = parser.parse(_xmlBadDate);
      expect(r.cases, hasLength(1));
      expect(r.hearings, isEmpty);
      expect(r.warnings, isNotEmpty);
    });

    test('bozuk XML root için boş sonuç + warning', () {
      final r = parser.parse('<<<not xml>>>');
      expect(r.isEmpty, isTrue);
      expect(r.warnings, isNotEmpty);
    });

    test('hearingsByDosyaNo helper doğru filtreler', () {
      final r = parser.parse(_xmlSimple);
      expect(r.hearingsByDosyaNo('2025/1234'), hasLength(2));
      expect(r.hearingsByDosyaNo('yok'), isEmpty);
    });
  });
}
