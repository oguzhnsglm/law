import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/hearing_view_model.dart';

/// Tek bir duruşmayı listede temsil eden kart.
class HearingCard extends StatelessWidget {
  const HearingCard({
    required this.viewModel,
    this.onTap,
    this.now,
    super.key,
  });

  final HearingViewModel viewModel;
  final VoidCallback? onTap;

  /// Test'lerde "şimdi"yi sabitlemek için override edilebilir; null ise
  /// `DateTime.now()` kullanılır.
  final DateTime? now;

  String? _relativeBadge() {
    final reference = now ?? DateTime.now();
    final diff = viewModel.tarih.difference(reference);
    if (diff.isNegative) return null;
    if (diff.inHours < 1) {
      return '${diff.inMinutes} dk sonra';
    }
    if (diff.inHours < 6) {
      return '${diff.inHours} sa sonra';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 24-saat HH:mm — locale-agnostic, intl locale data init'e bağımlı değil.
    final timeFormat = DateFormat.Hm();
    final time = timeFormat.format(viewModel.tarih);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TimeBadge(time: time),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.mahkemeAdi.isEmpty
                          ? 'Mahkeme bilgisi yok'
                          : viewModel.mahkemeAdi,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (viewModel.dosyaNo != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Esas ${viewModel.dosyaNo}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (viewModel.salon != null &&
                        viewModel.salon!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        viewModel.salon!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_relativeBadge() != null) ...[
                const SizedBox(width: 8),
                _RelativeChip(label: _relativeBadge()!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RelativeChip extends StatelessWidget {
  const _RelativeChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        time,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
