import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_prefs.dart';
import '../data/notification_prefs_repository.dart';
import '../data/user_profile.dart';
import '../data/user_profile_repository.dart';

/// Ayarlar sekmesinin birleşik durumu.
class SettingsState {
  const SettingsState({
    required this.profile,
    required this.notifications,
    this.loading = false,
  });

  final UserProfile profile;
  final NotificationPrefs notifications;
  final bool loading;

  SettingsState copyWith({
    UserProfile? profile,
    NotificationPrefs? notifications,
    bool? loading,
  }) {
    return SettingsState(
      profile: profile ?? this.profile,
      notifications: notifications ?? this.notifications,
      loading: loading ?? this.loading,
    );
  }

  static const SettingsState initial = SettingsState(
    profile: UserProfile(),
    notifications: NotificationPrefs(),
    loading: true,
  );
}

class SettingsController extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    final profile = await ref.read(userProfileRepositoryProvider).load();
    final prefs = await ref.read(notificationPrefsRepositoryProvider).load();
    return SettingsState(profile: profile, notifications: prefs);
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = AsyncValue.data(
      (state.value ?? SettingsState.initial).copyWith(profile: profile),
    );
    await ref.read(userProfileRepositoryProvider).save(profile);
  }

  Future<void> updateNotifications(NotificationPrefs prefs) async {
    state = AsyncValue.data(
      (state.value ?? SettingsState.initial)
          .copyWith(notifications: prefs),
    );
    await ref.read(notificationPrefsRepositoryProvider).save(prefs);
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, SettingsState>(
  SettingsController.new,
);
