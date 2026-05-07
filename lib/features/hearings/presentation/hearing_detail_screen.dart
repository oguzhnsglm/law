import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';

/// Bir duruşmanın tam detayı + manuel notlar + dosya kısa özeti.
class HearingDetailScreen extends ConsumerWidget {
  const HearingDetailScreen({required this.hearingId, super.key});

  final int hearingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(_hearingDetailProvider(hearingId));
    return Scaffold(
      appBar: AppBar(title: const Text('Duruşma')),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Duruşma bulunamadı'));
          }
          return _Body(data: data);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.data});
  final _HearingWithCase data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final h = data.hearing;
    final dateFmt = DateFormat('dd MMMM yyyy, HH:mm');
    final localDate = h.durusmaTarihi.toLocal();
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
        // Notlar alt-listesi (kullanıcı manuel ekler)
        const _NotesPlaceholder(),
      ],
    );
  }
}

class _NotesPlaceholder extends StatelessWidget {
  const _NotesPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'Bu duruşmaya not eklenmemiş.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
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
