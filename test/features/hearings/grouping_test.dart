import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/db/database.dart';
import 'package:law/features/hearings/data/hearing_view_model.dart';
import 'package:law/features/hearings/state/hearings_today_provider.dart';

HearingViewModel _vm(DateTime t, {String? esas}) {
  final h = Hearing(
    id: t.millisecondsSinceEpoch,
    caseId: 1,
    durusmaTarihi: t,
    salon: null,
    gundem: null,
    bildirimTetiklendi: false,
    takvimEventId: null,
    sonSenkronTarihi: t,
  );
  return HearingViewModel(
    hearing: h,
    dosyaNo: esas,
    mahkemeAdi: 'Test Mahkemesi',
  );
}

void main() {
  group('groupHearings', () {
    final now = DateTime(2026, 5, 6, 10, 0); // Çarşamba

    test('boş liste tüm grupları boş döner', () {
      final result = groupHearings(const [], now);
      expect(result.isEmpty, isTrue);
      expect(result.totalCount, 0);
    });

    test('bugün, yarın, bu hafta, sonra doğru kategorize eder', () {
      final items = [
        _vm(DateTime(2026, 5, 6, 14, 0)), // bugün
        _vm(DateTime(2026, 5, 7, 9, 30)), // yarın
        _vm(DateTime(2026, 5, 10, 11, 0)), // bu hafta (4 gün sonra)
        _vm(DateTime(2026, 5, 25, 11, 0)), // sonra
      ];

      final result = groupHearings(items, now);

      expect(result.today.length, 1);
      expect(result.tomorrow.length, 1);
      expect(result.thisWeek.length, 1);
      expect(result.later.length, 1);
      expect(result.totalCount, 4);
    });

    test('aynı gün birden fazla duruşma hepsini today\'e koyar', () {
      final items = [
        _vm(DateTime(2026, 5, 6, 9, 0)),
        _vm(DateTime(2026, 5, 6, 14, 0)),
        _vm(DateTime(2026, 5, 6, 16, 30)),
      ];

      final result = groupHearings(items, now);

      expect(result.today.length, 3);
      expect(result.tomorrow, isEmpty);
    });

    test('gün sınırı: 23:59 bugün, 00:00 yarın', () {
      final items = [
        _vm(DateTime(2026, 5, 6, 23, 59)),
        _vm(DateTime(2026, 5, 7, 0, 0)),
      ];

      final result = groupHearings(items, now);

      expect(result.today.length, 1);
      expect(result.tomorrow.length, 1);
    });
  });
}
