import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/onboarding_completion_repository.dart';
import 'onboarding_state.dart';

/// Onboarding akışını yöneten Riverpod controller.
///
/// İzin akışı için [PermissionRequester] enjekte edilir; testlerde fake bir
/// implementasyon verilebilir. Üretimde [defaultPermissionRequester] gerçek
/// `permission_handler` paketini kullanır (UI tarafında platform native
/// dialog açar).
class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void goToPage(int index) {
    state = state.copyWith(currentPage: index);
  }

  void next() {
    if (!state.canAdvance) return;
    if (state.currentPage < OnboardingState.totalPages - 1) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void back() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void setKvkkAccepted(bool value) {
    state = state.copyWith(kvkkAccepted: value);
  }

  void setCrashReporting(bool value) {
    state = state.copyWith(crashReportingOptIn: value);
  }

  void markCalendarPermission(bool granted) {
    state = state.copyWith(calendarPermissionGranted: granted);
  }

  void markNotificationPermission(bool granted) {
    state = state.copyWith(notificationPermissionGranted: granted);
  }

  /// Onboarding'i bitirir, secure storage'a flag yazar.
  ///
  /// Çağrı sırasında [completing]=true; bittiğinde [OnboardingState] resetlenmez,
  /// çağıran tarafın navigation'a geçmesi beklenir.
  Future<void> complete() async {
    if (state.completing) return;
    state = state.copyWith(completing: true);
    final repo = ref.read(onboardingCompletionRepositoryProvider);
    await repo.markCompleted();
    state = state.copyWith(completing: false);
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);
