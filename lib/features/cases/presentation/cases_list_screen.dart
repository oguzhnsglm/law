import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/cases_filter.dart';
import '../state/cases_list_provider.dart';
import '../widgets/case_list_tile.dart';

/// Dosya listesi ana ekranı — arama + filtre + sonsuz scroll.
class CasesListScreen extends ConsumerStatefulWidget {
  const CasesListScreen({super.key});

  @override
  ConsumerState<CasesListScreen> createState() => _CasesListScreenState();
}

class _CasesListScreenState extends ConsumerState<CasesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(casesQueryControllerProvider);
    final controller = ref.read(casesQueryControllerProvider.notifier);
    final asyncCases = ref.watch(filteredCasesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dosyalar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Esas no, mahkeme veya taraf ara',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.searchText.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          controller.setSearchText('');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onChanged: controller.setSearchText,
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final f in CasesFilter.values) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f.label),
                      selected: query.filter == f,
                      onSelected: (_) => controller.setFilter(f),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: asyncCases.when(
              data: (cases) {
                if (cases.isEmpty) {
                  return _EmptyState(query: query);
                }
                return ListView.separated(
                  itemCount: cases.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) =>
                      CaseListTile(caseModel: cases[i]),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text(err.toString())),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final CasesQuery query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFiltered =
        query.searchText.isNotEmpty || query.filter != CasesFilter.all;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered
                  ? 'Sonuç bulunamadı'
                  : 'Henüz dosya yok, senkronize et',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (!isFiltered) ...[
              const SizedBox(height: 8),
              Text(
                'UYAP\'tan ilk senkronu çalıştırarak dosyalarınızı çekebilirsiniz.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
