/// Yerel abonelik durumu önbelleği.
///
/// Mağaza (App Store / Play Store) gerçek durum kaynağıdır;
/// bu depo yalnızca çevrimdışı UX için son bilinen durumu saklar.
/// Veri cihaz dışına çıkmaz.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubscriptionRepository {
  SubscriptionRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'subscription_active_v1';

  final FlutterSecureStorage _storage;

  /// Son bilinen abonelik durumunu döndürür.
  Future<bool> isActive() async {
    final val = await _storage.read(key: _key);
    return val == 'true';
  }

  /// Abonelik durumunu günceller.
  Future<void> setActive(bool active) =>
      _storage.write(key: _key, value: active ? 'true' : 'false');
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(),
);
