import 'package:drift/drift.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/tables/hearings.dart';

part 'hearings_dao.g.dart';

/// Duruşma kayıtları için veritabanı erişim nesnesi.
@DriftAccessor(tables: [Hearings])
class HearingsDao extends DatabaseAccessor<AppDatabase>
    with _$HearingsDaoMixin {
  HearingsDao(super.db);

  /// [now] tarihinden itibaren yaklaşan duruşmaları tarihe göre sıralı döndürür.
  ///
  /// En fazla [limit] kayıt döner.
  Future<List<Hearing>> getUpcoming(
    DateTime now, {
    int limit = 50,
  }) =>
      (select(hearings)
            ..where((t) => t.durusmaTarihi.isBiggerOrEqualValue(now))
            ..orderBy([(t) => OrderingTerm.asc(t.durusmaTarihi)])
            ..limit(limit))
          .get();

  /// Belirtilen [caseId]'e ait tüm duruşmaları döndürür.
  Future<List<Hearing>> byCaseId(int caseId) =>
      (select(hearings)..where((t) => t.caseId.equals(caseId))).get();

  /// Mevcut kaydı günceller veya yoksa ekler (upsert on (caseId, durusmaTarihi)).
  ///
  /// Aynı dava ve aynı tarih için ikinci çağrı yeni satır oluşturmaz.
  Future<void> upsertByCaseAndDate(HearingsCompanion companion) =>
      into(hearings).insert(
        companion,
        onConflict: DoUpdate(
          (_) => companion,
          target: [hearings.caseId, hearings.durusmaTarihi],
        ),
      );

  /// Duruşmanın takvim event ID'sini günceller.
  ///
  /// [eventId] null ise sütun null'a set edilir (event silindi).
  Future<void> setEventId(int id, String? eventId) =>
      (update(hearings)..where((t) => t.id.equals(id))).write(
        HearingsCompanion(takvimEventId: Value(eventId)),
      );

  /// [now] tarihinden itibaren yaklaşan duruşmaları gerçek zamanlı izleyen stream.
  Stream<List<Hearing>> watchUpcoming(DateTime now) =>
      (select(hearings)
            ..where((t) => t.durusmaTarihi.isBiggerOrEqualValue(now))
            ..orderBy([(t) => OrderingTerm.asc(t.durusmaTarihi)]))
          .watch();
}
