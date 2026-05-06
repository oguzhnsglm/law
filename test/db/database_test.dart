// Hide isNull/isNotNull from drift to avoid ambiguity with flutter_test matchers.
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/models/party.dart';

AppDatabase _openTestDb() =>
    AppDatabase(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _openTestDb());

  tearDown(() => db.close());

  group('Cases DAO', () {
    test('insert ve getAll çalışır', () async {
      await db.casesDao.upsert(
        CasesCompanion.insert(
          dosyaNo: '2024/1001',
          mahkemeAdi: 'İstanbul 1. Asliye Hukuk',
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );

      final rows = await db.casesDao.getAll();
      expect(rows.length, 1);
      expect(rows.first.dosyaNo, '2024/1001');
      expect(rows.first.mahkemeAdi, 'İstanbul 1. Asliye Hukuk');
    });

    test('byDosyaNo mevcut olmayan için null döner', () async {
      final result = await db.casesDao.byDosyaNo('yok/0000');
      expect(result, isNull);
    });

    test('upsert aynı dosyaNo ile günceller, yeni satır açmaz', () async {
      await db.casesDao.upsert(
        CasesCompanion.insert(
          dosyaNo: '2024/1002',
          mahkemeAdi: 'Eski Mahkeme',
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );
      await db.casesDao.upsert(
        CasesCompanion.insert(
          dosyaNo: '2024/1002',
          mahkemeAdi: 'Yeni Mahkeme',
          sonSenkronTarihi: DateTime.utc(2024, 2, 1),
        ),
      );

      final rows = await db.casesDao.getAll();
      expect(rows.length, 1);
      expect(rows.first.mahkemeAdi, 'Yeni Mahkeme');
    });

    test('taraflarJson JSON round-trip doğru çalışır', () async {
      final parties = [
        const Party(ad: 'Ahmet Yılmaz', tip: 'DAVACI'),
        const Party(ad: 'Mehmet Kaya', tip: 'DAVALI', vekil: 'Av. Ali'),
      ];
      await db.casesDao.upsert(
        CasesCompanion.insert(
          dosyaNo: '2024/1003',
          mahkemeAdi: 'Test Mahkeme',
          taraflarJson: Value(parties),
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );

      final row = await db.casesDao.byDosyaNo('2024/1003');
      expect(row, isNotNull);
      expect(row!.taraflarJson.length, 2);
      expect(row.taraflarJson.first.ad, 'Ahmet Yılmaz');
      expect(row.taraflarJson[1].vekil, 'Av. Ali');
    });
  });

  group('Hearings DAO', () {
    late int caseId;

    setUp(() async {
      await db.casesDao.upsert(
        CasesCompanion.insert(
          dosyaNo: '2024/2000',
          mahkemeAdi: 'Test Mahkeme',
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );
      final c = await db.casesDao.byDosyaNo('2024/2000');
      caseId = c!.id;
    });

    test('duruşma ekle ve byCaseId ile geri oku', () async {
      final tarih = DateTime.utc(2025, 3, 15, 9, 30);
      await db.hearingsDao.upsertByCaseAndDate(
        HearingsCompanion.insert(
          caseId: caseId,
          durusmaTarihi: tarih,
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );

      final rows = await db.hearingsDao.byCaseId(caseId);
      expect(rows.length, 1);
      expect(rows.first.durusmaTarihi.isAtSameMomentAs(tarih), isTrue);
    });

    test('idempotent upsert: aynı (caseId, durusmaTarihi) iki kez → 1 satır',
        () async {
      final tarih = DateTime.utc(2025, 4, 10, 14, 0);

      await db.hearingsDao.upsertByCaseAndDate(
        HearingsCompanion.insert(
          caseId: caseId,
          durusmaTarihi: tarih,
          salon: const Value('Salon 1'),
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );
      await db.hearingsDao.upsertByCaseAndDate(
        HearingsCompanion.insert(
          caseId: caseId,
          durusmaTarihi: tarih,
          salon: const Value('Salon 2'),
          sonSenkronTarihi: DateTime.utc(2024, 2, 1),
        ),
      );

      final rows = await db.hearingsDao.byCaseId(caseId);
      expect(rows.length, 1);
      expect(rows.first.salon, 'Salon 2');
    });

    test('getUpcoming yalnızca gelecekteki duruşmaları döndürür', () async {
      final gecmis = DateTime.utc(2020, 1, 1);
      final gelecek = DateTime.utc(2030, 1, 1);

      await db.hearingsDao.upsertByCaseAndDate(
        HearingsCompanion.insert(
          caseId: caseId,
          durusmaTarihi: gecmis,
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );
      await db.hearingsDao.upsertByCaseAndDate(
        HearingsCompanion.insert(
          caseId: caseId,
          durusmaTarihi: gelecek,
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );

      final upcoming = await db.hearingsDao.getUpcoming(DateTime.utc(2025, 1, 1));
      expect(upcoming.length, 1);
      expect(upcoming.first.durusmaTarihi.isAtSameMomentAs(gelecek), isTrue);
    });

    test('setEventId takvim event ID\'sini günceller', () async {
      final tarih = DateTime.utc(2026, 6, 1, 10, 0);
      await db.hearingsDao.upsertByCaseAndDate(
        HearingsCompanion.insert(
          caseId: caseId,
          durusmaTarihi: tarih,
          sonSenkronTarihi: DateTime.utc(2024, 1, 1),
        ),
      );

      final rows = await db.hearingsDao.byCaseId(caseId);
      final hearingId = rows.first.id;

      await db.hearingsDao.setEventId(hearingId, 'cal-event-abc123');

      final updated = await db.hearingsDao.byCaseId(caseId);
      expect(updated.first.takvimEventId, 'cal-event-abc123');
    });
  });

  group('SyncLogs DAO', () {
    test('start ve complete döngüsü', () async {
      final id = await db.syncLogsDao.start();
      expect(id, greaterThan(0));

      await db.syncLogsDao.complete(
        id,
        success: true,
        added: 3,
        updated: 1,
      );

      final lastTs = await db.syncLogsDao.lastSuccessful();
      expect(lastTs, isNotNull);
    });

    test('başarısız senkronizasyon lastSuccessful\'ı etkilemez', () async {
      final id = await db.syncLogsDao.start();
      await db.syncLogsDao.complete(
        id,
        success: false,
        error: 'Network hatası',
      );

      final lastTs = await db.syncLogsDao.lastSuccessful();
      expect(lastTs, isNull);
    });
  });
}
