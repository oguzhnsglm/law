import 'package:drift/drift.dart';
import 'package:law/core/db/tables/cases.dart';

/// Duruşma kayıtlarını tutan tablo.
///
/// Her duruşma bir [Cases] kaydına bağlıdır. [caseId] + [durusmaTarihi]
/// çifti benzersizdir; aynı duruşma iki kez eklenmez.
@TableIndex(name: 'idx_hearings_tarih', columns: {#durusmaTarihi})
class Hearings extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Bağlı dava kimliği. Dava silindiğinde duruşmalar da silinir (CASCADE).
  IntColumn get caseId =>
      integer().references(Cases, #id, onDelete: KeyAction.cascade)();

  /// Duruşmanın UTC tarihi ve saati.
  DateTimeColumn get durusmaTarihi => dateTime()();

  /// Duruşmanın yapılacağı salon.
  TextColumn get salon => text().nullable()();

  /// Duruşma gündemi.
  TextColumn get gundem => text().nullable()();

  /// Yerel bildirim bu duruşma için tetiklendi mi?
  BoolColumn get bildirimTetiklendi =>
      boolean().withDefault(const Constant(false))();

  /// Native takvimde oluşturulan event ID'si.
  TextColumn get takvimEventId => text().nullable()();

  /// Bu kaydın son senkronizasyon tarihi.
  DateTimeColumn get sonSenkronTarihi => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {caseId, durusmaTarihi},
      ];
}
