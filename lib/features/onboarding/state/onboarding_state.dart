import 'package:equatable/equatable.dart';

/// Onboarding akışının anlık durumu.
class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.kvkkAccepted = false,
    this.crashReportingOptIn = false,
    this.calendarPermissionGranted = false,
    this.notificationPermissionGranted = false,
    this.completing = false,
  });

  /// PageView'in göstermekte olduğu sayfa indeksi.
  final int currentPage;

  /// KVKK aydınlatma metnine açık rıza işaretlendi mi.
  final bool kvkkAccepted;

  /// Anonim çökme raporu opt-in (opsiyonel).
  final bool crashReportingOptIn;

  /// Takvim izni verildi mi.
  final bool calendarPermissionGranted;

  /// Bildirim izni verildi mi.
  final bool notificationPermissionGranted;

  /// "Bitir" akışı sürüyor mu (secure storage yazımı vb.).
  final bool completing;

  /// Toplam sayfa sayısı.
  static const int totalPages = 4;

  /// Mevcut sayfada "İleri" butonu aktif olmalı mı.
  bool get canAdvance {
    switch (currentPage) {
      case 1:
        return kvkkAccepted;
      default:
        return true;
    }
  }

  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    bool? kvkkAccepted,
    bool? crashReportingOptIn,
    bool? calendarPermissionGranted,
    bool? notificationPermissionGranted,
    bool? completing,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      kvkkAccepted: kvkkAccepted ?? this.kvkkAccepted,
      crashReportingOptIn: crashReportingOptIn ?? this.crashReportingOptIn,
      calendarPermissionGranted:
          calendarPermissionGranted ?? this.calendarPermissionGranted,
      notificationPermissionGranted:
          notificationPermissionGranted ?? this.notificationPermissionGranted,
      completing: completing ?? this.completing,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        kvkkAccepted,
        crashReportingOptIn,
        calendarPermissionGranted,
        notificationPermissionGranted,
        completing,
      ];
}
