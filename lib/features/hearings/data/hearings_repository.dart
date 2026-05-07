import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/database_provider.dart';

import 'hearing_view_model.dart';

/// Duruşma + dosya birleştirilmiş UI verisini sağlayan repository.
///
/// İki ayrı DAO'yu (HearingsDao, CasesDao) tek bir UI-dostu stream'de toplar.
class HearingsRepository {
  HearingsRepository(this._db);

  final AppDatabase _db;

  /// Verilen [now]'dan itibaren yaklaşan duruşmaları view model olarak yayınlar.
  ///
  /// Her DAO emit'inde dosya tablosunun anlık snapshot'ı çekilip lookup map
  /// kurulur; cases tablosu küçük olduğu için bu eş zamanlama ucuzdur.
  Stream<List<HearingViewModel>> watchUpcoming(DateTime now) async* {
    final hearingsDao = _db.hearingsDao;
    final casesDao = _db.casesDao;
    await for (final hearings in hearingsDao.watchUpcoming(now)) {
      final cases = await casesDao.getAll();
      final byId = <int, Case>{for (final c in cases) c.id: c};
      yield [
        for (final h in hearings)
          HearingViewModel(
            hearing: h,
            dosyaNo: byId[h.caseId]?.dosyaNo,
            mahkemeAdi: byId[h.caseId]?.mahkemeAdi ?? '',
          ),
      ];
    }
  }
}

final hearingsRepositoryProvider = Provider<HearingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return HearingsRepository(db);
});
