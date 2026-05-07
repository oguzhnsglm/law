import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/parse/parse_result.dart';

/// Bir senkron çalışmasının özet sonucu.
class SyncSummary {
  SyncSummary({
    required this.added,
    required this.updated,
    required this.warnings,
    required this.durationMs,
  });

  final int added;
  final int updated;
  final List<String> warnings;
  final int durationMs;
}

/// ParseResult'ı veritabanına idempotent olarak yazar.
///
/// Akış:
/// 1. `sync_logs.start()` — yeni log kaydı, başlangıç zamanı.
/// 2. Tüm case'leri upsert (dosyaNo unique).
/// 3. Tüm hearing'leri upsert ((caseId, durusmaTarihi) unique).
/// 4. `sync_logs.complete()` — sonuç metrikleri.
///
/// Aynı [ParseResult] iki kez merge edilirse 0 değişiklik olmalı.
class SyncService {
  SyncService(this._db);

  final AppDatabase _db;

  Future<SyncSummary> merge(ParseResult parsed) async {
    final start = DateTime.now();
    final logId = await _db.syncLogsDao.start();

    var added = 0;
    var updated = 0;
    String? error;

    try {
      await _db.transaction(() async {
        // 1. Cases
        for (final companion in parsed.cases) {
          final dosyaNo = companion.dosyaNo.value;
          final existing = await _db.casesDao.byDosyaNo(dosyaNo);
          await _db.casesDao.upsert(companion);
          if (existing == null) {
            added++;
          } else {
            updated++;
          }
        }

        // 2. Hearings — caseId'leri dosyaNo üzerinden çöz
        for (final draft in parsed.hearings) {
          final caseRow = await _db.casesDao.byDosyaNo(draft.dosyaNo);
          if (caseRow == null) continue; // case yoksa hearing'i atla
          final companion = HearingsCompanion.insert(
            caseId: caseRow.id,
            durusmaTarihi: draft.durusmaTarihi,
            salon: Value(draft.salon),
            gundem: Value(draft.gundem),
            sonSenkronTarihi: DateTime.now().toUtc(),
          );
          // upsertByCaseAndDate döndüğünde row değişti mi anlamak için
          // önce kontrol et
          final wasNew = !await _hearingExists(caseRow.id, draft.durusmaTarihi);
          await _db.hearingsDao.upsertByCaseAndDate(companion);
          if (wasNew) {
            added++;
          } else {
            updated++;
          }
        }
      });
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      await _db.syncLogsDao.complete(
        logId,
        success: error == null,
        added: added,
        updated: updated,
        error: error,
      );
    }

    final ms = DateTime.now().difference(start).inMilliseconds;
    return SyncSummary(
      added: added,
      updated: updated,
      warnings: parsed.warnings,
      durationMs: ms,
    );
  }

  Future<bool> _hearingExists(int caseId, DateTime tarih) async {
    final rows = await (_db.select(_db.hearings)
          ..where((t) =>
              t.caseId.equals(caseId) & t.durusmaTarihi.equals(tarih))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncService(db);
});
