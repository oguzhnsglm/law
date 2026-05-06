import 'package:drift/drift.dart';
import 'package:law/core/db/tables/hearings.dart';

/// Kullanıcı notlarını tutan tablo.
///
/// Bir nota opsiyonel olarak bir duruşmaya bağlanabilir.
/// Duruşma silindiğinde not silinmez; [hearingId] null olur (SET NULL).
class UserNotes extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Bağlı duruşma kimliği. Duruşma silindiğinde null olur.
  IntColumn get hearingId => integer()
      .nullable()
      .references(Hearings, #id, onDelete: KeyAction.setNull)();

  /// Notun içeriği.
  TextColumn get notMetni => text()();

  /// Notun oluşturulma tarihi.
  DateTimeColumn get olusturmaTarihi => dateTime()();
}
