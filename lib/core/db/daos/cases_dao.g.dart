// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cases_dao.dart';

// ignore_for_file: type=lint
mixin _$CasesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CasesTable get cases => attachedDatabase.cases;
  CasesDaoManager get managers => CasesDaoManager(this);
}

class CasesDaoManager {
  final _$CasesDaoMixin _db;
  CasesDaoManager(this._db);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db.attachedDatabase, _db.cases);
}
