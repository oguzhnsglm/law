import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/state/auth_controller.dart';
import '../features/billing/presentation/paywall_screen.dart';
import '../features/billing/state/subscription_controller.dart';
import '../features/cases/presentation/case_detail_screen.dart';
import '../features/cases/presentation/cases_list_screen.dart';
import '../features/hearings/presentation/hearing_detail_screen.dart';
import '../features/hearings/presentation/hearings_today_screen.dart';
import '../features/onboarding/data/onboarding_completion_repository.dart';
import '../features/onboarding/data/real_permission_asker.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/sync/presentation/sync_webview_screen.dart';

/// Onboarding tamamlanma durumunu izleyen async provider.
///
/// Router'ın redirect logic'i bu değere bakar. Onboarding tamamlanınca
/// `OnboardingScreen.onCompleted` callback'i bu provider'ı invalidate eder
/// ve router otomatik `/`'a yönlendirir.
final onboardingCompletionProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(onboardingCompletionRepositoryProvider);
  return repo.isCompleted();
});

/// Uygulamanın ana router'ı.
///
/// Redirect önceliği:
///  1. Hesap yoksa → /register
///  2. Hesap var ama oturum yok → /login
///  3. Oturum var ama onboarding bitmemiş → /onboarding
///  4. Onboarding tamam ama abonelik yok → /paywall
///  5. Aksi hâlde redirect yok.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loc = state.matchedLocation;

      // ── 1. Hesap kontrolü ────────────────────────────────────────────────
      final asyncAuth = ref.read(authStateProvider);
      final authLoading = asyncAuth.isLoading;

      if (!authLoading) {
        final hasSession = asyncAuth.value != null;

        // Hesap/oturum yok → register veya login sayfasına yönlendir.
        if (!hasSession) {
          if (loc != '/register' && loc != '/login') {
            // Hesap yoksa register'a; varsa login'e gönder.
            // Bunu ayırt etmek için senkron bir sinyal gerekiyor.
            // Pragmatik çözüm: /register'a yönlendir; register screen içinde
            // hesap zaten varsa "Bu cihazda hesap var" uyarısı çıkar ve
            // kullanıcı /login'e geçer.
            return '/register';
          }
          return null;
        }
      }

      // ── 2-4. Onboarding + abonelik (sadece oturum varsa) ────────────────
      final account = asyncAuth.value;
      if (account != null) {
        // 3. Onboarding kontrolü
        final asyncCompleted = ref.read(onboardingCompletionProvider);
        final completed = asyncCompleted.value ?? true;
        final goingToOnboarding = loc == '/onboarding';

        if (!completed && !goingToOnboarding) {
          return '/onboarding';
        }
        if (completed && goingToOnboarding) {
          return '/';
        }

        // 4. Abonelik kontrolü
        if (completed) {
          final asyncSub = ref.read(subscriptionStatusProvider);
          final isActive = asyncSub.value ?? true; // loading → geç
          if (!isActive && loc != '/paywall') {
            return '/paywall';
          }
        }
      }

      return null;
    },
    routes: [
      // ── Auth ─────────────────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // ── Paywall ──────────────────────────────────────────────────────────
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      // ── Onboarding ───────────────────────────────────────────────────────
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(
          permissionAsker: const RealPermissionAsker(),
          onCompleted: () async {
            final repo = ref.read(onboardingCompletionRepositoryProvider);
            await repo.markCompleted();
            ref.invalidate(onboardingCompletionProvider);
            if (context.mounted) {
              context.go('/');
            }
          },
        ),
      ),
      // ── Shell (ana ekranlar) ─────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HearingsTodayScreen(),
          ),
          GoRoute(
            path: '/cases',
            builder: (context, state) => const CasesListScreen(),
          ),
          GoRoute(
            path: '/sync',
            builder: (context, state) => const SyncWebViewScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/case/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CaseDetailScreen(caseId: id);
        },
      ),
      GoRoute(
        path: '/hearing/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return HearingDetailScreen(hearingId: id);
        },
      ),
    ],
  );
});
