import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/hearing_view_model.dart';
import '../data/hearings_repository.dart';

/// Yaklaşan duruşmaları zaman dilimine göre kategorize eden grup.
enum HearingBucket { today, tomorrow, thisWeek, later }

/// UI'da göstermek üzere gruplanmış duruşma listesi.
class GroupedHearings {
  const GroupedHearings({
    required this.today,
    required this.tomorrow,
    required this.thisWeek,
    required this.later,
  });

  final List<HearingViewModel> today;
  final List<HearingViewModel> tomorrow;
  final List<HearingViewModel> thisWeek;
  final List<HearingViewModel> later;

  bool get isEmpty =>
      today.isEmpty && tomorrow.isEmpty && thisWeek.isEmpty && later.isEmpty;

  int get totalCount =>
      today.length + tomorrow.length + thisWeek.length + later.length;
}

/// Verilen [items]'i [now]'a göre kategoriye yerleştirir.
///
/// Saat dilimi varsayılan cihaz local'idir; UYAP duruşmaları Europe/Istanbul
/// (DST yok, sabit +03:00).
GroupedHearings groupHearings(
  List<HearingViewModel> items,
  DateTime now,
) {
  final today = <HearingViewModel>[];
  final tomorrow = <HearingViewModel>[];
  final thisWeek = <HearingViewModel>[];
  final later = <HearingViewModel>[];

  final startOfToday = DateTime(now.year, now.month, now.day);
  final startOfTomorrow = startOfToday.add(const Duration(days: 1));
  final startOfDayAfter = startOfToday.add(const Duration(days: 2));
  final startOfNextWeek = startOfToday.add(const Duration(days: 7));

  for (final item in items) {
    final t = item.tarih;
    if (t.isBefore(startOfToday)) {
      // Geçmiş — yaklaşanlar listesinde olmamalı; defansif olarak today'e koy.
      today.add(item);
    } else if (t.isBefore(startOfTomorrow)) {
      today.add(item);
    } else if (t.isBefore(startOfDayAfter)) {
      tomorrow.add(item);
    } else if (t.isBefore(startOfNextWeek)) {
      thisWeek.add(item);
    } else {
      later.add(item);
    }
  }

  return GroupedHearings(
    today: today,
    tomorrow: tomorrow,
    thisWeek: thisWeek,
    later: later,
  );
}

/// Şu anki an için "şimdi"yi sağlayan provider; testlerde override edilebilir.
final nowProvider = Provider<DateTime>((ref) => DateTime.now());

/// Yaklaşan duruşmaların gruplanmış stream'i.
final upcomingHearingsProvider = StreamProvider<GroupedHearings>((ref) {
  final repo = ref.watch(hearingsRepositoryProvider);
  final now = ref.watch(nowProvider);
  return repo.watchUpcoming(now).map((items) => groupHearings(items, now));
});
