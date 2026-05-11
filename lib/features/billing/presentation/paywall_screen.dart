import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/billing_service.dart';
import '../state/subscription_controller.dart';

/// Abonelik / ödeme duvarı ekranı.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  ProductDetails? _product;
  bool _loadingProduct = true;
  bool _storeAvailable = true;
  bool _buying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final billing = ref.read(billingServiceProvider);
    final available = await billing.isAvailable();
    if (!mounted) return;
    if (!available) {
      setState(() {
        _storeAvailable = false;
        _loadingProduct = false;
      });
      return;
    }
    final product = await billing.loadProduct();
    if (!mounted) return;
    setState(() {
      _product = product;
      _loadingProduct = false;
    });
  }

  Future<void> _buy() async {
    if (_product == null) return;
    setState(() {
      _buying = true;
      _error = null;
    });
    try {
      final billing = ref.read(billingServiceProvider);
      await billing.buy(_product!);
      // Satın alma sonucu purchaseStream üzerinden gelir; SubscriptionController
      // dinler ve subscriptionStatusProvider'ı invalidate eder. Ekran navigasyonu
      // purchaseStream listener'ı tarafından tetiklenmek yerine kullanıcı kendi
      // geri döner — ya da aşağıdaki watch ile otomatik yönlendirilir.
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _buying = true;
      _error = null;
    });
    try {
      final billing = ref.read(billingServiceProvider);
      await billing.restorePurchases();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Abonelik aktif olunca otomatik yönlendir.
    ref.listen(subscriptionStatusProvider, (_, next) {
      if (next.value == true && mounted) {
        context.go('/');
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Law Pro')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero başlık
              Icon(
                Icons.workspace_premium,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Law Pro',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Özellikler
              const _BulletList(
                items: [
                  'UYAP otomatik senkronizasyon',
                  'Sınırsız dosya ve duruşma takibi',
                  'Takvim & bildirim entegrasyonu',
                  'Öncelikli destek',
                ],
              ),
              const SizedBox(height: 32),
              // Fiyat / yükle
              if (_loadingProduct)
                const Center(child: CircularProgressIndicator())
              else if (!_storeAvailable)
                _StoreUnavailableBanner(
                  onDemoTap: () async {
                    // TODO(dev): remove before release — demo kısayolu
                    await ref
                        .read(subscriptionControllerProvider.notifier)
                        .activateLocally();
                    if (!mounted) return;
                    context.go('/'); // ignore: use_build_context_synchronously
                  },
                )
              else ...[
                if (_product != null)
                  Text(
                    _product!.price,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    'Yükleniyor…',
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                FilledButton(
                  onPressed:
                      (_buying || _product == null) ? null : _buy,
                  child: _buying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Abone Ol'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _buying ? null : _restore,
                  child: const Text('Satın Alımları Geri Yükle'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}

class _StoreUnavailableBanner extends StatelessWidget {
  const _StoreUnavailableBanner({required this.onDemoTap});

  final VoidCallback onDemoTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Mağaza şu an kullanılamıyor',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: onDemoTap,
          child: const Text('Devam et (demo)'), // TODO: remove before release
        ),
      ],
    );
  }
}
