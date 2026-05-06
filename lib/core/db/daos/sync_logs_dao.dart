import 'package:drift/drift.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/tables/sync_logs.dart';

part 'sync_logs_dao.g.dart';

/// Senkronizasyon logları için veritabanı erişim nesnesi.
@DriftAccessor(tables: [SyncLogs])
class SyncLogsDao extends DatabaseAccessor<AppDatabase>
    with _$SyncLogsDaoMixin {
  SyncLogsDao(super.db);

  /// Yeni bir senkronizasyon kaydı başlatır ve ID'sini döndürür.
  Future<int> start() => into(syncLogs).insert(
        SyncLogsCompanion.insert(
          baslangicZamani: DateTime.now().toUtc(),
        ),
      );

  /// [id]'li senkronizasyon kaydını tamamlar.
  ///
  /// [success] başarı durumu, [added] eklenen, [updated] güncellenen sayı,
  /// [error] varsa hata mesajıdır.
  Future<void> complete(
    int id, {
    required bool success,
    int added = 0,
    int updated = 0,
    String? error,
  }) =>
      (update(syncLogs)..where((t) => t.id.equals(id))).write(
        SyncLogsCompanion(
          bitisZamani: Value(DateTime.now().toUtc()),
          basarili: Value(success),
          eklenenSayi: Value(added),
          guncellenenSayi: Value(updated),
          hataMesaji: Value(error),
        ),
      );

  /// En son başarılı senkronizasyonun başlangıç zamanını döndürür.
  ///
  /// Hiç başarılı senkronizasyon yoksa null döner.
  Future<DateTime?> lastSuccessful() async {
    final query = select(syncLogs)
      ..where((t) => t.basarili.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.baslangicZamani)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row?.baslangicZamani;
  }
}
