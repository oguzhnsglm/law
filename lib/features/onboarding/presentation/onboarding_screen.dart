import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/onboarding_controller.dart';
import '../state/onboarding_state.dart';
import '../widgets/onboarding_scaffold.dart';
import 'pages/consent_page.dart';
import 'pages/data_source_page.dart';
import 'pages/permissions_page.dart';
import 'pages/welcome_page.dart';

/// Onboarding ana ekranı — 4 sayfalık akış.
///
/// Sayfalar:
/// 0. Hoş geldin
/// 1. KVKK rıza (zorunlu checkbox)
/// 2. Veri kaynağı açıklaması
/// 3. İzinler + "Senkronu başlat" CTA
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({
    required this.onCompleted,
    this.permissionAsker,
    super.key,
  });

  /// Onboarding bittiğinde çağrılır; navigation çağıranda yapılır.
  final VoidCallback onCompleted;

  /// İzin asker'ı; widget testlerinde fake verilebilir.
  final PermissionAsker? permissionAsker;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handlePrimary() async {
    final state = ref.read(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    if (state.isLastPage) {
      await controller.complete();
      if (!mounted) return;
      widget.onCompleted();
      return;
    }

    controller.next();
    await _pageController.animateToPage(
      ref.read(onboardingControllerProvider).currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleSkip() {
    final controller = ref.read(onboardingControllerProvider.notifier);
    controller.goToPage(OnboardingState.totalPages - 1);
    _pageController.animateToPage(
      OnboardingState.totalPages - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _primaryLabel(OnboardingState state) {
    if (state.isLastPage) return 'İlk Senkronu Başlat';
    return 'Devam Et';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    return OnboardingScaffold(
      currentPage: state.currentPage,
      totalPages: OnboardingState.totalPages,
      primaryLabel: _primaryLabel(state),
      onPrimary: state.canAdvance && !state.completing ? _handlePrimary : null,
      onSkip: state.currentPage == 0 ? _handleSkip : null,
      completing: state.completing,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const WelcomePage(),
          const ConsentPage(),
          const DataSourcePage(),
          PermissionsPage(asker: widget.permissionAsker),
        ],
      ),
    );
  }
}
