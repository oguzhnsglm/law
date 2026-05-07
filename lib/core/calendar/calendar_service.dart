import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../db/database.dart';
import '../db/database_provider.dart';

/// Cihazın native takvimine duruşma yazma servisi.
///
/// iOS'ta EventKit, Android'de CalendarProvider. Idempotent: aynı `eventId`
/// varsa update, yoksa yeni event oluştur ve `Hearing.takvimEventId`
/// güncelle.
class CalendarService {
  CalendarService(this._plugin, this._db);

  final DeviceCalendarPlugin _plugin;
  final AppDatabase _db;

  /// Erişim izni iste; reddedilirse false döner.
  Future<bool> requestPermissions() async {
    final res = await _plugin.requestPermissions();
    return res.isSuccess && (res.data ?? false);
  }

  /// Yazılabilir takvim listesi.
  Future<List<Calendar>> listWritableCalendars() async {
    final res = await _plugin.retrieveCalendars();
    if (!res.isSuccess || res.data == null) return const [];
    return res.data!.where((c) => c.isReadOnly == false).toList();
  }

  /// Hearing'i takvime yazar veya günceller.
  /// Başarılıysa eventId döner ve DB'de günceller; başarısızsa null.
  Future<String?> writeOrUpdate({
    required Hearing h,
    required String calendarId,
    required String mahkemeAdi,
    required String dosyaNo,
  }) async {
    final start = tz.TZDateTime.from(h.durusmaTarihi.toLocal(), tz.local);
    final end = start.add(const Duration(hours: 1));

    final event = Event(
      calendarId,
      eventId: h.takvimEventId,
      title: 'Duruşma — $mahkemeAdi',
      description: 'Esas $dosyaNo${h.gundem != null ? '\n${h.gundem!}' : ''}',
      location: h.salon,
      start: start,
      end: end,
      reminders: [
        Reminder(minutes: 24 * 60),
        Reminder(minutes: 120),
      ],
    );
    final res = await _plugin.createOrUpdateEvent(event);
    if (res?.isSuccess != true || res?.data == null) return null;
    final eventId = res!.data!;
    if (h.takvimEventId != eventId) {
      await _db.hearingsDao.setEventId(h.id, eventId);
    }
    return eventId;
  }

  /// Hearing'in cihaz takvimindeki kaydını siler ve DB'de UID'yi temizler.
  Future<bool> remove({
    required Hearing h,
    required String calendarId,
  }) async {
    if (h.takvimEventId == null) return true;
    final res = await _plugin.deleteEvent(calendarId, h.takvimEventId!);
    if (res.isSuccess) {
      await _db.hearingsDao.setEventId(h.id, null);
      return true;
    }
    return false;
  }
}

final calendarServiceProvider = Provider<CalendarService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CalendarService(DeviceCalendarPlugin(), db);
});
