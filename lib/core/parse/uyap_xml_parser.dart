import 'package:drift/drift.dart';
import 'package:xml/xml.dart';

import '../db/database.dart';
import '../db/models/party.dart';
import '../utils/tr_date_parser.dart';
import 'parse_result.dart';

/// UYAP Avukat Portal'dan indirilen XML export'unu ayrıştıran parser.
///
/// **Tag esnekliği:** UYAP zaman içinde farklı tag isimleri / farklı
/// hiyerarşi kullanabiliyor. Parser her alan için **birden fazla aday**
/// dener (örn. dosya numarası `<DosyaNo>`, `<EsasNo>`, `<dosyaNo>` veya
/// öznitelik olarak `dosyaNo="..."`). Bilinmeyen alanları atlar; hatalı
/// satırlarda `ParseResult.warnings`'e not düşüp devam eder.
class UyapXmlParser {
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

    // Olası dosya container tag isimleri (öncelik sırasıyla)
    final caseTags = ['Dosya', 'dosya', 'Case', 'AvukatDosyasi'];
    final caseElements = <XmlElement>[];
    for (final tag in caseTags) {
      caseElements.addAll(doc.findAllElements(tag));
      if (caseElements.isNotEmpty) break;
    }

    if (caseElements.isEmpty) {
      warnings.add(
        'Tanınan kök element bulunamadı (Dosya/dosya/Case/AvukatDosyasi)',
      );
    }

    for (final el in caseElements) {
      try {
        final dosyaNo = _firstText(el, [
          'DosyaNo',
          'dosyaNo',
          'EsasNo',
          'esasNo',
          'DosyaNumarasi',
        ]);
        if (dosyaNo == null || dosyaNo.isEmpty) {
          warnings.add('DosyaNo boş — kayıt atlandı');
          continue;
        }
        final mahkeme = _firstText(el, [
          'MahkemeAdi',
          'mahkemeAdi',
          'Mahkeme',
          'mahkeme',
        ]) ?? '';
        final taraflar = _parseParties(el);
        cases.add(CasesCompanion.insert(
          dosyaNo: dosyaNo,
          mahkemeAdi: mahkeme,
          mahkemeTuru: Value(_firstText(
              el, ['MahkemeTuru', 'mahkemeTuru', 'MahkemeTipi'])),
          dosyaTuru: Value(_firstText(
              el, ['DosyaTuru', 'dosyaTuru', 'DosyaTipi'])),
          taraflarJson: Value(taraflar),
          durum: Value(_firstText(el, ['Durum', 'durum', 'DosyaDurumu'])),
          sonIslemTarihi: Value(_parseDate(_firstText(
              el, ['SonIslemTarihi', 'sonIslemTarihi', 'IslemTarihi']))),
          sonSenkronTarihi: now,
        ));

        for (final hEl in _findHearings(el)) {
          final tarih = _parseDate(_firstText(hEl, [
            'Tarih',
            'tarih',
            'DurusmaTarihi',
            'durusmaTarihi',
            'Saat',
          ]));
          if (tarih == null) {
            warnings.add(
                'Duruşma tarihi parse edilemedi (dosya $dosyaNo) — atlandı');
            continue;
          }
          hearings.add(HearingDraft(
            dosyaNo: dosyaNo,
            durusmaTarihi: tarih,
            salon: _firstText(hEl, ['Salon', 'salon', 'DurusmaSalonu']),
            gundem: _firstText(hEl, ['Gundem', 'gundem', 'Konu']),
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

  String? _firstText(XmlElement el, List<String> candidates) {
    for (final name in candidates) {
      // Önce alt element olarak ara
      final child = el.findElements(name).firstOrNull;
      final text = child?.innerText.trim();
      if (text != null && text.isNotEmpty) return text;
      // Sonra öznitelik (attribute) olarak ara
      final attr = el.getAttribute(name)?.trim();
      if (attr != null && attr.isNotEmpty) return attr;
    }
    return null;
  }

  Iterable<XmlElement> _findHearings(XmlElement caseEl) {
    final candidates = ['Durusma', 'durusma', 'DurusmaListesi', 'Hearing'];
    for (final name in candidates) {
      final found = caseEl.findElements(name);
      if (found.isNotEmpty) return found;
      // Alt container tag içinde aramayı dene
      final container = caseEl.findElements('${name}lar').firstOrNull ??
          caseEl.findElements('${name}List').firstOrNull;
      if (container != null) {
        final inner = container.findElements(name);
        if (inner.isNotEmpty) return inner;
      }
    }
    return const [];
  }

  DateTime? _parseDate(String? s) => TrDateParser.parse(s);

  List<Party> _parseParties(XmlElement caseEl) {
    final result = <Party>[];
    final containerCandidates = ['Taraflar', 'taraflar', 'TarafListesi'];
    XmlElement? container;
    for (final name in containerCandidates) {
      container = caseEl.findElements(name).firstOrNull;
      if (container != null) break;
    }
    if (container == null) return result;

    final partyTags = ['Taraf', 'taraf', 'Party'];
    Iterable<XmlElement> parties = const [];
    for (final tag in partyTags) {
      parties = container.findElements(tag);
      if (parties.isNotEmpty) break;
    }

    for (final p in parties) {
      final ad = _firstText(p, ['Ad', 'ad', 'AdSoyad', 'Isim']);
      if (ad == null) continue;
      final tip = _firstText(p, ['Tip', 'tip', 'TarafTipi', 'Rol']) ??
          'Bilinmiyor';
      result.add(Party(
        ad: ad,
        tip: tip,
        vekil: _firstText(p, ['Vekil', 'vekil', 'VekilAdi']),
      ));
    }
    return result;
  }
}
