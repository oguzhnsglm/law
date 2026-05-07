import 'package:equatable/equatable.dart';

/// Dosya listesi için filtre seçenekleri.
enum CasesFilter {
  all('Tümü'),
  open('Açık'),
  closed('Kapalı'),
  decided('Karar');

  const CasesFilter(this.label);

  final String label;

  /// Bir [durum] alanının bu filtreye uyup uymadığını döner.
  ///
  /// `all` her zaman true; diğerleri durumun küçük harfli karşılaştırmasına
  /// göre eşleşir. UYAP durum metinleri varyantları (ör. "Açık", "AÇIK",
  /// "açık", "Açık Dosya") için ön-ek match'i kullanılır.
  bool matches(String? durum) {
    if (this == CasesFilter.all) return true;
    if (durum == null) return false;
    final lower = durum.toLowerCase();
    switch (this) {
      case CasesFilter.open:
        return lower.contains('açık');
      case CasesFilter.closed:
        return lower.contains('kapalı');
      case CasesFilter.decided:
        return lower.contains('karar');
      case CasesFilter.all:
        return true;
    }
  }
}

/// Filtre + arama sorgusu durumu.
class CasesQuery extends Equatable {
  const CasesQuery({
    this.searchText = '',
    this.filter = CasesFilter.all,
  });

  final String searchText;
  final CasesFilter filter;

  CasesQuery copyWith({String? searchText, CasesFilter? filter}) {
    return CasesQuery(
      searchText: searchText ?? this.searchText,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [searchText, filter];
}
