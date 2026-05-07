import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/database_provider.dart';

import 'cases_filter.dart';

/// Kullanıcının arama metni + filtre seçimini tutan controller.
class CasesQueryController extends Notifier<CasesQuery> {
  @override
  CasesQuery build() => const CasesQuery();

  void setSearchText(String text) {
    state = state.copyWith(searchText: text);
  }

  void setFilter(CasesFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void clear() {
    state = const CasesQuery();
  }
}

final casesQueryControllerProvider =
    NotifierProvider<CasesQueryController, CasesQuery>(
  CasesQueryController.new,
);

/// Tüm dava kayıtlarının canlı stream'i (filtresiz).
final allCasesStreamProvider = StreamProvider<List<Case>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.casesDao.watchAll();
});

/// Sorgu + filtreyle filtrelenmiş dava listesi.
final filteredCasesProvider = Provider<AsyncValue<List<Case>>>((ref) {
  final query = ref.watch(casesQueryControllerProvider);
  final asyncCases = ref.watch(allCasesStreamProvider);
  return asyncCases.whenData((cases) => applyQuery(cases, query));
});

/// [cases]'i [query]'e göre filtreler. Test edilebilirlik için saf fonksiyon.
List<Case> applyQuery(List<Case> cases, CasesQuery query) {
  final lowerSearch = query.searchText.trim().toLowerCase();
  return cases.where((c) {
    if (!query.filter.matches(c.durum)) return false;
    if (lowerSearch.isEmpty) return true;
    return c.dosyaNo.toLowerCase().contains(lowerSearch) ||
        c.mahkemeAdi.toLowerCase().contains(lowerSearch);
  }).toList();
}
