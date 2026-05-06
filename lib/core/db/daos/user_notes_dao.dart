import 'package:drift/drift.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/tables/user_notes.dart';

part 'user_notes_dao.g.dart';

/// Kullanıcı notları için veritabanı erişim nesnesi.
@DriftAccessor(tables: [UserNotes])
class UserNotesDao extends DatabaseAccessor<AppDatabase>
    with _$UserNotesDaoMixin {
  UserNotesDao(super.db);

  /// Belirtilen [hearingId]'e ait notları döndürür.
  Future<List<UserNote>> byHearingId(int hearingId) =>
      (select(userNotes)..where((t) => t.hearingId.equals(hearingId))).get();

  /// Yeni not ekler ve oluşturulan satırın ID'sini döndürür.
  Future<int> add(UserNotesCompanion companion) =>
      into(userNotes).insert(companion);

  /// [id]'li notu siler.
  Future<int> deleteById(int id) =>
      (delete(userNotes)..where((t) => t.id.equals(id))).go();
}
