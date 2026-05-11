import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/auth/data/auth_repository.dart';

/// In-memory FlutterSecureStorage shim: depoyu Map ile simüle eder.
///
/// flutter_secure_storage'ın test modunu kullanır:
/// `FlutterSecureStorage.setMockInitialValues({})` MethodChannel mock kurar.
AuthRepository _makeRepo() {
  // Her test için temiz bir MockStorage başlat.
  FlutterSecureStorage.setMockInitialValues({});
  return AuthRepository();
}

void main() {
  group('AuthRepository', () {
    test('kayıt sonrası hasAccount true döner', () async {
      final repo = _makeRepo();
      expect(await repo.hasAccount(), isFalse);
      await repo.register(
        email: 'test@example.com',
        password: 'secret123',
        displayName: 'Test User',
      );
      expect(await repo.hasAccount(), isTrue);
    });

    test('kayıt + doğru şifre ile login AuthAccount döndürür', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'avukat@hukuk.com',
        password: 'P@ssw0rd',
        displayName: 'Av. Mert',
      );
      final account = await repo.login(
        email: 'avukat@hukuk.com',
        password: 'P@ssw0rd',
      );
      expect(account.email, 'avukat@hukuk.com');
      expect(account.displayName, 'Av. Mert');
    });

    test('yanlış şifre ile login AuthException fırlatır', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'av@hukuk.com',
        password: 'dogrususifre',
        displayName: 'Av.',
      );
      expect(
        () => repo.login(email: 'av@hukuk.com', password: 'yanlissifre'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            contains('hatalı'),
          ),
        ),
      );
    });

    test('yanlış e-posta ile login AuthException fırlatır', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'gercek@hukuk.com',
        password: 'sifre123',
        displayName: 'Av.',
      );
      expect(
        () => repo.login(email: 'yanlis@hukuk.com', password: 'sifre123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('çift kayıt AuthException fırlatır', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'a@b.com',
        password: '123456',
        displayName: 'A',
      );
      expect(
        () => repo.register(
          email: 'b@c.com',
          password: '654321',
          displayName: 'B',
        ),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            contains('zaten'),
          ),
        ),
      );
    });

    test('logout sonrası currentAccount null döner', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'x@y.com',
        password: 'abc123',
        displayName: 'X',
      );
      await repo.login(email: 'x@y.com', password: 'abc123');
      expect(await repo.currentAccount(), isNotNull);

      await repo.logout();
      expect(await repo.currentAccount(), isNull);
    });

    test('logout sonrası tekrar login yapılabilir', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'y@z.com',
        password: 'pass99',
        displayName: 'Y',
      );
      await repo.login(email: 'y@z.com', password: 'pass99');
      await repo.logout();

      final account = await repo.login(email: 'y@z.com', password: 'pass99');
      expect(account.email, 'y@z.com');
    });

    test('currentAccount oturum açıkken hesabı döndürür', () async {
      final repo = _makeRepo();
      await repo.register(
        email: 'z@w.com',
        password: 'zw1234',
        displayName: 'Z',
      );
      expect(await repo.currentAccount(), isNull); // henüz login yok
      await repo.login(email: 'z@w.com', password: 'zw1234');
      final acc = await repo.currentAccount();
      expect(acc, isNotNull);
      expect(acc!.email, 'z@w.com');
    });
  });
}
