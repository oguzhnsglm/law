import 'package:drift/drift.dart';
import 'package:law/core/db/converters/parties_converter.dart';
import 'package:law/core/db/daos/cases_dao.dart';
import 'package:law/core/db/daos/hearings_dao.dart';
import 'package:law/core/db/daos/sync_logs_dao.dart';
import 'package:law/core/db/daos/user_notes_dao.dart';
import 'package:law/core/db/models/party.dart';
import 'package:law/core/db/tables/cases.dart';
import 'package:law/core/db/tables/hearings.dart';
import 'package:law/core/db/tables/sync_logs.dart';
import 'package:law/core/db/tables/user_notes.dart';

part 'database.g.dart';

/// Uygulamanın SQLCipher tabanlı şifreli yerel veritabanı.
///
/// Tüm tablo ve DAO bağlamaları burada tanımlanır.
/// Bağlantı [database_provider.dart] üzerinden açılır.
@DriftDatabase(
  tables: [Cases, Hearings, SyncLogs, UserNotes],
  daos: [CasesDao, HearingsDao, SyncLogsDao, UserNotesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Gelecekteki migration'lar buraya eklenecek.
        },
      );
}
