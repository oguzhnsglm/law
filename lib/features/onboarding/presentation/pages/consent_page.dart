import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/onboarding_controller.dart';

class ConsentPage extends ConsumerWidget {
  const ConsentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.shield_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Verileriniz Sizin',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _bullet(theme, 'Şifreniz cihazınızdan çıkmaz'),
          _bullet(theme, 'Sunucumuz yok'),
          _bullet(theme, 'İstediğiniz zaman silebilirsiniz'),
          const SizedBox(height: 24),
          TextButton.icon(
            icon: const Icon(Icons.description_outlined),
            label: const Text('Aydınlatma metnini oku'),
            onPressed: () => _showNotice(context),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: state.kvkkAccepted,
            onChanged: (v) => controller.setKvkkAccepted(v ?? false),
            title: const Text(
              'KVKK aydınlatma metnini okudum, kabul ediyorum',
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: state.crashReportingOptIn,
            onChanged: (v) => controller.setCrashReporting(v ?? false),
            title: const Text(
              'İsteğe bağlı: Anonim çökme raporu gönderilsin',
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _bullet(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }

  Future<void> _showNotice(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('KVKK Aydınlatma Metni'),
        content: const SingleChildScrollView(
          child: Text(
            'Law uygulaması, kullanıcı verisini cihazda tutar. Şifreniz '
            'doğrudan resmi e-Devlet sitesine girilir; uygulamamıza '
            'iletilmez. Tüm dosya ve duruşma verileriniz cihazınızda '
            'AES-256 şifreli yerel veritabanında saklanır. '
            'Tam metin için "Ayarlar → Yasal" bölümüne bakabilirsiniz.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
