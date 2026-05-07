import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/database_provider.dart';

import 'notification_prefs_repository.dart';
import 'user_profile_repository.dart';

/// "Tüm verilerimi sil" akışını yürüten servis.
///
/// Yerel veritabanındaki tüm tabloları boşaltır, ayarları ve profil bilgisini
/// güvenli depodan temizler. Şifreleme anahtarı (db_master_key_v1) ve
/// onboarding flag'i bu serviste BIRAKILIR — kullanıcı uygulamayı sonradan
/// açabilsin diye. Master key reset gerekirse uygulama yeniden kurulmalı.
class DataPurgeService {
  DataPurgeService({
    required this.db,
    required this.profileRepo,
    required this.prefsRepo,
  });

  final AppDatabase db;
  final UserProfileRepository profileRepo;
  final NotificationPrefsRepository prefsRepo;

  Future<void> purgeAll() async {
    await db.transaction(() async {
      await db.delete(db.userNotes).go();
      await db.delete(db.hearings).go();
      await db.delete(db.cases).go();
      await db.delete(db.syncLogs).go();
    });
    await profileRepo.clear();
    await prefsRepo.clear();
  }
}

final dataPurgeServiceProvider = Provider<DataPurgeService>((ref) {
  return DataPurgeService(
    db: ref.watch(appDatabaseProvider),
    profileRepo: ref.watch(userProfileRepositoryProvider),
    prefsRepo: ref.watch(notificationPrefsRepositoryProvider),
  );
});
