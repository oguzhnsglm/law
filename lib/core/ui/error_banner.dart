import 'package:flutter/material.dart';

/// Hata durumları için kullanıcı dostu banner / centered card.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    required this.message,
    this.title = 'Bir şeyler ters gitti',
    this.onRetry,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar dene'),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
