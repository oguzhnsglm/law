import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/parse/parse_result.dart';
import 'package:law/features/sync/data/sync_service.dart';

ParseResult _sampleResult() {
  return ParseResult(
    cases: [
      CasesCompanion.insert(
        dosyaNo: '2025/1',
        mahkemeAdi: 'M1',
        sonSenkronTarihi: DateTime.utc(2026, 5, 1),
      ),
      CasesCompanion.insert(
        dosyaNo: '2025/2',
        mahkemeAdi: 'M2',
        sonSenkronTarihi: DateTime.utc(2026, 5, 1),
      ),
    ],
    hearings: [
      HearingDraft(
        dosyaNo: '2025/1',
        durusmaTarihi: DateTime.utc(2026, 5, 10, 14, 30),
        salon: 'Salon 3',
      ),
      HearingDraft(
        dosyaNo: '2025/2',
        durusmaTarihi: DateTime.utc(2026, 5, 15, 10, 0),
      ),
    ],
  );
}

void main() {
  late AppDatabase db;
  late SyncService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = SyncService(db);
  });

  tearDown(() => db.close());

  test('boş DB\'ye merge tüm kayıtları ekler', () async {
    final summary = await service.merge(_sampleResult());
    expect(summary.added, 4);
    expect(summary.updated, 0);

    final cases = await db.casesDao.getAll();
    expect(cases, hasLength(2));
  });

  test('aynı ParseResult\'ı ikinci kez merge etmek 0 yeni eklemez',
      () async {
    await service.merge(_sampleResult());
    final summary2 = await service.merge(_sampleResult());
    expect(summary2.added, 0);
    expect(summary2.updated, 4);

    final cases = await db.casesDao.getAll();
    expect(cases, hasLength(2));
  });

  test('sync_logs.start ve complete çağrılır', () async {
    await service.merge(_sampleResult());
    final last = await db.syncLogsDao.lastSuccessful();
    expect(last, isNotNull);
  });

  test('case kayıtsız hearing atlanır (case yoksa hearing yazılmaz)',
      () async {
    final result = ParseResult(
      cases: const [],
      hearings: [
        HearingDraft(
          dosyaNo: 'orphan',
          durusmaTarihi: DateTime.utc(2026, 5, 10, 14, 30),
        ),
      ],
    );
    final summary = await service.merge(result);
    expect(summary.added, 0);

    final hearings = await (db.select(db.hearings)).get();
    expect(hearings, isEmpty);
  });
}
