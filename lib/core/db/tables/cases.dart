import 'package:drift/drift.dart';
import 'package:law/core/db/converters/parties_converter.dart';
import 'package:law/core/db/models/party.dart';

/// Dava kayıtlarını tutan tablo.
///
/// Her satır benzersiz bir [dosyaNo] ile tanımlanan bir davayı temsil eder.
class Cases extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// UYAP'taki benzersiz dosya numarası. Upsert işlemlerinde anahtar olarak kullanılır.
  TextColumn get dosyaNo => text().unique()();

  /// Mahkemenin tam adı (ör. 'İstanbul 1. Asliye Hukuk Mahkemesi').
  TextColumn get mahkemeAdi => text()();

  /// Mahkeme türü (ör. 'Asliye Hukuk', 'İdare').
  TextColumn get mahkemeTuru => text().nullable()();

  /// Dava türü (ör. 'Hukuk Davası').
  TextColumn get dosyaTuru => text().nullable()();

  /// JSON olarak kodlanmış [Party] listesi.
  TextColumn get taraflarJson =>
      text().withDefault(const Constant('[]')).map(const PartiesConverter())();

  /// Davanın güncel durumu.
  TextColumn get durum => text().nullable()();

  /// UYAP'ta kayıtlı son işlem tarihi.
  DateTimeColumn get sonIslemTarihi => dateTime().nullable()();

  /// Bu kaydın son senkronizasyon tarihi.
  DateTimeColumn get sonSenkronTarihi => dateTime()();
}
