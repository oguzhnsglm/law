import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/security/secure_key_provider.dart';

/// Uygulama genelinde tek [AppDatabase] örneği sağlayan Riverpod provider.
///
/// Veritabanı ilk kez talep edildiğinde:
/// 1. Platform güvenli deposundan (Keychain/Keystore) şifreleme anahtarı alınır.
/// 2. `PRAGMA key` ve `PRAGMA foreign_keys` set edilir.
/// 3. Arka planda bağlantı açılır.
///
/// NOT: SQLCipher native kütüphanesi (libsqlcipher) iOS/Android native
/// yapılandırmasında ayrıca bağlanmalıdır. Bu provider yalnızca Dart tarafını
/// kurar; native setup `android/app/build.gradle` ve `ios/Podfile` içinde
/// yapılır.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in ProviderScope. '
    'Call openAppDatabase() first.',
  );
});

/// Şifreli [AppDatabase] örneği oluşturur.
///
/// Bu fonksiyon uygulamanın başlangıcında (main veya runApp öncesi) çağrılmalı
/// ve dönen değer ProviderScope override'ı olarak verilmelidir:
/// ```dart
/// final db = await openAppDatabase();
/// runApp(ProviderScope(
///   overrides: [appDatabaseProvider.overrideWithValue(db)],
///   child: const MyApp(),
/// ));
/// ```
Future<AppDatabase> openAppDatabase() async {
  final key = await SecureKeyProvider().getOrCreateDatabaseKey();

  final dir = await getApplicationSupportDirectory();
  final dbFile = File(p.join(dir.path, 'law_app.db'));

  final executor = NativeDatabase.createInBackground(
    dbFile,
    setup: (db) {
      // SQLCipher şifreleme anahtarı. Native SQLCipher lib yüklü olduğunda
      // bu PRAGMA veritabanı şifresini açar/oluşturur.
      db.execute("PRAGMA key = '$key';");
      // Yabancı anahtar kısıtlamalarını etkinleştir (ON DELETE CASCADE vb.).
      db.execute('PRAGMA foreign_keys = ON;');
    },
  );

  return AppDatabase(executor);
}
