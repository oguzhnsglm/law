import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_account.dart';
import '../data/auth_repository.dart';

export '../data/auth_account.dart';
export '../data/auth_repository.dart' show AuthException;

/// Anlık oturum durumu: aktif hesap ya da null.
final authStateProvider = FutureProvider<AuthAccount?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentAccount();
});

/// Kimlik doğrulama işlemlerini yöneten notifier.
class AuthController extends AsyncNotifier<AuthAccount?> {
  @override
  Future<AuthAccount?> build() {
    final repo = ref.watch(authRepositoryProvider);
    return repo.currentAccount();
  }

  /// Yeni hesap oluşturur ve oturumu güncellemez (kullanıcı giriş yapacak).
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    ref.invalidate(authStateProvider);
  }

  /// Giriş yapar; başarılı olursa state güncellenir.
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    final account = await repo.login(email: email, password: password);
    ref.invalidate(authStateProvider);
    return account;
  }

  /// Oturumu kapatır.
  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    ref.invalidate(authStateProvider);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthAccount?>(
  AuthController.new,
);
