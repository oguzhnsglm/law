# core/

Çapraz feature paylaşılan altyapı modülleri. Feature kodları buraya bağımlıdır; core feature'lara bağımlı OLMAMALIDIR.

- `db/` — Drift schema, DAOs, SQLCipher anahtar yönetimi
- `parse/` — UYAP XML/HTML parser, encoding, tarih util
- `calendar/` — `device_calendar` wrapper (iOS EventKit / Android CalendarProvider)
- `notifications/` — `flutter_local_notifications` wrapper, schedule mantığı
- `security/` — `flutter_secure_storage` (Keychain/Keystore), şifreleme yardımcıları
- `webview/` — `flutter_inappwebview` yardımcıları, e-Devlet/UYAP login akış utility'leri
- `utils/` — genel yardımcılar (extension'lar, sabitler)
