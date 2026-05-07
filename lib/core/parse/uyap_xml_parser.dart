import 'package:drift/drift.dart';
import 'package:xml/xml.dart';

import '../db/database.dart';
import '../db/models/party.dart';
import '../utils/tr_date_parser.dart';
import 'parse_result.dart';

/// UYAP Avukat Portal'dan indirilen XML export'unu ayrıştıran parser.
///
/// Şema kamu bilgisine dayalı (G8 dokümantasyonu); UYAP iletişim çıktıları
/// her zaman birebir aynı yapıda olmuyor, bu yüzden parser **tolerant**:
/// bilinmeyen alanları atlar, eksik alanları null bırakır, hatalı satırlarda
/// `ParseResult.warnings`'e not düşüp devam eder.
class UyapXmlParser {
  /// XML stringini parse eder. Hatalı kök → boş sonuç + uyarı.
  ParseResult parse(String xml) {
    final cases = <CasesCompanion>[];
    final hearings = <HearingDraft>[];
    final warnings = <String>[];

    final XmlDocument doc;
    try {
      doc = XmlDocument.parse(xml);
    } catch (e) {
      return ParseResult(
        cases: const [],
        hearings: const [],
        warnings: ['XML parse hatası: $e'],
      );
    }

    final now = DateTime.now().toUtc();
    final caseElements = doc.findAllElements('Dosya');
    for (final el in caseElements) {
      try {
        final dosyaNo = _text(el, 'DosyaNo');
        if (dosyaNo == null || dosyaNo.isEmpty) {
          warnings.add('DosyaNo boş — kayıt atlandı');
          continue;
        }
        final mahkeme = _text(el, 'MahkemeAdi') ?? '';
        final taraflar = _parseParties(el);
        cases.add(CasesCompanion.insert(
          dosyaNo: dosyaNo,
          mahkemeAdi: mahkeme,
          mahkemeTuru: Value(_text(el, 'MahkemeTuru')),
          dosyaTuru: Value(_text(el, 'DosyaTuru')),
          taraflarJson: Value(taraflar),
          durum: Value(_text(el, 'Durum')),
          sonIslemTarihi: Value(_parseDate(_text(el, 'SonIslemTarihi'))),
          sonSenkronTarihi: now,
        ));

        for (final hEl in el.findElements('Durusma')) {
          final tarih = _parseDate(_text(hEl, 'Tarih'));
          if (tarih == null) {
            warnings.add(
                'Duruşma tarihi parse edilemedi (dosya $dosyaNo) — atlandı');
            continue;
          }
          hearings.add(HearingDraft(
            dosyaNo: dosyaNo,
            durusmaTarihi: tarih,
            salon: _text(hEl, 'Salon'),
            gundem: _text(hEl, 'Gundem'),
          ));
        }
      } catch (e) {
        warnings.add('Dosya kaydı parse edilemedi: $e');
      }
    }

    return ParseResult(
      cases: cases,
      hearings: hearings,
      warnings: warnings,
    );
  }

  String? _text(XmlElement el, String name) {
    final child = el.findElements(name).firstOrNull;
    final text = child?.innerText.trim();
    return (text == null || text.isEmpty) ? null : text;
  }

  DateTime? _parseDate(String? s) => TrDateParser.parse(s);

  List<Party> _parseParties(XmlElement caseEl) {
    final result = <Party>[];
    final container = caseEl.findElements('Taraflar').firstOrNull;
    if (container == null) return result;
    for (final p in container.findElements('Taraf')) {
      final ad = _text(p, 'Ad');
      if (ad == null) continue;
      final tip = _text(p, 'Tip') ?? 'Bilinmiyor';
      result.add(Party(ad: ad, tip: tip, vekil: _text(p, 'Vekil')));
    }
    return result;
  }
}
