import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/calendar/calendar_service.dart';
import '../data/data_export_service.dart';
import '../data/data_purge_service.dart';
import '../data/user_profile.dart';
import '../state/settings_controller.dart';

/// Ayarlar ana ekranı.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({this.onExportReady, super.key});

  /// Dışa aktarım üretildiğinde JSON string ile çağrılan callback.
  /// UI'nın paylaşma akışına (share_plus vs.) bağlanması burada yapılır.
  /// Null ise dialog'da gösterilir.
  final ValueChanged<String>? onExportReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: asyncSettings.when(
        data: (s) => _SettingsBody(
          state: s,
          onExportReady: onExportReady,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.state, required this.onExportReady});

  final SettingsState state;
  final ValueChanged<String>? onExportReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const _SectionHeader('HESAP'),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Profil bilgilerim'),
          subtitle: state.profile.isEmpty
              ? const Text('Henüz girilmedi')
              : Text(
                  '${state.profile.displayName} '
                  '${state.profile.baroSicil.isEmpty ? '' : '· ${state.profile.baroSicil}'}',
                ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _editProfile(context, ref, state.profile),
        ),
        const Divider(),
        const _SectionHeader('BİLDİRİM'),
        SwitchListTile(
          title: const Text('Bildirim göster'),
          value: state.notifications.notificationsEnabled,
          onChanged: (v) => ref
              .read(settingsControllerProvider.notifier)
              .updateNotifications(
                state.notifications.copyWith(notificationsEnabled: v),
              ),
        ),
        SwitchListTile(
          title: const Text('1 gün önce'),
          subtitle: Text(
            '${state.notifications.oneDayBeforeHour.toString().padLeft(2, '0')}:00',
          ),
          value: state.notifications.oneDayBefore,
          onChanged: state.notifications.notificationsEnabled
              ? (v) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateNotifications(
                    state.notifications.copyWith(oneDayBefore: v),
                  )
              : null,
        ),
        SwitchListTile(
          title: const Text('2 saat önce'),
          value: state.notifications.twoHoursBefore,
          onChanged: state.notifications.notificationsEnabled
              ? (v) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateNotifications(
                    state.notifications.copyWith(twoHoursBefore: v),
                  )
              : null,
        ),
        const Divider(),
        const _SectionHeader('TAKVİM'),
        ListTile(
          leading: const Icon(Icons.event_outlined),
          title: const Text('Yazılacak takvim'),
          subtitle: const _SelectedCalendarSubtitle(),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _selectCalendar(context, ref),
        ),
        const Divider(),
        const _SectionHeader('VERİLERİM'),
        ListTile(
          leading: const Icon(Icons.share_outlined),
          title: const Text('Verilerimi paylaş'),
          subtitle: const Text('JSON dosyası olarak'),
          onTap: () => _shareData(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: const Text('Verilerimi göster'),
          subtitle: const Text('Ekranda inceleme'),
          onTap: () => _exportData(context, ref),
        ),
        ListTile(
          leading: Icon(
            Icons.delete_forever_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Tüm verilerimi sil',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onTap: () => _confirmPurge(context, ref),
        ),
      ],
    );
  }

  Future<void> _editProfile(
    BuildContext context,
    WidgetRef ref,
    UserProfile current,
  ) async {
    final updated = await showDialog<UserProfile>(
      context: context,
      builder: (ctx) => _ProfileEditDialog(initial: current),
    );
    if (updated != null) {
      await ref
          .read(settingsControllerProvider.notifier)
          .updateProfile(updated);
    }
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final json = await ref
        .read(dataExportServiceProvider)
        .exportAsJsonString();
    if (!context.mounted) return;
    if (onExportReady != null) {
      onExportReady!(json);
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Veri dışa aktarımı hazır'),
        content: SingleChildScrollView(
          child: SelectableText(
            json,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareData(BuildContext context, WidgetRef ref) async {
    final path = await ref.read(dataExportServiceProvider).exportToTempFile();
    if (!context.mounted) return;
    await Share.shareXFiles(
      [XFile(path, mimeType: 'application/json')],
      subject: 'Law verilerim',
    );
  }

  Future<void> _selectCalendar(BuildContext context, WidgetRef ref) async {
    final svc = ref.read(calendarServiceProvider);
    final granted = await svc.requestPermissions();
    if (!context.mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Takvim izni reddedildi.')),
      );
      return;
    }
    final calendars = await svc.listWritableCalendars();
    if (!context.mounted) return;
    if (calendars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yazılabilir takvim bulunamadı.')),
      );
      return;
    }
    const storage = FlutterSecureStorage();
    final current = await storage.read(key: 'selected_calendar_id_v1');
    if (!context.mounted) return;
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Takvim seç'),
        children: [
          for (final c in calendars)
            ListTile(
              leading: Icon(
                c.id == current
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: Text(c.name ?? 'İsimsiz takvim'),
              subtitle: Text(c.accountName ?? ''),
              onTap: () => Navigator.of(ctx).pop(c.id ?? ''),
            ),
        ],
      ),
    );
    if (selected != null && selected.isNotEmpty) {
      await storage.write(key: 'selected_calendar_id_v1', value: selected);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Takvim kaydedildi.')),
        );
      }
    }
  }

  Future<void> _confirmPurge(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tüm verileri sil'),
        content: const Text(
          'Tüm yerel verilerin silinecek. Bu işlem geri alınamaz. '
          'Devam edilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(dataPurgeServiceProvider).purgeAll();
      ref.invalidate(settingsControllerProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tüm verileriniz silindi')),
      );
    }
  }
}

class _SelectedCalendarSubtitle extends StatefulWidget {
  const _SelectedCalendarSubtitle();

  @override
  State<_SelectedCalendarSubtitle> createState() =>
      _SelectedCalendarSubtitleState();
}

class _SelectedCalendarSubtitleState
    extends State<_SelectedCalendarSubtitle> {
  String? _id;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    const storage = FlutterSecureStorage();
    final id = await storage.read(key: 'selected_calendar_id_v1');
    if (mounted) setState(() => _id = id);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _id == null || _id!.isEmpty ? 'Henüz seçilmedi' : 'Takvim seçili',
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ProfileEditDialog extends StatefulWidget {
  const _ProfileEditDialog({required this.initial});

  final UserProfile initial;

  @override
  State<_ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<_ProfileEditDialog> {
  late final TextEditingController _ad;
  late final TextEditingController _soyad;
  late final TextEditingController _sicil;
  late final TextEditingController _baro;

  @override
  void initState() {
    super.initState();
    _ad = TextEditingController(text: widget.initial.ad);
    _soyad = TextEditingController(text: widget.initial.soyad);
    _sicil = TextEditingController(text: widget.initial.baroSicil);
    _baro = TextEditingController(text: widget.initial.baroAdi);
  }

  @override
  void dispose() {
    _ad.dispose();
    _soyad.dispose();
    _sicil.dispose();
    _baro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Profil Bilgileri'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _ad,
              decoration: const InputDecoration(labelText: 'Ad'),
            ),
            TextField(
              controller: _soyad,
              decoration: const InputDecoration(labelText: 'Soyad'),
            ),
            TextField(
              controller: _sicil,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Baro Sicil No'),
            ),
            TextField(
              controller: _baro,
              decoration: const InputDecoration(labelText: 'Baro Adı'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              UserProfile(
                ad: _ad.text.trim(),
                soyad: _soyad.text.trim(),
                baroSicil: _sicil.text.trim(),
                baroAdi: _baro.text.trim(),
              ),
            );
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
