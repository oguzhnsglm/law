import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'notification_prefs.dart';

class NotificationPrefsRepository {
  NotificationPrefsRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'notification_prefs_v1';

  final FlutterSecureStorage _storage;

  Future<NotificationPrefs> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return const NotificationPrefs();
    try {
      return NotificationPrefs.fromJsonString(raw);
    } catch (_) {
      return const NotificationPrefs();
    }
  }

  Future<void> save(NotificationPrefs prefs) =>
      _storage.write(key: _key, value: prefs.toJsonString());

  Future<void> clear() => _storage.delete(key: _key);
}

final notificationPrefsRepositoryProvider =
    Provider<NotificationPrefsRepository>(
  (ref) => NotificationPrefsRepository(),
);
