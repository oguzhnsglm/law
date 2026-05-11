// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_account.dart';

/// Kimlik doğrulama hatası.
///
/// [message] kullanıcıya gösterilmek üzere Türkçe yazılır.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Yerel kimlik doğrulama depolaması.
///
/// ÖNEMLİ: Kullanıcı şifresi hiçbir zaman sunucuya gönderilmez.
/// Tüm veriler cihaz üzerindeki flutter_secure_storage (Keychain/Keystore)
/// içinde tutulur. Hash: sha256(salt + password).
class AuthRepository {
  AuthRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _keyAccount = 'auth_account_v1';
  static const _keySession = 'auth_session_v1';

  final FlutterSecureStorage _storage;

  /// Cihazda kayıtlı bir hesap olup olmadığını döndürür.
  Future<bool> hasAccount() async {
    final val = await _storage.read(key: _keyAccount);
    return val != null;
  }

  /// Yeni hesap oluşturur.
  ///
  /// 16-byte rastgele salt üretilir; `sha256(salt || password)` hex olarak
  /// saklanır. Şifre asla düz metin olarak yazılmaz.
  ///
  /// Cihazda zaten bir hesap varsa [AuthException] fırlatır.
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (await hasAccount()) {
      throw const AuthException('Bu cihazda zaten bir hesap var');
    }

    final salt = _generateSalt();
    final hash = _hashPassword(salt: salt, password: password);

    final record = {
      'email': email,
      'displayName': displayName,
      'salt': salt,
      'hash': hash,
    };

    await _storage.write(
      key: _keyAccount,
      value: jsonEncode(record),
    );
  }

  /// Kullanıcıyı doğrular; başarılı olursa [AuthAccount] döndürür.
  ///
  /// E-posta veya şifre hatalıysa [AuthException] fırlatır.
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async {
    final raw = await _storage.read(key: _keyAccount);
    if (raw == null) {
      throw const AuthException('E-posta veya şifre hatalı');
    }

    final record = jsonDecode(raw) as Map<String, dynamic>;
    final storedEmail = record['email'] as String;
    final storedSalt = record['salt'] as String;
    final storedHash = record['hash'] as String;

    if (storedEmail != email) {
      throw const AuthException('E-posta veya şifre hatalı');
    }

    final computedHash = _hashPassword(salt: storedSalt, password: password);
    if (computedHash != storedHash) {
      throw const AuthException('E-posta veya şifre hatalı');
    }

    await _storage.write(key: _keySession, value: 'active');

    return AuthAccount(
      email: storedEmail,
      displayName: record['displayName'] as String,
    );
  }

  /// Oturumu kapatır; hesap verisi silinmez — kullanıcı tekrar giriş yapabilir.
  Future<void> logout() async {
    await _storage.delete(key: _keySession);
  }

  /// Aktif oturum varsa [AuthAccount] döndürür, yoksa null.
  Future<AuthAccount?> currentAccount() async {
    final session = await _storage.read(key: _keySession);
    if (session != 'active') return null;

    final raw = await _storage.read(key: _keyAccount);
    if (raw == null) return null;

    final record = jsonDecode(raw) as Map<String, dynamic>;
    return AuthAccount(
      email: record['email'] as String,
      displayName: record['displayName'] as String,
    );
  }

  // ── private helpers ──────────────────────────────────────────────────────

  String _generateSalt() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  String _hashPassword({required String salt, required String password}) {
    final data = utf8.encode('$salt$password');
    return sha256.convert(data).toString();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);
