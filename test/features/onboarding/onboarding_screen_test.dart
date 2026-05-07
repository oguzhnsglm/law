import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/onboarding/data/onboarding_completion_repository.dart';
import 'package:law/features/onboarding/presentation/onboarding_screen.dart';
import 'package:law/features/onboarding/presentation/pages/permissions_page.dart';

class _InMemoryCompletionRepo extends OnboardingCompletionRepository {
  _InMemoryCompletionRepo();

  bool _completed = false;

  @override
  Future<bool> isCompleted() async => _completed;

  @override
  Future<void> markCompleted() async {
    _completed = true;
  }

  @override
  Future<void> reset() async {
    _completed = false;
  }
}

Widget _wrap(
  Widget child, {
  required _InMemoryCompletionRepo repo,
}) {
  return ProviderScope(
    overrides: [
      onboardingCompletionRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  group('OnboardingScreen', () {
    testWidgets(
      'welcome sayfasında "Devam Et" görünür ve hoşgeldin başlığı vardır',
      (tester) async {
        final repo = _InMemoryCompletionRepo();
        await tester.pumpWidget(
          _wrap(
            OnboardingScreen(onCompleted: () {}),
            repo: repo,
          ),
        );

        expect(find.text('Avukatın yeni asistanı'), findsOneWidget);
        expect(find.text('Devam Et'), findsOneWidget);
      },
    );

    testWidgets(
      'KVKK rıza onaylanana kadar consent sayfasında ileri butonu disabled',
      (tester) async {
        final repo = _InMemoryCompletionRepo();
        await tester.pumpWidget(
          _wrap(
            OnboardingScreen(onCompleted: () {}),
            repo: repo,
          ),
        );

        // Welcome → Consent
        await tester.tap(find.text('Devam Et'));
        await tester.pumpAndSettle();

        // Consent sayfasındayız; "Devam Et" butonu disabled olmalı.
        final FilledButton primaryBefore = tester.widget(
          find.byType(FilledButton),
        );
        expect(primaryBefore.onPressed, isNull);

        // KVKK checkbox'ını işaretle.
        await tester.tap(find.byType(Checkbox).first);
        await tester.pumpAndSettle();

        final FilledButton primaryAfter = tester.widget(
          find.byType(FilledButton),
        );
        expect(primaryAfter.onPressed, isNotNull);
      },
    );

    testWidgets(
      'son sayfada "İlk Senkronu Başlat" butonuna basılınca onCompleted çağrılır',
      (tester) async {
        final repo = _InMemoryCompletionRepo();
        var completedCalled = false;

        await tester.pumpWidget(
          _wrap(
            OnboardingScreen(
              onCompleted: () => completedCalled = true,
              permissionAsker: const FakePermissionAsker(),
            ),
            repo: repo,
          ),
        );

        // Welcome → Consent
        await tester.tap(find.text('Devam Et'));
        await tester.pumpAndSettle();

        // Consent KVKK işaretle
        await tester.tap(find.byType(Checkbox).first);
        await tester.pumpAndSettle();

        // Consent → DataSource
        await tester.tap(find.text('Devam Et'));
        await tester.pumpAndSettle();

        // DataSource → Permissions
        await tester.tap(find.text('Devam Et'));
        await tester.pumpAndSettle();

        // Permissions sayfası — "İlk Senkronu Başlat"
        expect(find.text('İlk Senkronu Başlat'), findsOneWidget);
        await tester.tap(find.text('İlk Senkronu Başlat'));
        await tester.pumpAndSettle();

        expect(completedCalled, isTrue);
        expect(await repo.isCompleted(), isTrue);
      },
    );

    testWidgets(
      'welcome sayfasında "Atla" linki son sayfaya götürür',
      (tester) async {
        final repo = _InMemoryCompletionRepo();
        await tester.pumpWidget(
          _wrap(
            OnboardingScreen(
              onCompleted: () {},
              permissionAsker: const FakePermissionAsker(),
            ),
            repo: repo,
          ),
        );

        expect(find.text('Atla'), findsOneWidget);
        await tester.tap(find.text('Atla'));
        await tester.pumpAndSettle();

        // Son sayfa CTA'sı görünmeli
        expect(find.text('İlk Senkronu Başlat'), findsOneWidget);
      },
    );
  });
}
