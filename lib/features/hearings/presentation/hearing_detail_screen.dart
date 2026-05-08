import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/calendar/calendar_service.dart';
import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/notifications/notification_service.dart';
import '../widgets/notes_section.dart';

/// Bir duruşmanın tam detayı + manuel notlar + dosya kısa özeti.
class HearingDetailScreen extends ConsumerStatefulWidget {
  const HearingDetailScreen({required this.hearingId, super.key});

  final int hearingId;

  @override
  ConsumerState<HearingDetailScreen> createState() =>
      _HearingDetailScreenState();
}

class _HearingDetailScreenState extends ConsumerState<HearingDetailScreen> {
  bool _notifEnabled = true;
  bool _busy = false;

  Future<String?> _selectedCalendarId() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: 'selected_calendar_id_v1');
  }

  Future<void> _toggleCalendar(Hearing h, Case? c) async {
    if (c == null) return;
    setState(() => _busy = true);
    final calendarId = await _selectedCalendarId();
    if (calendarId == null) {
      _showSnack(
          'Önce Ayarlar > Takvim Seçimi\'nden bir takvim seçin.');
      setState(() => _busy = false);
      return;
    }
    final svc = ref.read(calendarServiceProvider);
    if (h.takvimEventId == null) {
      await svc.writeOrUpdate(
        h: h,
        calendarId: calendarId,
        mahkemeAdi: c.mahkemeAdi,
        dosyaNo: c.dosyaNo,
      );
      _showSnack('Takvime eklendi.');
    } else {
      await svc.remove(h: h, calendarId: calendarId);
      _showSnack('Takvimden kaldırıldı.');
    }
    ref.invalidate(_hearingDetailProvider(widget.hearingId));
    setState(() => _busy = false);
  }

  Future<void> _toggleNotification(Hearing h) async {
    setState(() {
      _notifEnabled = !_notifEnabled;
      _busy = true;
    });
    final svc = ref.read(notificationServiceProvider);
    if (_notifEnabled) {
      await svc.scheduleForHearing(h);
      _showSnack('Hatırlatma planlandı.');
    } else {
      await svc.cancelForHearing(h.id);
      _showSnack('Hatırlatma iptal edildi.');
    }
    if (mounted) setState(() => _busy = false);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(_hearingDetailProvider(widget.hearingId));
    return Scaffold(
      appBar: AppBar(title: const Text('Duruşma')),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Duruşma bulunamadı'));
          }
          return _buildBody(data);
        },
      ),
    );
  }

  Widget _buildBody(_HearingWithCase data) {
    final theme = Theme.of(context);
    final h = data.hearing;
    final dateFmt = DateFormat('dd MMMM yyyy, HH:mm');
    final localDate = h.durusmaTarihi.toLocal();
    final inCalendar = h.takvimEventId != null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFmt.format(localDate),
                  style: theme.textTheme.headlineSmall,
                ),
                if (h.salon != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.meeting_room_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(h.salon!),
                    ],
                  ),
                ],
                if (h.gundem != null) ...[
                  const SizedBox(height: 12),
                  Text('Gündem', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(h.gundem!),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.event_outlined),
                title: const Text('Cihaz takvimine ekle'),
                subtitle: Text(
                    inCalendar ? 'Takvimde kayıtlı' : 'Henüz eklenmemiş'),
                value: inCalendar,
                onChanged: _busy
                    ? null
                    : (_) => _toggleCalendar(h, data.caseModel),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Bildirim hatırlatması'),
                subtitle: const Text('1 gün ve 2 saat önce'),
                value: _notifEnabled,
                onChanged: _busy ? null : (_) => _toggleNotification(h),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (data.caseModel != null)
          Card(
            child: ListTile(
              title: Text('Esas ${data.caseModel!.dosyaNo}'),
              subtitle: Text(data.caseModel!.mahkemeAdi),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/case/${data.caseModel!.id}'),
            ),
          ),
        const SizedBox(height: 24),
        Text('Notlar', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        NotesSection(hearingId: h.id),
      ],
    );
  }
}

class _HearingWithCase {
  _HearingWithCase({required this.hearing, required this.caseModel});
  final Hearing hearing;
  final Case? caseModel;
}

final _hearingDetailProvider =
    FutureProvider.family<_HearingWithCase?, int>((ref, id) async {
  final db = ref.watch(appDatabaseProvider);
  final h = await (db.select(db.hearings)..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  if (h == null) return null;
  final c = await (db.select(db.cases)..where((t) => t.id.equals(h.caseId)))
      .getSingleOrNull();
  return _HearingWithCase(hearing: h, caseModel: c);
});
