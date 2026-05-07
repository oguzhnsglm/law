import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Onboarding tamamlanma flag'ini kalıcı saklayan repository.
///
/// Flag platform güvenli deposunda (Keychain/Keystore) tutulur; uygulamanın
/// ilk açılışta onboarding'i atlatıp atlatmaması bu değere göre belirlenir.
class OnboardingCompletionRepository {
  OnboardingCompletionRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'onboarding_completed_v1';

  final FlutterSecureStorage _storage;

  Future<bool> isCompleted() async {
    final value = await _storage.read(key: _key);
    return value == 'true';
  }

  Future<void> markCompleted() => _storage.write(key: _key, value: 'true');

  Future<void> reset() => _storage.delete(key: _key);
}

final onboardingCompletionRepositoryProvider =
    Provider<OnboardingCompletionRepository>(
  (ref) => OnboardingCompletionRepository(),
);
