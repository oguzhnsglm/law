// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hearings_dao.dart';

// ignore_for_file: type=lint
mixin _$HearingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CasesTable get cases => attachedDatabase.cases;
  $HearingsTable get hearings => attachedDatabase.hearings;
  HearingsDaoManager get managers => HearingsDaoManager(this);
}

class HearingsDaoManager {
  final _$HearingsDaoMixin _db;
  HearingsDaoManager(this._db);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db.attachedDatabase, _db.cases);
  $$HearingsTableTableManager get hearings =>
      $$HearingsTableTableManager(_db.attachedDatabase, _db.hearings);
}
