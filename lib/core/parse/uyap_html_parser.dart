import 'package:drift/drift.dart';
import 'package:html/parser.dart' as html_parser;

import '../db/database.dart';
import '../utils/tr_date_parser.dart';
import 'parse_result.dart';

/// UYAP Avukat Portal HTML sayfalarından (dosya listesi tablosu)
/// minimal parser. XML endpoint başarısızsa fallback olarak kullanılır.
///
/// Beklenen tablo yapısı:
/// ```html
/// <table class="...">
///   <tr><th>Esas No</th><th>Mahkeme</th><th>Durum</th>...</tr>
///   <tr><td>2025/123</td><td>İstanbul 1. ASLİYE</td>...</tr>
/// </table>
/// ```
///
/// UYAP'ın gerçek HTML yapısı stabil olmadığı için **header isimlerinden**
/// kolon indeksini çıkarıp esnek parse yapar.
class UyapHtmlParser {
  ParseResult parse(String html) {
    final cases = <CasesCompanion>[];
    final warnings = <String>[];
    final now = DateTime.now().toUtc();

    try {
      final doc = html_parser.parse(html);
      final tables = doc.querySelectorAll('table');
      if (tables.isEmpty) {
        return ParseResult(
          cases: const [],
          hearings: const [],
          warnings: ['HTML\'de tablo bulunamadı'],
        );
      }

      for (final table in tables) {
        final headers = table
            .querySelectorAll('th')
            .map((e) => e.text.trim().toLowerCase())
            .toList();
        if (headers.isEmpty) continue;

        // Kolon indekslerini header isimlerinden çıkar
        int? indexOf(List<String> needles) {
          for (var i = 0; i < headers.length; i++) {
            for (final n in needles) {
              if (headers[i].contains(n)) return i;
            }
          }
          return null;
        }

        final esasIdx = indexOf(['esas', 'dosya no', 'no']);
        final mahkemeIdx = indexOf(['mahkeme']);
        final durumIdx = indexOf(['durum']);

        if (esasIdx == null || mahkemeIdx == null) continue;

        final rows = table.querySelectorAll('tr').skip(1);
        for (final row in rows) {
          final cells =
              row.querySelectorAll('td').map((e) => e.text.trim()).toList();
          if (cells.length <= esasIdx || cells.length <= mahkemeIdx) continue;
          final dosyaNo = cells[esasIdx];
          if (dosyaNo.isEmpty) continue;

          cases.add(CasesCompanion.insert(
            dosyaNo: dosyaNo,
            mahkemeAdi: cells[mahkemeIdx],
            durum: Value(durumIdx != null && cells.length > durumIdx
                ? cells[durumIdx]
                : null),
            sonSenkronTarihi: now,
          ));
        }
      }
    } catch (e) {
      warnings.add('HTML parse hatası: $e');
    }

    return ParseResult(
      cases: cases,
      hearings: const [],
      warnings: warnings,
    );
  }

  /// HTML stringinden basit tarih çıkarma helper'ı (ileride hearing satırları
  /// parse edilirse kullanılır).
  // ignore: unused_element
  DateTime? _parseDateCell(String s) => TrDateParser.parse(s);
}
