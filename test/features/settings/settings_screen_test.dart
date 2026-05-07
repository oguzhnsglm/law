import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/settings/data/notification_prefs.dart';
import 'package:law/features/settings/data/user_profile.dart';
import 'package:law/features/settings/presentation/settings_screen.dart';
import 'package:law/features/settings/state/settings_controller.dart';

class _StubController extends SettingsController {
  _StubController(this._initial);

  final SettingsState _initial;

  @override
  Future<SettingsState> build() async => _initial;

  @override
  Future<void> updateProfile(UserProfile profile) async {
    state = AsyncValue.data(state.requireValue.copyWith(profile: profile));
  }

  @override
  Future<void> updateNotifications(NotificationPrefs prefs) async {
    state = AsyncValue.data(state.requireValue.copyWith(notifications: prefs));
  }
}

Widget _wrap(SettingsState initial) {
  return ProviderScope(
    overrides: [
      settingsControllerProvider.overrideWith(() => _StubController(initial)),
    ],
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void main() {
  group('SettingsScreen', () {
    testWidgets('boş profil için "Henüz girilmedi" gösterir', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SettingsState(
            profile: UserProfile(),
            notifications: NotificationPrefs(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profil bilgilerim'), findsOneWidget);
      expect(find.text('Henüz girilmedi'), findsOneWidget);
    });

    testWidgets('dolu profil için ad ve sicil gösterilir', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SettingsState(
            profile: UserProfile(
              ad: 'Mert',
              soyad: 'Yıldız',
              baroSicil: '12345',
            ),
            notifications: NotificationPrefs(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Mert Yıldız'), findsOneWidget);
      expect(find.textContaining('12345'), findsOneWidget);
    });

    testWidgets(
      'bildirim toggle off iken alt switch\'ler disabled olur',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SettingsState(
              profile: UserProfile(),
              notifications: NotificationPrefs(notificationsEnabled: false),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final SwitchListTile oneDay = tester.widget(
          find.widgetWithText(SwitchListTile, '1 gün önce'),
        );
        expect(oneDay.onChanged, isNull);

        final SwitchListTile twoHrs = tester.widget(
          find.widgetWithText(SwitchListTile, '2 saat önce'),
        );
        expect(twoHrs.onChanged, isNull);
      },
    );

    testWidgets(
      'tüm verilerimi sil onay dialog\'unu açar ve "İptal" basarak kapatır',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SettingsState(
              profile: UserProfile(),
              notifications: NotificationPrefs(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tüm verilerimi sil'));
        await tester.pumpAndSettle();

        expect(find.text('Tüm verileri sil'), findsOneWidget);
        expect(
          find.textContaining('Bu işlem geri alınamaz'),
          findsOneWidget,
        );

        await tester.tap(find.widgetWithText(TextButton, 'İptal'));
        await tester.pumpAndSettle();

        expect(find.text('Tüm verileri sil'), findsNothing);
      },
    );

    testWidgets(
      'profil bilgileri tıklanınca düzenleme dialogu açılır',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const SettingsState(
              profile: UserProfile(),
              notifications: NotificationPrefs(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Profil bilgilerim'));
        await tester.pumpAndSettle();

        expect(find.text('Profil Bilgileri'), findsOneWidget);
        expect(find.widgetWithText(TextField, ''), findsWidgets);
        expect(find.widgetWithText(FilledButton, 'Kaydet'), findsOneWidget);
      },
    );
  });
}
