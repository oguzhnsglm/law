import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../db/database.dart';

/// Duruşma hatırlatma bildirimleri için servis.
///
/// Bildirimler **lokal schedule** edilir; sunucu push gerekmez. Her duruşma
/// için iki bildirim hedeflenir:
///   - 1 gün önce 20:00
///   - 2 saat önce
///
/// Notification ID düzeni: `hearingId * 10 + slot` (slot 1=günü, 2=saati).
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const _channelId = 'hearings';
  static const _channelName = 'Duruşma Hatırlatmaları';
  static const _channelDesc = 'Yaklaşan duruşmalar için bildirim';

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _plugin.initialize(initSettings);

    // Android kanalı (idempotent: createNotificationChannel zaten varsa OK)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  /// Verilen duruşma için 1 gün ve 2 saat öncesine bildirim schedule eder.
  /// Geçmiş zamanlar atlanır.
  Future<int> scheduleForHearing(Hearing h) async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    final localTarih = tz.TZDateTime.from(h.durusmaTarihi.toLocal(), tz.local);

    // Slot 1: 1 gün önce 20:00 — yaklaşan akşam hatırlatması
    final oneDayBefore = tz.TZDateTime(
      tz.local,
      localTarih.year,
      localTarih.month,
      localTarih.day,
      20,
    ).subtract(const Duration(days: 1));

    // Slot 2: 2 saat önce
    final twoHoursBefore = localTarih.subtract(const Duration(hours: 2));

    var scheduled = 0;
    if (oneDayBefore.isAfter(now)) {
      await _schedule(
        id: h.id * 10 + 1,
        title: 'Yarın duruşmanız var',
        body: _bodyFor(h, prefix: 'Yarın'),
        when: oneDayBefore,
      );
      scheduled++;
    }
    if (twoHoursBefore.isAfter(now)) {
      await _schedule(
        id: h.id * 10 + 2,
        title: 'Duruşmanıza 2 saat kaldı',
        body: _bodyFor(h, prefix: 'Bugün'),
        when: twoHoursBefore,
      );
      scheduled++;
    }
    return scheduled;
  }

  /// Bir hearing'e ait tüm planlanmış bildirimleri iptal eder.
  Future<void> cancelForHearing(int hearingId) async {
    await _plugin.cancel(hearingId * 10 + 1);
    await _plugin.cancel(hearingId * 10 + 2);
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  String _bodyFor(Hearing h, {required String prefix}) {
    final parts = <String>[prefix];
    if (h.salon != null) parts.add(h.salon!);
    if (h.gundem != null) parts.add(h.gundem!);
    return parts.join(' · ');
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(FlutterLocalNotificationsPlugin());
});
