import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:law/app/app.dart';

void main() {
  testWidgets('LawApp boots and shows placeholder home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LawApp()));
    expect(find.text('Law — geliştirme aşaması'), findsOneWidget);
  });
}
