import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/billing_service.dart';
import '../data/subscription_repository.dart';

/// Yerel abonelik durumu (önbellekten).
final subscriptionStatusProvider = FutureProvider<bool>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.isActive();
});

/// Satın alma akışını dinleyen ve abonelik durumunu güncelleyen controller.
class SubscriptionController extends AsyncNotifier<bool> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  Future<bool> build() async {
    final repo = ref.watch(subscriptionRepositoryProvider);
    final billing = ref.watch(billingServiceProvider);

    // Önceki aboneliği iptal et (rebuild durumunda).
    _sub?.cancel();

    // Satın alma akışını dinle.
    _sub = billing.purchaseStream.listen(_handlePurchases);
    ref.onDispose(() => _sub?.cancel());

    return repo.isActive();
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    final repo = ref.read(subscriptionRepositoryProvider);

    for (final p in purchases) {
      if (p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored) {
        if (p.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(p);
        }
        await repo.setActive(true);
        ref.invalidate(subscriptionStatusProvider);
        state = const AsyncValue.data(true);
      } else if (p.status == PurchaseStatus.error) {
        state = AsyncValue.error(
          p.error ?? Exception('Satın alma hatası'),
          StackTrace.current,
        );
      }
      // Pending/canceled durumlar için mevcut state korunur.
    }
  }

  /// Aboneliği aktif olarak işaretler (demo/test kısayolu).
  Future<void> activateLocally() async {
    final repo = ref.read(subscriptionRepositoryProvider);
    await repo.setActive(true);
    ref.invalidate(subscriptionStatusProvider);
    state = const AsyncValue.data(true);
  }
}

final subscriptionControllerProvider =
    AsyncNotifierProvider<SubscriptionController, bool>(
  SubscriptionController.new,
);
