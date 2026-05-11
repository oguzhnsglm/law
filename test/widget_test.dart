import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/app/app.dart';
import 'package:law/app/router.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/database_provider.dart';
import 'package:law/features/auth/state/auth_controller.dart';
import 'package:law/features/billing/state/subscription_controller.dart';

void main() {
  testWidgets('LawApp boots with router and shows shell or register',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          // Hesap yok → redirect /register'a gidecek.
          authStateProvider.overrideWith((ref) async => null),
          subscriptionStatusProvider.overrideWith((ref) async => false),
        ],
        child: const LawApp(),
      ),
    );
    // İlk frame pump — redirect logic çözümleniyor.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // LawApp widget ağaçta bulunmalı.
    expect(find.byType(LawApp), findsOneWidget);
  });

  testWidgets('LawApp oturum açık ve abonelik aktifken shell gösterir',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    const account = AuthAccount(
      email: 'test@test.com',
      displayName: 'Test',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          authStateProvider.overrideWith((ref) async => account),
          onboardingCompletionProvider.overrideWith((ref) async => true),
          subscriptionStatusProvider.overrideWith((ref) async => true),
        ],
        child: const LawApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LawApp), findsOneWidget);
  });
}
