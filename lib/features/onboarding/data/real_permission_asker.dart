import 'package:permission_handler/permission_handler.dart';

import '../presentation/pages/permissions_page.dart';

/// `permission_handler` paketi üzerinden gerçek native izin diyaloglarını
/// gösteren `PermissionAsker` implementasyonu.
class RealPermissionAsker extends PermissionAsker {
  const RealPermissionAsker();

  @override
  Future<bool> requestCalendar() async {
    // iOS 17+ full access; Android'de READ/WRITE_CALENDAR.
    final status = await Permission.calendarFullAccess.request();
    if (status.isGranted) return true;
    // Eski cihazlarda fallback (write-only access)
    final fallback = await Permission.calendarWriteOnly.request();
    return fallback.isGranted;
  }

  @override
  Future<bool> requestNotification() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
