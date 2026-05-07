import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/models/party.dart';
import '../../hearings/data/hearing_view_model.dart';
import '../../hearings/widgets/hearing_card.dart';

/// Tek bir dosyanın detayını ve ilişkili duruşmaları gösteren ekran.
class CaseDetailScreen extends ConsumerWidget {
  const CaseDetailScreen({required this.caseId, super.key});

  final int caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCase = ref.watch(_caseByIdProvider(caseId));
    return Scaffold(
      appBar: AppBar(title: const Text('Dosya')),
      body: asyncCase.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Error(message: e.toString()),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Dosya bulunamadı'));
          }
          return _CaseDetailBody(data: data);
        },
      ),
    );
  }
}

class _CaseDetailBody extends StatelessWidget {
  const _CaseDetailBody({required this.data});
  final _CaseWithHearings data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = data.caseModel;
    final dateFmt = DateFormat('dd.MM.yyyy HH:mm');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Esas ${c.dosyaNo}', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(c.mahkemeAdi, style: theme.textTheme.titleMedium),
        if (c.durum != null) ...[
          const SizedBox(height: 8),
          Chip(label: Text(c.durum!)),
        ],
        const Divider(height: 32),
        if (c.taraflarJson.isNotEmpty) ...[
          Text('Taraflar', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          ..._partyTiles(c.taraflarJson),
          const Divider(height: 32),
        ],
        Text(
          'Son senkron: ${dateFmt.format(c.sonSenkronTarihi.toLocal())}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        Text('Duruşmalar', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        if (data.hearings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Bu dosyada duruşma kaydı yok')),
          ),
        for (final h in data.hearings)
          HearingCard(
            viewModel: HearingViewModel(
              hearing: h,
              dosyaNo: c.dosyaNo,
              mahkemeAdi: c.mahkemeAdi,
            ),
          ),
      ],
    );
  }

  Iterable<Widget> _partyTiles(List<Party> parties) sync* {
    for (final p in parties) {
      yield ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.person_outline),
        title: Text(p.ad),
        subtitle: Text(p.tip),
        trailing: p.vekil != null ? Text('Vekil: ${p.vekil}') : null,
      );
    }
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text('Hata: $message', textAlign: TextAlign.center),
      ),
    );
  }
}

class _CaseWithHearings {
  _CaseWithHearings({required this.caseModel, required this.hearings});
  final Case caseModel;
  final List<Hearing> hearings;
}

final _caseByIdProvider =
    FutureProvider.family<_CaseWithHearings?, int>((ref, id) async {
  final db = ref.watch(appDatabaseProvider);
  final caseRow = await (db.select(db.cases)..where((c) => c.id.equals(id)))
      .getSingleOrNull();
  if (caseRow == null) return null;
  final hearings = await db.hearingsDao.byCaseId(id);
  return _CaseWithHearings(caseModel: caseRow, hearings: hearings);
});
