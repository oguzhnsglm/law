import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/auth/presentation/register_screen.dart';
import 'package:law/features/auth/state/auth_controller.dart';

Widget _wrapRegister() {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) async => null),
    ],
    child: const MaterialApp(home: RegisterScreen()),
  );
}

void main() {
  group('RegisterScreen', () {
    testWidgets('temel widget\'lar render edilir', (tester) async {
      await tester.pumpWidget(_wrapRegister());
      await tester.pump();

      expect(find.text('Kayıt Ol'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(
        find.text('Zaten hesabın var mı? Giriş yap'),
        findsOneWidget,
      );
    });

    testWidgets('cihazda saklanır notu gösterilir', (tester) async {
      await tester.pumpWidget(_wrapRegister());
      await tester.pump();

      expect(
        find.textContaining('yalnızca bu cihazda saklanır'),
        findsOneWidget,
      );
    });

    testWidgets('boş form gönderilince doğrulama hataları gösterilir',
        (tester) async {
      await tester.pumpWidget(_wrapRegister());
      await tester.pump();

      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      expect(find.text('Ad soyad giriniz'), findsOneWidget);
    });

    testWidgets('geçersiz e-posta formatı hata gösterir', (tester) async {
      await tester.pumpWidget(_wrapRegister());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'gecersiz-email',
      );
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      expect(find.text('Geçerli bir e-posta adresi giriniz'), findsOneWidget);
    });

    testWidgets('şifre uzunluk hatası gösterir', (tester) async {
      await tester.pumpWidget(_wrapRegister());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@test.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '123');
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      expect(find.text('Şifre en az 6 karakter olmalı'), findsOneWidget);
    });

    testWidgets('şifre eşleşmeme hatası gösterir', (tester) async {
      await tester.pumpWidget(_wrapRegister());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@test.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'pass123');
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'farkli123',
      );
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      expect(find.text('Şifreler eşleşmiyor'), findsOneWidget);
    });
  });
}
