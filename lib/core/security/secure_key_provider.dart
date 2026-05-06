import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Veritabanı şifreleme anahtarını yöneten sınıf.
///
/// Anahtar ilk erişimde oluşturulur ve platform güvenli deposuna (Keychain /
/// Keystore) [_keyAlias] ile kaydedilir. MVP boyunca rotasyon yapılmaz.
class SecureKeyProvider {
  SecureKeyProvider({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _keyAlias = 'db_master_key_v1';

  final FlutterSecureStorage _storage;

  /// Mevcut veritabanı anahtarını döndürür; yoksa 32 byte rastgele anahtar
  /// oluşturur, depoya kaydeder ve döndürür.
  ///
  /// Dönen değer 64 karakterlik hex string (32 byte = 256-bit AES).
  Future<String> getOrCreateDatabaseKey() async {
    final existing = await _storage.read(key: _keyAlias);
    if (existing != null && existing.isNotEmpty) return existing;

    final key = _generateHexKey();
    await _storage.write(key: _keyAlias, value: key);
    return key;
  }

  /// 32 byte rastgele veri üretip hex string olarak döndürür.
  String _generateHexKey() {
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
