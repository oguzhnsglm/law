import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cases/presentation/case_detail_screen.dart';
import '../features/cases/presentation/cases_list_screen.dart';
import '../features/hearings/presentation/hearing_detail_screen.dart';
import '../features/hearings/presentation/hearings_today_screen.dart';
import '../features/onboarding/data/onboarding_completion_repository.dart';
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
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final asyncCompleted = ref.read(onboardingCompletionProvider);
      // İlk açılışta async tamamlanmadan redirect yapma; default placeholder.
      final completed = asyncCompleted.value ?? true;
      final goingToOnboarding = state.matchedLocation == '/onboarding';
      if (!completed && !goingToOnboarding) {
        return '/onboarding';
      }
      if (completed && goingToOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(
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
