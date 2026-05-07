import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/onboarding/data/onboarding_completion_repository.dart';
import 'package:law/features/onboarding/state/onboarding_controller.dart';
import 'package:law/features/onboarding/state/onboarding_state.dart';

class _MemRepo extends OnboardingCompletionRepository {
  _MemRepo();

  bool flag = false;

  @override
  Future<bool> isCompleted() async => flag;

  @override
  Future<void> markCompleted() async {
    flag = true;
  }
}

ProviderContainer _container(_MemRepo repo) {
  return ProviderContainer(
    overrides: [
      onboardingCompletionRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  group('OnboardingController', () {
    test('başlangıç durumu: ilk sayfa, hiçbir rıza yok', () {
      final repo = _MemRepo();
      final c = _container(repo);
      addTearDown(c.dispose);

      final state = c.read(onboardingControllerProvider);
      expect(state.currentPage, 0);
      expect(state.kvkkAccepted, isFalse);
      expect(state.isLastPage, isFalse);
    });

    test(
      'consent sayfasında canAdvance, KVKK onayı verilene kadar false',
      () {
        final repo = _MemRepo();
        final c = _container(repo);
        addTearDown(c.dispose);

        final ctrl = c.read(onboardingControllerProvider.notifier);
        ctrl.next(); // 0 -> 1 (consent)
        expect(c.read(onboardingControllerProvider).currentPage, 1);
        expect(c.read(onboardingControllerProvider).canAdvance, isFalse);

        ctrl.setKvkkAccepted(true);
        expect(c.read(onboardingControllerProvider).canAdvance, isTrue);
      },
    );

    test('next() son sayfayı geçmez', () {
      final repo = _MemRepo();
      final c = _container(repo);
      addTearDown(c.dispose);

      final ctrl = c.read(onboardingControllerProvider.notifier);
      ctrl.setKvkkAccepted(true);
      for (var i = 0; i < OnboardingState.totalPages + 5; i++) {
        ctrl.next();
      }
      expect(
        c.read(onboardingControllerProvider).currentPage,
        OnboardingState.totalPages - 1,
      );
      expect(c.read(onboardingControllerProvider).isLastPage, isTrue);
    });

    test('complete() repo flag\'ini set eder', () async {
      final repo = _MemRepo();
      final c = _container(repo);
      addTearDown(c.dispose);

      final ctrl = c.read(onboardingControllerProvider.notifier);
      await ctrl.complete();
      expect(repo.flag, isTrue);
    });

    test('back() ilk sayfanın altına inmez', () {
      final repo = _MemRepo();
      final c = _container(repo);
      addTearDown(c.dispose);

      final ctrl = c.read(onboardingControllerProvider.notifier);
      ctrl.back();
      ctrl.back();
      expect(c.read(onboardingControllerProvider).currentPage, 0);
    });
  });
}
