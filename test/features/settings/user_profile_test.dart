import 'package:flutter_test/flutter_test.dart';
import 'package:law/features/settings/data/notification_prefs.dart';
import 'package:law/features/settings/data/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('boş profilde isEmpty=true', () {
      const p = UserProfile();
      expect(p.isEmpty, isTrue);
      expect(p.displayName, '');
    });

    test('displayName ad+soyad birleştirir', () {
      const p = UserProfile(ad: 'Mert', soyad: 'Yıldız');
      expect(p.displayName, 'Mert Yıldız');
      expect(p.isEmpty, isFalse);
    });

    test('JSON serializasyon roundtrip', () {
      const p = UserProfile(
        ad: 'Ayşegül',
        soyad: 'Demir',
        baroSicil: '12345',
        baroAdi: 'Ankara',
      );
      final str = p.toJsonString();
      final back = UserProfile.fromJsonString(str);
      expect(back, equals(p));
    });

    test('copyWith sadece verilen alanları değiştirir', () {
      const p = UserProfile(ad: 'A', soyad: 'B', baroSicil: '1');
      final u = p.copyWith(soyad: 'C');
      expect(u.ad, 'A');
      expect(u.soyad, 'C');
      expect(u.baroSicil, '1');
    });
  });

  group('NotificationPrefs', () {
    test('default değerleri tüm bildirimleri açar', () {
      const n = NotificationPrefs();
      expect(n.notificationsEnabled, isTrue);
      expect(n.oneDayBefore, isTrue);
      expect(n.oneDayBeforeHour, 21);
      expect(n.twoHoursBefore, isTrue);
    });

    test('JSON roundtrip', () {
      const n = NotificationPrefs(
        notificationsEnabled: false,
        oneDayBefore: false,
        oneDayBeforeHour: 18,
        twoHoursBefore: true,
      );
      final back = NotificationPrefs.fromJsonString(n.toJsonString());
      expect(back, equals(n));
    });
  });
}
