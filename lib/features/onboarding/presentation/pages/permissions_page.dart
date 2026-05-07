import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/onboarding_controller.dart';

/// İzin sayfası — takvim ve bildirim izinleri.
///
/// Gerçek izin diyalogları platform tarafından `permission_handler` paketi
/// üzerinden tetiklenir. Bu sayfada tetikleyici callback bir [PermissionAsker]
/// üzerinden alınır; widget testlerinde sahte bir asker enjekte edilebilir.
class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({this.asker, super.key});

  /// Test'lerde override edilebilir; null ise gerçek (platform) sorgusu yapılır.
  final PermissionAsker? asker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final effectiveAsker = asker ?? const PermissionAsker();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Birkaç İzin Lazım',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Aşağıdaki izinler uygulamanın çalışması için gerekli. '
            '"Şimdi değil" diyebilir, sonra Ayarlar üzerinden açabilirsiniz.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _PermissionCard(
            icon: Icons.calendar_today_outlined,
            title: 'Takvim',
            description: 'Duruşmaları telefon takviminize ekler',
            granted: state.calendarPermissionGranted,
            onGrant: () async {
              final ok = await effectiveAsker.requestCalendar();
              controller.markCalendarPermission(ok);
            },
          ),
          const SizedBox(height: 12),
          _PermissionCard(
            icon: Icons.notifications_outlined,
            title: 'Bildirim',
            description: 'Yaklaşan duruşmaları hatırlatır',
            granted: state.notificationPermissionGranted,
            onGrant: () async {
              final ok = await effectiveAsker.requestNotification();
              controller.markNotificationPermission(ok);
            },
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.onGrant,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final Future<void> Function() onGrant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (granted)
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        const Text('Verildi'),
                      ],
                    )
                  else
                    OutlinedButton(
                      onPressed: onGrant,
                      child: const Text('İzin Ver'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Platform izin diyaloglarını soyutlayan strategy nesnesi.
///
/// Üretimde `permission_handler` paketi üzerinden gerçek diyalog açılır;
/// testte fake (her zaman true/false dönen) bir alt sınıf kullanılır.
class PermissionAsker {
  const PermissionAsker();

  /// Takvim iznini ister; izin verildiyse true döner.
  Future<bool> requestCalendar() async {
    // Üretim implementasyonu permission_handler ile yapılacak.
    // Burada doğrudan o pakete bağlanmıyoruz çünkü ana ajan native setup'ı
    // ile birlikte yapacak; bu strategy'i feature başlangıcı için
    // pluggable bırakıyoruz.
    return false;
  }

  /// Bildirim iznini ister; izin verildiyse true döner.
  Future<bool> requestNotification() async {
    return false;
  }
}

/// Test ve mock için izin akışını override edebilen alt sınıf.
class FakePermissionAsker extends PermissionAsker {
  const FakePermissionAsker({this.calendar = true, this.notification = true});

  final bool calendar;
  final bool notification;

  @override
  Future<bool> requestCalendar() async => calendar;

  @override
  Future<bool> requestNotification() async => notification;
}

