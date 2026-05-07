import 'package:flutter_test/flutter_test.dart';
import 'package:law/core/utils/tr_date_parser.dart';

void main() {
  group('TrDateParser', () {
    group('null/boş girdi', () {
      test('null girdi null döner', () {
        expect(TrDateParser.parse(null), isNull);
      });

      test('boş string null döner', () {
        expect(TrDateParser.parse(''), isNull);
        expect(TrDateParser.parse('   '), isNull);
      });

      test('anlamsız string null döner', () {
        expect(TrDateParser.parse('lorem ipsum'), isNull);
        expect(TrDateParser.parse('2026'), isNull);
        expect(TrDateParser.parse('14:30'), isNull);
      });
    });

    group('dd.MM.yyyy HH:mm formatı (UYAP en yaygın)', () {
      test('standart örnek toUtc=false yerel zamanı korur', () {
        final r = TrDateParser.parse('01.05.2026 14:30', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30));
      });

      test('standart örnek varsayılan UTC çıkarır (-3 saat)', () {
        final r = TrDateParser.parse('01.05.2026 14:30');
        expect(r, DateTime.utc(2026, 5, 1, 11, 30));
      });

      test('saniye ile birlikte', () {
        final r = TrDateParser.parse('01.05.2026 14:30:45', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30, 45));
      });

      test('tek haneli gün/ay', () {
        final r = TrDateParser.parse('1.5.2026 9:05', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 9, 5));
      });

      test('etrafında boşluk trim edilir', () {
        final r = TrDateParser.parse('  01.05.2026 14:30  ', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30));
      });
    });

    group('dd.MM.yyyy salt tarih', () {
      test('saat verilmezse 00:00 olur', () {
        final r = TrDateParser.parse('15.03.2026', toUtc: false);
        expect(r, DateTime(2026, 3, 15));
      });
    });

    group('slash ve dash varyantları', () {
      test('dd/MM/yyyy HH:mm', () {
        final r = TrDateParser.parse('01/05/2026 14:30', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30));
      });

      test('dd-MM-yyyy HH:mm', () {
        final r = TrDateParser.parse('01-05-2026 14:30', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30));
      });
    });

    group('Türkçe ay isimleri', () {
      test('1 Mayıs 2026 14:30', () {
        final r = TrDateParser.parse('1 Mayıs 2026 14:30', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30));
      });

      test('Türkçe karaktersiz: "agustos"', () {
        final r = TrDateParser.parse('15 Agustos 2026', toUtc: false);
        expect(r, DateTime(2026, 8, 15));
      });

      test('Büyük I sorunu: "ARALIK" (büyük I → ı)', () {
        final r = TrDateParser.parse('1 ARALIK 2026', toUtc: false);
        expect(r, DateTime(2026, 12, 1));
      });

      test('Şubat tek haneli', () {
        final r = TrDateParser.parse('5 Şubat 2026', toUtc: false);
        expect(r, DateTime(2026, 2, 5));
      });

      test('bilinmeyen ay null döner', () {
        expect(TrDateParser.parse('1 FooMonth 2026'), isNull);
      });
    });

    group('ISO 8601 fallback', () {
      test('T separator, naive olarak Türkiye yerel kabul edilir', () {
        final r = TrDateParser.parse('2026-05-01T14:30:00', toUtc: false);
        expect(r, DateTime(2026, 5, 1, 14, 30));
      });

      test('Z offset UTC olarak yorumlanır', () {
        final r = TrDateParser.parse('2026-05-01T11:30:00Z');
        expect(r!.toUtc(), DateTime.utc(2026, 5, 1, 11, 30));
      });

      test('Açık offset (+03:00) UTC olarak hesaplanır', () {
        final r = TrDateParser.parse('2026-05-01T14:30:00+03:00');
        expect(r!.toUtc(), DateTime.utc(2026, 5, 1, 11, 30));
      });
    });

    group('geçersiz değerler', () {
      test('31 Şubat null döner (overflow korunur)', () {
        expect(TrDateParser.parse('31.02.2026'), isNull);
      });

      test('25:00 saati null döner', () {
        expect(TrDateParser.parse('01.05.2026 25:00'), isNull);
      });

      test('Ay 13 null döner', () {
        expect(TrDateParser.parse('01.13.2026'), isNull);
      });
    });
  });
}
