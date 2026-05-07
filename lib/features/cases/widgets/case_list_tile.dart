import 'package:flutter/material.dart';
import 'package:law/core/db/database.dart';

/// Tek bir dava kaydını listede temsil eden ListTile.
class CaseListTile extends StatelessWidget {
  const CaseListTile({
    required this.caseModel,
    this.onTap,
    super.key,
  });

  final Case caseModel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partiesShort = _partiesShort();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.folder_open,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        'Esas ${caseModel.dosyaNo}',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caseModel.mahkemeAdi,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (partiesShort.isNotEmpty)
            Text(
              partiesShort,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      trailing: caseModel.durum == null
          ? null
          : _StatusChip(label: caseModel.durum!),
      onTap: onTap,
    );
  }

  String _partiesShort() {
    final parties = caseModel.taraflarJson;
    if (parties.isEmpty) return '';
    if (parties.length == 1) return parties.first.ad;
    return '${parties.first.ad} — ${parties.last.ad}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lower = label.toLowerCase();
    final fg = lower.contains('açık')
        ? colorScheme.primary
        : lower.contains('kapalı')
            ? colorScheme.onSurfaceVariant
            : colorScheme.tertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
