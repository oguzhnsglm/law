import 'package:drift/drift.dart';

/// Senkronizasyon işlemlerinin log kayıtlarını tutan tablo.
///
/// Her senkronizasyon [start] ile başlar, [complete] ile kapanır.
class SyncLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Senkronizasyonun başladığı zaman.
  DateTimeColumn get baslangicZamani => dateTime()();

  /// Senkronizasyonun tamamlandığı zaman. Henüz bitmemişse null.
  DateTimeColumn get bitisZamani => dateTime().nullable()();

  /// Senkronizasyon başarılı mı tamamlandı?
  BoolColumn get basarili => boolean().withDefault(const Constant(false))();

  /// Bu senkronizasyonda eklenen kayıt sayısı.
  IntColumn get eklenenSayi => integer().withDefault(const Constant(0))();

  /// Bu senkronizasyonda güncellenen kayıt sayısı.
  IntColumn get guncellenenSayi => integer().withDefault(const Constant(0))();

  /// Hata oluşmuşsa hata mesajı.
  TextColumn get hataMesaji => text().nullable()();
}
