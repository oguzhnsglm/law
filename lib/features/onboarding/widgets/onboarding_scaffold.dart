import 'package:flutter/material.dart';

import 'page_indicator.dart';

/// Onboarding sayfaları için ortak iskelet.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.currentPage,
    required this.totalPages,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.onSkip,
    this.completing = false,
    super.key,
  });

  final int currentPage;
  final int totalPages;
  final Widget body;
  final String primaryLabel;

  /// `null` ise birincil buton disabled olur.
  final VoidCallback? onPrimary;

  /// "Atla" linki; null ise gizlenir.
  final VoidCallback? onSkip;

  final bool completing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(child: body),
              const SizedBox(height: 16),
              PageIndicator(currentIndex: currentPage, total: totalPages),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: completing ? null : onPrimary,
                  child: completing
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(primaryLabel),
                ),
              ),
              if (onSkip != null)
                TextButton(
                  onPressed: completing ? null : onSkip,
                  child: const Text('Atla'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
