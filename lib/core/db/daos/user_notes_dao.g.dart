// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notes_dao.dart';

// ignore_for_file: type=lint
mixin _$UserNotesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CasesTable get cases => attachedDatabase.cases;
  $HearingsTable get hearings => attachedDatabase.hearings;
  $UserNotesTable get userNotes => attachedDatabase.userNotes;
  UserNotesDaoManager get managers => UserNotesDaoManager(this);
}

class UserNotesDaoManager {
  final _$UserNotesDaoMixin _db;
  UserNotesDaoManager(this._db);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db.attachedDatabase, _db.cases);
  $$HearingsTableTableManager get hearings =>
      $$HearingsTableTableManager(_db.attachedDatabase, _db.hearings);
  $$UserNotesTableTableManager get userNotes =>
      $$UserNotesTableTableManager(_db.attachedDatabase, _db.userNotes);
}
