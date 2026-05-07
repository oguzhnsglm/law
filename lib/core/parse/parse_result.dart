import '../db/database.dart';

/// UYAP parse işleminin çıktısı.
class ParseResult {
  ParseResult({
    required this.cases,
    required this.hearings,
    this.warnings = const [],
  });

  final List<CasesCompanion> cases;
  final List<HearingDraft> hearings;
  final List<String> warnings;

  Iterable<HearingDraft> hearingsByDosyaNo(String dosyaNo) =>
      hearings.where((h) => h.dosyaNo == dosyaNo);

  bool get isEmpty => cases.isEmpty && hearings.isEmpty;
  int get totalCount => cases.length + hearings.length;
}

/// Henüz `caseId`'ye bağlanmamış duruşma taslağı.
class HearingDraft {
  HearingDraft({
    required this.dosyaNo,
    required this.durusmaTarihi,
    this.salon,
    this.gundem,
  });

  final String dosyaNo;
  final DateTime durusmaTarihi;
  final String? salon;
  final String? gundem;
}
