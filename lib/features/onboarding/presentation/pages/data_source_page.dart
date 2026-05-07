import 'package:flutter/material.dart';

class DataSourcePage extends StatelessWidget {
  const DataSourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.public,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Veri Kaynağınız: UYAP',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Senkronize ettiğinizde, uygulama içindeki güvenli bir tarayıcı '
            'üzerinden e-Devlet kapısına yönlendirilirsiniz.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Şifrenizi her zaman olduğu gibi resmi e-Devlet sayfasına '
            'girersiniz; uygulamamız bu şifreye erişemez. Login başarılı '
            'olduğunda dosya ve duruşma bilgileriniz cihazınıza çekilir.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Şifreniz cihazınızda kalır, uygulamamıza iletilmez.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
