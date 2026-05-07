import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/models/party.dart';
import 'package:law/features/cases/state/cases_filter.dart';
import 'package:law/features/cases/state/cases_list_provider.dart';

Case _case({
  required int id,
  required String dosyaNo,
  required String mahkemeAdi,
  String? durum,
  List<Party>? taraflar,
}) {
  return Case(
    id: id,
    dosyaNo: dosyaNo,
    mahkemeAdi: mahkemeAdi,
    mahkemeTuru: null,
    dosyaTuru: null,
    taraflarJson: taraflar ?? const [],
    durum: durum,
    sonIslemTarihi: null,
    sonSenkronTarihi: DateTime(2026, 5, 6),
  );
}

void main() {
  group('CasesFilter.matches', () {
    test('all her durumla eşleşir', () {
      expect(CasesFilter.all.matches(null), isTrue);
      expect(CasesFilter.all.matches('Açık'), isTrue);
      expect(CasesFilter.all.matches('Karar Verilmiş'), isTrue);
    });

    test('açık varyantları yakalar (büyük/küçük harf)', () {
      expect(CasesFilter.open.matches('Açık'), isTrue);
      expect(CasesFilter.open.matches('AÇIK'), isTrue);
      expect(CasesFilter.open.matches('Açık Dosya'), isTrue);
      expect(CasesFilter.open.matches(null), isFalse);
      expect(CasesFilter.open.matches('Kapalı'), isFalse);
    });

    test('karar varyantları yakalar', () {
      expect(CasesFilter.decided.matches('Karar Verilmiş'), isTrue);
      expect(CasesFilter.decided.matches('karar'), isTrue);
      expect(CasesFilter.decided.matches('Açık'), isFalse);
    });
  });

  group('applyQuery', () {
    final cases = [
      _case(id: 1, dosyaNo: '2025/1234', mahkemeAdi: 'İstanbul 1. Asliye Hukuk', durum: 'Açık'),
      _case(id: 2, dosyaNo: '2024/5678', mahkemeAdi: 'Ankara 3. İş', durum: 'Kapalı'),
      _case(id: 3, dosyaNo: '2026/0001', mahkemeAdi: 'İstanbul 5. Aile', durum: 'Karar Verilmiş'),
    ];

    test('boş sorgu hepsini döner', () {
      final result = applyQuery(cases, const CasesQuery());
      expect(result.length, 3);
    });

    test('açık filtresi sadece açık dosyaları döner', () {
      final result = applyQuery(
        cases,
        const CasesQuery(filter: CasesFilter.open),
      );
      expect(result.length, 1);
      expect(result.first.dosyaNo, '2025/1234');
    });

    test('arama esas no ile eşleşir', () {
      final result = applyQuery(
        cases,
        const CasesQuery(searchText: '5678'),
      );
      expect(result.length, 1);
      expect(result.first.dosyaNo, '2024/5678');
    });

    test('arama mahkeme adı ile eşleşir, case-insensitive', () {
      final result = applyQuery(
        cases,
        const CasesQuery(searchText: 'istanbul'),
      );
      expect(result.length, 2);
    });

    test('filtre + arama birlikte çalışır', () {
      final result = applyQuery(
        cases,
        const CasesQuery(searchText: 'istanbul', filter: CasesFilter.open),
      );
      expect(result.length, 1);
      expect(result.first.durum, 'Açık');
    });
  });
}
