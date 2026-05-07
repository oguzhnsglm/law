import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class LawApp extends ConsumerWidget {
  const LawApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Law',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
