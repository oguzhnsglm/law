import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/hearing_view_model.dart';
import '../state/hearings_today_provider.dart';
import '../widgets/hearing_card.dart';

/// "Bugün" ana ekranı — yaklaşan duruşmaları gruplanmış olarak gösterir.
class HearingsTodayScreen extends ConsumerWidget {
  const HearingsTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGrouped = ref.watch(upcomingHearingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bugün')),
      body: asyncGrouped.when(
        data: (grouped) {
          if (grouped.isEmpty) {
            return const _EmptyState();
          }
          return _GroupedHearingList(grouped: grouped);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorState(message: err.toString()),
      ),
    );
  }
}

class _GroupedHearingList extends StatelessWidget {
  const _GroupedHearingList({required this.grouped});

  final GroupedHearings grouped;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];
    void addSection(String title, List<HearingViewModel> items) {
      if (items.isEmpty) return;
      sections.add(_SectionHeader(title: title, count: items.length));
      sections.addAll(items.map((h) => HearingCard(viewModel: h)));
    }

    addSection('Bugün', grouped.today);
    addSection('Yarın', grouped.tomorrow);
    addSection('Bu hafta', grouped.thisWeek);
    addSection('Sonra', grouped.later);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: sections,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        '$title ($count)',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Yakında duruşmanız yok',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'UYAP\'tan senkron yaparak dosyalarınızı ve duruşmalarınızı '
              'çekebilirsiniz.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Duruşmalar yüklenemedi',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
