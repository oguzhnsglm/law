/// Satın alma servisi — App Store / Google Play.
///
/// Gerçek satın alma için ürün ID'si App Store Connect ve Google Play
/// Console'da `law_pro_monthly` olarak tanımlanmalı.
/// Test ortamında sandbox hesabı gerekir.
///
/// ÖNEMLİ: Bu sınıf hiçbir veriyi sunucuya göndermez; tüm işlemler
/// platform mağazası (StoreKit/Billing) üzerinden yürütülür.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BillingService {
  BillingService({InAppPurchase? iap})
      : _iap = iap ?? InAppPurchase.instance;

  /// Ürün ID'si — App Store Connect ve Play Console'da aynı ID tanımlanmalı.
  static const String productId = 'law_pro_monthly';

  final InAppPurchase _iap;

  /// Mağazanın kullanılabilir olup olmadığını döndürür.
  Future<bool> isAvailable() => _iap.isAvailable();

  /// Ürün detaylarını çeker; bulunamazsa null döner.
  Future<ProductDetails?> loadProduct() async {
    final response = await _iap.queryProductDetails({productId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  /// Satın alma başlatır (non-consumable abonelik).
  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Önceki satın alımları geri yükler.
  Future<void> restorePurchases() => _iap.restorePurchases();

  /// Satın alma olayları akışı.
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;
}

final billingServiceProvider = Provider<BillingService>(
  (ref) => BillingService(),
);
