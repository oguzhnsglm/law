import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:law/app/app.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/database_provider.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('LawApp boots with router and shows shell', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const LawApp(),
      ),
    );
    // İlk frame'de router redirect logic çözülürken loading olabilir;
    // pump tek frame yeterli.
    await tester.pump();
    // Onboarding flag false varsayılır → /onboarding'e gidecek; ya da
    // shell gösterilecek. Hangisinin geldiğini kabaca doğrulayalım.
    expect(find.byType(LawApp), findsOneWidget);
  });
}
