import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/db/database.dart';
import 'package:law/features/hearings/data/hearing_view_model.dart';
import 'package:law/features/hearings/presentation/hearings_today_screen.dart';
import 'package:law/features/hearings/state/hearings_today_provider.dart';

HearingViewModel _vm(DateTime t, String esas, String mahkeme) {
  final h = Hearing(
    id: t.millisecondsSinceEpoch,
    caseId: 1,
    durusmaTarihi: t,
    salon: 'Salon 1',
    gundem: null,
    bildirimTetiklendi: false,
    takvimEventId: null,
    sonSenkronTarihi: t,
  );
  return HearingViewModel(
    hearing: h,
    dosyaNo: esas,
    mahkemeAdi: mahkeme,
  );
}

Widget _wrap(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: HearingsTodayScreen()),
  );
}

void main() {
  group('HearingsTodayScreen', () {
    testWidgets('boş veri için empty state gösterir', (tester) async {
      await tester.pumpWidget(
        _wrap([
          upcomingHearingsProvider.overrideWith(
            (ref) => Stream.value(
              const GroupedHearings(
                today: [],
                tomorrow: [],
                thisWeek: [],
                later: [],
              ),
            ),
          ),
        ]),
      );

      await tester.pump(); // stream emission
      expect(find.text('Yakında duruşmanız yok'), findsOneWidget);
    });

    testWidgets(
      'gruplanmış veri için bölüm başlıkları ve kart sayıları görünür',
      (tester) async {
        final today = DateTime(2026, 5, 6, 10, 0);
        final tomorrow = DateTime(2026, 5, 7, 14, 0);

        await tester.pumpWidget(
          _wrap([
            upcomingHearingsProvider.overrideWith(
              (ref) => Stream.value(
                GroupedHearings(
                  today: [_vm(today, '2025/1234', 'İstanbul 1. Asliye Hukuk')],
                  tomorrow: [_vm(tomorrow, '2025/5678', 'Ankara 3. İş')],
                  thisWeek: const [],
                  later: const [],
                ),
              ),
            ),
          ]),
        );

        await tester.pump();
        expect(find.text('Bugün (1)'), findsOneWidget);
        expect(find.text('Yarın (1)'), findsOneWidget);
        expect(find.text('İstanbul 1. Asliye Hukuk'), findsOneWidget);
        expect(find.text('Ankara 3. İş'), findsOneWidget);
        expect(find.text('Esas 2025/1234'), findsOneWidget);
        expect(find.text('Esas 2025/5678'), findsOneWidget);
      },
    );

    testWidgets('loading durumunda CircularProgressIndicator gösterir',
        (tester) async {
      await tester.pumpWidget(
        _wrap([
          upcomingHearingsProvider.overrideWith(
            (ref) => const Stream<GroupedHearings>.empty(),
          ),
        ]),
      );

      // İlk frame loading state'i göstermeli (henüz emit yok).
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('boş bölümler render edilmez', (tester) async {
      final later = DateTime(2026, 5, 25, 10, 0);

      await tester.pumpWidget(
        _wrap([
          upcomingHearingsProvider.overrideWith(
            (ref) => Stream.value(
              GroupedHearings(
                today: const [],
                tomorrow: const [],
                thisWeek: const [],
                later: [_vm(later, '2025/9999', 'Bursa 5. Aile')],
              ),
            ),
          ),
        ]),
      );

      await tester.pump();
      expect(find.textContaining('Bugün'), findsNothing);
      expect(find.textContaining('Yarın'), findsNothing);
      expect(find.text('Sonra (1)'), findsOneWidget);
    });
  });
}
