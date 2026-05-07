import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/db/database.dart';
import 'package:law/features/cases/presentation/cases_list_screen.dart';
import 'package:law/features/cases/state/cases_filter.dart';
import 'package:law/features/cases/state/cases_list_provider.dart';

Case _case(int id, String dosyaNo, String mahkeme, {String? durum}) {
  return Case(
    id: id,
    dosyaNo: dosyaNo,
    mahkemeAdi: mahkeme,
    mahkemeTuru: null,
    dosyaTuru: null,
    taraflarJson: const [],
    durum: durum,
    sonIslemTarihi: null,
    sonSenkronTarihi: DateTime(2026, 5, 6),
  );
}

Widget _wrap(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: CasesListScreen()),
  );
}

void main() {
  group('CasesListScreen', () {
    testWidgets('boş veri için empty state gösterir', (tester) async {
      await tester.pumpWidget(
        _wrap([
          allCasesStreamProvider.overrideWith((ref) => Stream.value(const [])),
        ]),
      );
      await tester.pump();
      expect(find.text('Henüz dosya yok, senkronize et'), findsOneWidget);
    });

    testWidgets('liste verisi tile\'lara render edilir', (tester) async {
      final cases = [
        _case(1, '2025/1234', 'İstanbul 1. Asliye Hukuk', durum: 'Açık'),
        _case(2, '2024/5678', 'Ankara 3. İş', durum: 'Kapalı'),
      ];
      await tester.pumpWidget(
        _wrap([
          allCasesStreamProvider.overrideWith((ref) => Stream.value(cases)),
        ]),
      );
      await tester.pump();

      expect(find.text('Esas 2025/1234'), findsOneWidget);
      expect(find.text('Esas 2024/5678'), findsOneWidget);
      expect(find.text('İstanbul 1. Asliye Hukuk'), findsOneWidget);
      expect(find.text('Ankara 3. İş'), findsOneWidget);
    });

    testWidgets(
      'arama metni listeyi anlık filtreler',
      (tester) async {
        final cases = [
          _case(1, '2025/1234', 'İstanbul 1. Asliye Hukuk'),
          _case(2, '2024/5678', 'Ankara 3. İş'),
        ];
        await tester.pumpWidget(
          _wrap([
            allCasesStreamProvider.overrideWith((ref) => Stream.value(cases)),
          ]),
        );
        await tester.pump();

        await tester.enterText(find.byType(TextField), 'Ankara');
        await tester.pump();

        expect(find.text('Esas 2024/5678'), findsOneWidget);
        expect(find.text('Esas 2025/1234'), findsNothing);
      },
    );

    testWidgets(
      'filtre chip seçince yalnızca eşleşen kayıtlar görünür',
      (tester) async {
        final cases = [
          _case(1, '2025/1234', 'M1', durum: 'Açık'),
          _case(2, '2024/5678', 'M2', durum: 'Kapalı'),
        ];
        await tester.pumpWidget(
          _wrap([
            allCasesStreamProvider.overrideWith((ref) => Stream.value(cases)),
          ]),
        );
        await tester.pump();

        // "Kapalı" chip'ine tıkla
        await tester.tap(find.widgetWithText(FilterChip, 'Kapalı'));
        await tester.pump();

        expect(find.text('Esas 2024/5678'), findsOneWidget);
        expect(find.text('Esas 2025/1234'), findsNothing);
      },
    );

    testWidgets(
      'filtreli boş sonuç için "Sonuç bulunamadı" gösterir',
      (tester) async {
        final cases = [_case(1, '2025/1234', 'M', durum: 'Açık')];
        await tester.pumpWidget(
          _wrap([
            allCasesStreamProvider.overrideWith((ref) => Stream.value(cases)),
            casesQueryControllerProvider.overrideWith(() {
              final c = CasesQueryController();
              return c;
            }),
          ]),
        );
        await tester.pump();

        // Eşleşmeyen aramayı yaz
        await tester.enterText(find.byType(TextField), 'xxxxxxxxx');
        await tester.pump();

        expect(find.text('Sonuç bulunamadı'), findsOneWidget);
      },
    );
  });
}
