import 'package:drift/drift.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/tables/cases.dart';

part 'cases_dao.g.dart';

/// Dava kayıtları için veritabanı erişim nesnesi.
@DriftAccessor(tables: [Cases])
class CasesDao extends DatabaseAccessor<AppDatabase> with _$CasesDaoMixin {
  CasesDao(super.db);

  /// Tüm dava kayıtlarını döndürür.
  Future<List<Case>> getAll() => select(cases).get();

  /// [dosyaNo]'ya göre dava kaydı getirir. Bulunamazsa null döner.
  Future<Case?> byDosyaNo(String dosyaNo) =>
      (select(cases)..where((t) => t.dosyaNo.equals(dosyaNo)))
          .getSingleOrNull();

  /// Mevcut kaydı günceller veya yoksa ekler (upsert on dosyaNo).
  ///
  /// [dosyaNo] çakışmasında tüm sütunlar [companion] ile güncellenir.
  Future<void> upsert(CasesCompanion companion) => into(cases).insert(
        companion,
        onConflict: DoUpdate(
          (_) => companion,
          target: [cases.dosyaNo],
        ),
      );

  /// Tüm dava kayıtlarını gerçek zamanlı izleyen stream.
  Stream<List<Case>> watchAll() => select(cases).watch();
}
