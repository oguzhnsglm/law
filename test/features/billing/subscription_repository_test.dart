import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/billing/data/subscription_repository.dart';

SubscriptionRepository _makeRepo() {
  FlutterSecureStorage.setMockInitialValues({});
  return SubscriptionRepository();
}

void main() {
  group('SubscriptionRepository', () {
    test('başlangıçta isActive false döner', () async {
      final repo = _makeRepo();
      expect(await repo.isActive(), isFalse);
    });

    test('setActive(true) sonrası isActive true döner', () async {
      final repo = _makeRepo();
      await repo.setActive(true);
      expect(await repo.isActive(), isTrue);
    });

    test('setActive(false) sonrası isActive false döner', () async {
      final repo = _makeRepo();
      await repo.setActive(true);
      await repo.setActive(false);
      expect(await repo.isActive(), isFalse);
    });

    test('roundtrip: true → false → true', () async {
      final repo = _makeRepo();
      await repo.setActive(true);
      expect(await repo.isActive(), isTrue);
      await repo.setActive(false);
      expect(await repo.isActive(), isFalse);
      await repo.setActive(true);
      expect(await repo.isActive(), isTrue);
    });
  });
}
