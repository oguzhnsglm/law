import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'user_profile.dart';

/// Kullanıcı profilini güvenli depoda saklayan repository.
class UserProfileRepository {
  UserProfileRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'user_profile_v1';

  final FlutterSecureStorage _storage;

  Future<UserProfile> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return const UserProfile();
    try {
      return UserProfile.fromJsonString(raw);
    } catch (_) {
      return const UserProfile();
    }
  }

  Future<void> save(UserProfile profile) =>
      _storage.write(key: _key, value: profile.toJsonString());

  Future<void> clear() => _storage.delete(key: _key);
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>(
  (ref) => UserProfileRepository(),
);
