import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/auth/presentation/login_screen.dart';
import 'package:law/features/auth/state/auth_controller.dart';

/// Stub AuthController: login her zaman başarısız olur.
class _FailingAuthController extends AuthController {
  @override
  Future<AuthAccount?> build() async => null;

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async {
    throw const AuthException('E-posta veya şifre hatalı');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {}
}

Widget _wrapLogin({AuthController Function()? controllerFactory}) {
  return ProviderScope(
    overrides: [
      if (controllerFactory != null)
        authControllerProvider.overrideWith(controllerFactory),
      authStateProvider.overrideWith((ref) async => null),
    ],
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  group('LoginScreen', () {
    testWidgets('temel widget\'lar render edilir', (tester) async {
      await tester.pumpWidget(_wrapLogin());
      await tester.pump();

      expect(find.text('Giriş Yap'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(
        find.text('Hesabın yok mu? Kayıt ol'),
        findsOneWidget,
      );
    });

    testWidgets('boş form gönderilince doğrulama hatası gösterilir',
        (tester) async {
      await tester.pumpWidget(_wrapLogin());
      await tester.pump();

      // "Giriş Yap" FilledButton'a bas (AppBar'daki Text değil).
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      expect(find.text('E-posta boş olamaz'), findsOneWidget);
    });

    testWidgets('hatalı şifre ile giriş hata mesajı gösterir', (tester) async {
      await tester.pumpWidget(
        _wrapLogin(controllerFactory: _FailingAuthController.new),
      );
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@test.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'yanlis',
      );
      await tester.tap(find.byType(FilledButton).first);
      await tester.pumpAndSettle();

      expect(find.text('E-posta veya şifre hatalı'), findsOneWidget);
    });
  });
}
