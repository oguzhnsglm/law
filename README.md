# Law — Avukatlar için Mobil Duruşma Takvim Asistanı

Avukatların UYAP üzerindeki dosya ve duruşma bilgilerini mobil cihazlarına otomatik olarak aktaran, hem uygulama içi takvim sunan hem de iOS/Android native takvimleriyle senkronize olan Flutter tabanlı mobil uygulama.

---

## 0. İlerleme Takibi Kuralı

> **Kural:** README'de listelenen herhangi bir adım veya görev **tamamlandığında**, o satırın sonuna `**(YAPILDI — YYYY-MM-DD)**` etiketi eklenir. Etiket atılmadan iş "tamamlandı" sayılmaz. Bu sayede planın hangi kısımlarının bittiği bir bakışta görülür.
>
> Örnek: `- [x] Repo init **(YAPILDI — 2026-05-06)**`
>
> İptal edilen veya kapsam dışına çıkan maddeler için `**(İPTAL — sebep)**` etiketi kullanılır.

---

## 1. Vizyon ve Hedef Kullanıcı

**Hedef kullanıcı:** Türkiye'de aktif avukatlar (UYAP Avukat Portal kullanıcıları).

**Çözdüğü problem:** Avukatlar duruşma takiplerini hâlâ manuel olarak (defter, Excel, sekreter) yapıyor. UYAP Avukat Portal mobil uyumlu değil ve bildirim göndermez. Avukatlar gün içinde birden fazla mahkemeye dağılmış duruşmalarını yönetmekte zorlanıyor.

**Çözüm:** Kullanıcının kendi UYAP/e-Devlet oturumunu uygulama içi WebView üzerinden açması, uygulamanın bu oturumdan duruşma verilerini parse etmesi, native takvime ve bildirim sistemine yazması.

---

## 2. Platform Stratejisi — Flutter / Dart

Tek kod tabanından hem Android (APK/AAB) hem iOS (IPA) çıktısı alınacak.

**Flutter tercih sebebi:**
- Tek ekip, tek dil (Dart), iki platform
- WebView, native takvim, bildirim, secure storage gibi tüm ihtiyaçlar mature paketlerle hazır
- iOS Swift / Android Kotlin ayrı ekip maliyeti yok
- UI performansı yeterli (canvas tabanlı render)

**Platform-spesifik ayar gerektiren noktalar:**
- iOS `Info.plist`: takvim erişim izni, bildirim izni, WebView ayarları
- Android `AndroidManifest.xml`: `READ_CALENDAR`, `WRITE_CALENDAR`, `POST_NOTIFICATIONS`, `INTERNET`
- iOS App Transport Security istisnaları (UYAP HTTPS uyumlu, sorun beklenmiyor)

---

## 3. UYAP Veri Erişim Stratejisi

### Seçilen Yaklaşım: Cihaz Tarafı WebView (In-App Browser)

Kullanıcı, uygulama içindeki WebView üzerinden kendi e-Devlet şifresiyle UYAP Avukat Portal'a giriş yapar. Uygulama, kullanıcının kendi oturumunda görünen sayfa içeriğini parse ederek dosya ve duruşma verilerini çıkarır.

### Neden Bu Yaklaşım

| Kriter | Sunucu Scraping | Cihaz WebView | Manuel XML | Resmi Protokol |
|---|---|---|---|---|
| Otomasyon | Yüksek | Orta-Yüksek | Düşük | Yüksek |
| Hukuki Risk | Yüksek | Düşük | Yok | Yok |
| Şifre Saklama | Var (KVKK riski) | **Yok** | Yok | Yok |
| Bot Tespit Riski | Yüksek | Yok | Yok | Yok |
| 2FA/SMS Sorunu | Var | Yok (kullanıcı kendi telefonunda kodu girer) | Yok | Yok |
| MVP Süresi | 6 hafta | 5 hafta | 4 hafta | 3-6 ay (bekleme) |

Cihaz tarafı WebView, hukuki risk + teknik stabilite + UX dengesi açısından en optimum noktadır. Kullanıcı kendi cihazında, kendi oturumunda, kendi verisine erişiyor; uygulama yalnızca parse aracı.

### Akış

```
1. Kullanıcı uygulamayı açar, "Senkronize et" butonuna basar
2. WebView açılır → giris.turkiye.gov.tr
3. Kullanıcı e-Devlet bilgilerini WebView içinde girer (şifre uygulama
   sunucusuna gitmez, cihazdan dışarı çıkmaz)
4. Login sonrası WebView UYAP Avukat Portal'a yönlendirilir
5. Uygulama, oturumun cookie'lerini ve sayfa içeriğini okur, gerekirse
   "Dosyalarım → XML export" endpoint'ini tetikler
6. Çekilen veri yerel SQLite veritabanına yazılır
7. Yeni/değişen duruşmalar native takvime ve lokal bildirim sistemine
   schedule edilir
```

### Resmi Protokol Paralel Süreci

MVP cihaz WebView ile çıkarılırken paralel olarak resmi UYAP Avukat Web Servisleri başvurusu da başlatılır. Bu yol açıldığında (3-6 ay) WebView altyapısı söküp resmi SOAP/REST entegrasyonuna geçilir, kullanıcı UX'i değişmez.

---

## 4. Sistem Mimarisi

### MVP'de Sunucu Yok — Tüm İşlem Cihazda

```
┌─────────────────────────────────────────────────┐
│                  Flutter App                     │
│                                                  │
│  ┌──────────────┐     ┌────────────────────┐   │
│  │ UI Layer     │     │ WebView Module     │   │
│  │ (Material 3) │     │ flutter_inappweb.. │   │
│  └──────┬───────┘     └─────────┬──────────┘   │
│         │                       │               │
│  ┌──────▼───────────────────────▼──────────┐   │
│  │      Domain / Service Layer             │   │
│  │  - Auth, Sync, Parse, Schedule          │   │
│  └──────┬──────────────────────────────────┘   │
│         │                                       │
│  ┌──────▼─────────┐  ┌──────────────────────┐ │
│  │ Local DB       │  │ Native Bridges       │ │
│  │ Drift+SQLCipher│  │ - Calendar (EventKit/│ │
│  │                │  │   CalendarProvider)   │ │
│  │                │  │ - Local Notifications│ │
│  │                │  │ - Secure Storage     │ │
│  └────────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────────┘
```

### Faz 2 (İleride) — Push İçin Minimum Sunucu

iOS arka plan kısıtı nedeniyle "kullanıcı app'i açmadan yeni duruşma bildirimi" göndermek için ileride opsiyonel sunucu eklenebilir. MVP için **gerekli değil** — bildirimler lokal olarak schedule edilir, app kapalıyken de gelir.

---

## 5. Teknoloji Yığını

### Frontend (Flutter)

| Katman | Paket | Amaç |
|---|---|---|
| State management | `riverpod` | Reaktif state, dependency injection |
| Routing | `go_router` | Deklaratif yönlendirme |
| WebView | `flutter_inappwebview` | UYAP/e-Devlet oturumu, cookie/DOM erişimi |
| Yerel DB | `drift` + `sqlcipher_flutter_libs` | Şifreli SQLite |
| HTTP / parse | `dio`, `html`, `xml` | Sayfa içeriği parse |
| Takvim | `device_calendar` | iOS EventKit / Android CalendarProvider |
| Bildirim | `flutter_local_notifications` | Lokal bildirim schedule |
| Secure storage | `flutter_secure_storage` | Keychain/Keystore (token, ayarlar) |
| Tarih/saat | `timezone`, `intl` | TR locale, timezone aware schedule |
| Loglama | `logger` | Debug + crash log |

### Native Tarafta Konfigürasyon

**iOS (`ios/Runner/Info.plist`):**
- `NSCalendarsUsageDescription`
- `NSRemindersUsageDescription` (gerekirse)
- WKWebView cookie persistence ayarları

**Android (`android/app/src/main/AndroidManifest.xml`):**
- `READ_CALENDAR`, `WRITE_CALENDAR`
- `POST_NOTIFICATIONS` (Android 13+)
- `INTERNET`
- `RECEIVE_BOOT_COMPLETED` (alarm bildirimleri için)
- `SCHEDULE_EXACT_ALARM` (Android 12+ için tam zamanlı bildirim)

---

## 6. Veri Modeli

### Yerel Veritabanı Şeması (Drift / SQLite, SQLCipher ile şifreli)

**`users`** — yerel kullanıcı profili
- id, ad_soyad, baro_sicil, tc_kimlik (hash), olusturma_tarihi

**`cases`** — UYAP'tan çekilen dosyalar
- id, dosya_no, mahkeme_adi, mahkeme_turu, dosya_turu, taraflar (JSON),
  durum, son_islem_tarihi, son_senkron_tarihi

**`hearings`** — duruşmalar
- id, case_id (FK), durusma_tarihi (UTC), durusma_saati, salon, gundem,
  bildirim_tetiklendi (bool), takvim_event_id (native event UID),
  son_senkron_tarihi

**`sync_logs`** — her senkronun audit izi
- id, baslangic_zamani, bitis_zamani, basarili (bool), eklenen_sayi,
  guncellenen_sayi, hata_mesaji

**`user_notes`** — kullanıcı manuel notları (UYAP senkronu silmesin)
- id, hearing_id (FK), not_metni, olusturma_tarihi

### Idempotent Senkron

Her dosya `dosya_no` üzerinden, her duruşma `(case_id, durusma_tarihi)` kombinasyonu üzerinden tekilleşir. Aynı senkron iki kez çalıştırılsa duplicate üretmez. Native takvim event'lerinde `takvim_event_id` saklanır; ikinci senkronda aynı UID güncellenir, yenisi yazılmaz.

---

## 7. Uygulama Akışları

### Onboarding
1. Hoş geldin ekranı + ürün açıklaması
2. KVKK aydınlatma metni + açık rıza onayı
3. Kullanıcı bilgileri (ad, baro sicil) — opsiyonel
4. Takvim ve bildirim izinleri
5. "İlk senkronizasyonu başlat" CTA

### Senkronizasyon (Görünmez WebView)
1. Kullanıcı "Senkronize et" tetikler (veya app açılışında otomatik)
2. WebView açılır — kullanıcı e-Devlet → UYAP login akışını gerçekleştirir
3. Login sonrası uygulama otomatik veri çeker (XML export tercih edilir; yoksa HTML parse)
4. Diff hesaplanır: yeni dosya, yeni duruşma, değişen tarih
5. DB güncellenir, takvim sync edilir, lokal bildirimler schedule edilir
6. Kullanıcıya özet: "32 dosya kontrol edildi, 3 yeni duruşma eklendi"

### Bildirim
- Duruşmadan **1 gün önce** akşam saatinde bir bildirim
- Duruşma günü **2 saat önce** ikinci bildirim
- Tarihler değiştiğinde "Duruşma tarihi güncellendi" bildirimi
- Tüm bildirimler `flutter_local_notifications` ile **lokal schedule** — app kapalıyken de gelir

### Takvim Senkronu
- Her duruşma için native takvim event'i oluşturulur
- Başlık: "Duruşma — [Mahkeme Adı]"
- Açıklama: dosya no, taraflar, gündem
- Lokasyon: mahkeme salonu
- Hatırlatma: 1 gün ve 2 saat önce (kullanıcı ayarlardan değiştirebilir)
- Tek yönlü sync: app → cihaz takvimi (cihazdan silme app'i etkilemez)

---

## 8. Geliştirme Yol Haritası

### Faz 0 — Hukuki ve Kurumsal Hazırlık (Paralel, 2-4 hafta)
- Limited şirket kuruluşu
- VERBİS kaydı (sunucu tarafı veri yoksa minimum kapsam)
- KVKK aydınlatma metni hazırlığı (bilişim hukuku danışmanlığı)
- UYAP Avukat Web Servisleri için Adalet Bakanlığı'na resmi başvuru
- Domain + Apple Developer + Google Play Developer hesapları
- Git repo init + remote bağlama **(YAPILDI — 2026-05-06)**
- README ve proje planı **(YAPILDI — 2026-05-06)**

### Faz 1 — Veri Katmanı (Hafta 1-2)
- Flutter projesi initialize, klasör yapısı
- 2-3 örnek UYAP XML/HTML topla → şema reverse-engineer
- Drift + SQLCipher kurulumu, tablolar
- XML/HTML parser modülleri + unit testler
- Tarih parse (TR locale, çoklu format desteği)

### Faz 2 — WebView ve Senkron (Hafta 3)
- `flutter_inappwebview` entegrasyonu
- e-Devlet → UYAP login akışı testleri
- Cookie/storage management
- XML export endpoint'inin programatik tetiklenmesi
- Idempotent merge mantığı

### Faz 3 — UI ve Native Entegrasyonlar (Hafta 4)
- Onboarding ekranları + KVKK rıza akışı
- Liste, takvim, detay ekranları
- `device_calendar` ile native takvim sync
- `flutter_local_notifications` ile bildirim schedule
- İzin akışları (iOS + Android)

### Faz 4 — Cila ve Test (Hafta 5)
- Manuel not ekleme, etiketleme
- Arama ve filtreleme
- XML manuel import (m-imza/e-imza kullanıcılar için fallback)
- Yedekleme/restore
- Beta test (5-10 avukat)

### Faz 5 — Yayın (Hafta 6)
- Apple App Store Connect submission
- Google Play Console submission
- Crash analytics (Sentry self-hosted veya Firebase Crashlytics)
- Kullanıcı geri bildirim kanalı

---

## 9. KVKK ve Hukuki Uyum

### Veri Akışı Açısından Avantaj
Bu mimaride kullanıcı verisi **uygulama sunucusuna hiç gitmiyor.** Şifre, dosya bilgisi, duruşma bilgisi — hepsi cihazda kalıyor. Bu, KVKK kapsamını dramatik şekilde daraltıyor.

### Yapılacaklar
1. **Aydınlatma metni** — uygulama içinde erişilebilir, açık dille:
   - Hangi veri toplanır (cihaz lokal, sunucuya iletilmez)
   - Veriye nasıl erişilir (kullanıcının kendi UYAP/e-Devlet oturumu)
   - Saklama süresi (kullanıcı uygulamayı silene kadar)
   - Üçüncü partilerle paylaşım yok
2. **Açık rıza** — onboarding'de checkbox
3. **Veri minimizasyonu** — sadece duruşma takvimi için gerekli alanlar parse edilir; suç tipi gibi hassas özel nitelikli veri **hiç tutulmaz**
4. **Yerel şifreleme** — Drift veritabanı SQLCipher ile AES-256 şifreli
5. **Anahtar saklama** — DB şifreleme anahtarı `flutter_secure_storage` (iOS Keychain / Android Keystore) ile cihaz seviyesinde
6. **Veri silme hakkı** — ayarlarda "Tüm verilerimi sil" butonu
7. **Veri taşıma hakkı** — "Verilerimi XML olarak dışa aktar"
8. **VERBİS** — sunucu tarafı veri olmadığı sürece tartışmalı; bilişim hukuku danışmanına netleştirt
9. **Bilişim hukuku danışmanlığı** — yayın öncesi bir kez tam review

### UYAP / e-Devlet Kullanım Şartları
- Kullanıcı login'i **kullanıcı kendisi** yaptığı için "otomatik bot erişimi" yasağı kapsamı dışında
- Veri **kullanıcının kendi verisi** ve **kendi oturumu**, üçüncü partiye aktarılmıyor
- Kullanım şartlarının "scripting" maddeleri yorum gerektiriyor; danışmanlıkla kesinleştirilecek

---

## 10. Riskler ve Azaltma Stratejileri

| Risk | Olasılık | Etki | Azaltma |
|---|---|---|---|
| UYAP HTML/akış değişir, parser kırılır | Yüksek | Orta | Modüler parser + uzaktan güncellenebilir selector config |
| e-Devlet bot koruması WebView'i de tetikler | Düşük | Yüksek | Gerçek kullanıcı login'i — düşük olasılık; tetiklenirse kullanıcı kendi telefonunda kodu girer |
| Apple App Store reddi (WebView login) | Orta | Yüksek | "User content access via authenticated session" gerekçesi + KVKK rızası belgeleri |
| UYAP resmi uyarı yollar | Düşük | Orta | Yaklaşımı kullanıcı ajan modeline çevir / resmi protokole geç |
| m-imza zorunluluğu yaygınlaşır | Orta | Yüksek | XML manuel import fallback'i hazır tut |
| KVKK denetimi | Düşük | Yüksek | Sunucusuz mimari + danışmanlık + dokümantasyon |

---

## 11. Klasör Yapısı (Önerilen)

```
law/
├── lib/
│   ├── main.dart
│   ├── app/                    # Router, theme, app shell
│   ├── features/
│   │   ├── onboarding/
│   │   ├── auth/               # KVKK rıza, kullanıcı profili
│   │   ├── sync/               # WebView, parse, merge
│   │   ├── cases/              # Dosya listesi/detay
│   │   ├── hearings/           # Duruşma listesi/detay/takvim
│   │   ├── notifications/      # Lokal bildirim mantığı
│   │   └── settings/
│   ├── core/
│   │   ├── db/                 # Drift schema + DAOs
│   │   ├── parse/              # XML/HTML parser
│   │   ├── calendar/           # device_calendar wrapper
│   │   ├── security/           # Secure storage, encryption
│   │   └── utils/
│   └── l10n/                   # TR/EN dil dosyaları
├── ios/
├── android/
├── test/
├── integration_test/
├── docs/
│   ├── kvkk_aydinlatma.md
│   ├── uyap_parse_schema.md
│   └── architecture.md
├── pubspec.yaml
└── README.md
```

---

## 12. Geliştirme Rehberi (Detaylı)

Bu bölüm, projeyi sıfırdan ayağa kaldırmak ve UYAP entegrasyonunu adım adım uygulamak isteyen geliştirici için rehberdir.

### 12.1. Geliştirme Ortamı Kurulumu

**Gerekli araçlar:**

```bash
# Flutter SDK (3.24+)
# https://docs.flutter.dev/get-started/install
flutter --version

# iOS geliştirme (sadece macOS)
xcode-select --install
sudo gem install cocoapods

# Android geliştirme
# Android Studio + Android SDK 34+
# JDK 17

flutter doctor   # tüm bileşenler ✓ olmalı
```

**Editör:** VS Code + Flutter/Dart eklentileri, veya Android Studio.

**Cihaz/emulator:** Geliştirme için Android emülatör + iOS simülatör; **WebView akışını mutlaka gerçek cihazda test et** (e-Devlet bazen emülatörü tetikler).

### 12.2. Projeyi Bootstrap Etme

```bash
# Repo köküne git
cd law

# Flutter projesi oluştur (mevcut dizine, README'yi koruyarak)
flutter create --org tr.com.law --project-name law \
  --platforms=android,ios --description "UYAP Avukat Takvim Asistanı" .

# pubspec.yaml'a paketleri ekle
flutter pub add flutter_riverpod go_router flutter_inappwebview \
  drift sqlcipher_flutter_libs drift_flutter \
  device_calendar flutter_local_notifications \
  flutter_secure_storage dio html xml \
  timezone intl logger

# Dev bağımlılıkları
flutter pub add --dev drift_dev build_runner riverpod_generator \
  riverpod_lint custom_lint mocktail

flutter pub get
```

**iOS minimum platform:** `ios/Podfile` içinde `platform :ios, '13.0'` (WebView ve EventKit için).

**Android minimum SDK:** `android/app/build.gradle` içinde `minSdkVersion 23`, `targetSdkVersion 34`.

### 12.3. Native İzin Konfigürasyonu

**iOS — `ios/Runner/Info.plist`:**

```xml
<key>NSCalendarsUsageDescription</key>
<string>Duruşmalarınızı takviminize eklemek için izin gerekiyor.</string>
<key>NSCalendarsFullAccessUsageDescription</key>
<string>Duruşmalarınızı takviminize eklemek için izin gerekiyor.</string>
<key>NSUserNotificationsUsageDescription</key>
<string>Duruşma hatırlatmaları için bildirim izni gerekiyor.</string>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoadsInWebContent</key>
  <true/>
</dict>
```

**Android — `android/app/src/main/AndroidManifest.xml`:**

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

### 12.4. Veritabanı (Drift + SQLCipher)

**`lib/core/db/database.dart`:**

```dart
@DriftDatabase(tables: [Cases, Hearings, SyncLogs, UserNotes])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() {
    return driftDatabase(
      name: 'law_app',
      native: const DriftNativeOptions(
        // SQLCipher anahtarı secure storage'dan
        databasePath: ...,
      ),
    );
  }
}
```

**Şifreleme anahtarı:**
- İlk açılışta 32 byte random key üret
- `flutter_secure_storage` ile sakla (iOS Keychain / Android Keystore)
- DB açılışında oku, SQLCipher'a `PRAGMA key` olarak ver

**Migration:** Drift `MigrationStrategy` ile schema versiyonlama; UYAP şema değişimleri parser'da, DB şemasında değil.

### 12.5. UYAP'tan Veri Çekme — Detaylı Strateji

#### Adım 1: WebView Açma ve Login Akışı

**`lib/features/sync/uyap_webview.dart`:**

```dart
class UyapWebView extends StatefulWidget {
  final ValueChanged<UyapSession> onLoginSuccess;
  // ...
}

class _UyapWebViewState extends State<UyapWebView> {
  late InAppWebViewController _controller;

  static const _eDevletLoginUrl =
      'https://giris.turkiye.gov.tr/Giris/gir';
  static const _uyapAvukatPortal =
      'https://avukatbeta.uyap.gov.tr';

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(_eDevletLoginUrl)),
      initialSettings: InAppWebViewSettings(
        userAgent: 'Mozilla/5.0 ...', // gerçek mobile UA
        clearCache: false,            // session persist edilsin
        thirdPartyCookiesEnabled: true,
        sharedCookiesEnabled: true,
      ),
      onWebViewCreated: (c) => _controller = c,
      onLoadStop: (c, url) async {
        if (url == null) return;
        // 1. e-Devlet login başarılı mı?
        if (url.host.contains('turkiye.gov.tr') &&
            url.path.contains('Anasayfa')) {
          // UYAP'a yönlendir
          await c.loadUrl(
            urlRequest: URLRequest(url: WebUri(_uyapAvukatPortal)),
          );
        }
        // 2. UYAP Avukat Portal'a vardık mı?
        if (url.host.contains('uyap.gov.tr') &&
            url.path.contains('avukat')) {
          final cookies =
              await CookieManager.instance().getCookies(url: url);
          widget.onLoginSuccess(UyapSession(cookies: cookies));
        }
      },
    );
  }
}
```

**Kullanıcı deneyimi:**
- WebView **görünür** açılır (kullanıcı login'i kendisi yapar)
- Login başarılı olduğunda WebView üstüne "Bağlanıyor..." overlay'i koyup arka planda veri çek, bitince kapat

#### Adım 2: Veri Çekme — Üç Olası Yol

**Yol A — XML Export Endpoint Tetikleme (Tercih Edilen):**

UYAP Avukat Portal'da "Dosyalarım → XML olarak indir" benzeri bir endpoint var. Login session'ı geçerliyken JavaScript injection ile tetiklenebilir:

```dart
final xmlContent = await _controller.evaluateJavascript(source: '''
  (async () => {
    const resp = await fetch('/avukat/dosyaListesiXmlExport', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Accept': 'application/xml' },
      body: new URLSearchParams({
        baslangicTarihi: '01.01.2025',
        bitisTarihi: '31.12.2026',
      }),
    });
    return await resp.text();
  })()
''');
```

Endpoint'in tam path'i UYAP'ın canlı portalında DevTools network sekmesi ile tespit edilir. **Bu adım ilk reverse-engineering işidir** ve `docs/uyap_parse_schema.md` içinde dokümante edilir.

**Yol B — HTML Sayfa Parse:**

XML endpoint çalışmazsa veya bulunamazsa, dosya listesi sayfasının HTML'ini çek ve `package:html` ile parse et:

```dart
final html = await _controller.evaluateJavascript(source: '''
  (async () => {
    const resp = await fetch('/avukat/dosyalarim', { credentials: 'include' });
    return await resp.text();
  })()
''');

final document = html_parser.parse(html);
final rows = document.querySelectorAll('table.dosya-listesi tr');
for (final row in rows) {
  final cells = row.querySelectorAll('td');
  // ... model'e map et
}
```

**Yol C — Sayfa Sayfa Detay Çekme:**

Her dosyanın detay sayfasında safahat, taraflar, duruşmalar var. Liste sayfasından dosya ID'leri al, paralel olarak detay sayfalarını fetch et (2-3 paralel max, UYAP rate limit var).

#### Adım 3: Parser Mimarisi

**`lib/core/parse/uyap_xml_parser.dart`:**

```dart
class UyapXmlParser {
  ParseResult parse(String xmlContent) {
    final doc = XmlDocument.parse(xmlContent);
    final cases = <CaseModel>[];
    final hearings = <HearingModel>[];

    for (final dosyaEl in doc.findAllElements('Dosya')) {
      final caseModel = CaseModel(
        dosyaNo: _text(dosyaEl, 'DosyaNo'),
        mahkemeAdi: _text(dosyaEl, 'MahkemeAdi'),
        // ...
      );
      cases.add(caseModel);

      for (final durusmaEl in dosyaEl.findElements('Durusma')) {
        hearings.add(HearingModel(
          caseDosyaNo: caseModel.dosyaNo,
          durusmaTarihi: _parseTrDate(_text(durusmaEl, 'Tarih')),
          salon: _text(durusmaEl, 'Salon'),
          // ...
        ));
      }
    }

    return ParseResult(cases: cases, hearings: hearings);
  }

  DateTime _parseTrDate(String s) {
    // "01.05.2026 14:30" veya "2026-05-01T14:30" gibi varyantlar
    for (final fmt in ['dd.MM.yyyy HH:mm', 'yyyy-MM-ddTHH:mm']) {
      try {
        return DateFormat(fmt, 'tr_TR').parseStrict(s);
      } catch (_) {}
    }
    throw FormatException('Bilinmeyen tarih formatı: $s');
  }
}
```

**Encoding handling:** UYAP bazen Windows-1254 (Türkçe) çıktı veriyor. `Encoding` tespit et, gerekirse decode et.

**Stream parse:** Büyük dosyalar (5-10 MB) için `XmlEventReader` kullan, tüm dokümanı belleğe yükleme.

#### Adım 4: Idempotent Merge

**`lib/features/sync/sync_service.dart`:**

```dart
class SyncService {
  Future<SyncSummary> mergeIntoDb(ParseResult parsed) async {
    int added = 0, updated = 0;
    await db.transaction(() async {
      for (final c in parsed.cases) {
        final existing = await casesDao.byDosyaNo(c.dosyaNo);
        if (existing == null) {
          await casesDao.insert(c);
          added++;
        } else if (existing.hashOf() != c.hashOf()) {
          await casesDao.update(existing.id, c);
          updated++;
        }
      }
      for (final h in parsed.hearings) {
        // (case_id, durusma_tarihi) üzerinden tekille
        await hearingsDao.upsert(h);
      }
    });
    return SyncSummary(added: added, updated: updated);
  }
}
```

**Kullanıcı manuel notları silinmesin:** `user_notes` tablosu ayrı, UYAP senkronu hiç dokunmuyor.

### 12.6. Native Takvim Senkronu

**`lib/core/calendar/calendar_service.dart`:**

```dart
final _devCal = DeviceCalendarPlugin();

Future<void> syncHearingToCalendar(Hearing h, String calendarId) async {
  final event = Event(
    calendarId,
    eventId: h.takvimEventId, // varsa update, yoksa create
    title: 'Duruşma — ${h.mahkemeAdi}',
    description: 'Dosya: ${h.dosyaNo}\nTaraflar: ${h.taraflar}',
    location: h.salon,
    start: TZDateTime.from(h.durusmaTarihi, tz.getLocation('Europe/Istanbul')),
    end: ...,
    reminders: [
      Reminder(minutes: 24 * 60),  // 1 gün önce
      Reminder(minutes: 120),       // 2 saat önce
    ],
  );
  final res = await _devCal.createOrUpdateEvent(event);
  if (res?.isSuccess == true && h.takvimEventId == null) {
    await hearingsDao.setEventId(h.id, res!.data!);
  }
}
```

**İzin kontrolü:** İlk kullanımda `_devCal.requestPermissions()`. Reddedilirse settings ekranında tekrar isteme akışı.

**Tek yönlü sync:** Cihazdan event silinse bile uygulama veritabanı kaynak. Bir sonraki senkronda tekrar yazılır (kullanıcı bunu kapatabilmeli — ayar).

### 12.7. Lokal Bildirimler

**`lib/features/notifications/notification_service.dart`:**

```dart
final _notif = FlutterLocalNotificationsPlugin();

Future<void> scheduleHearingReminders(Hearing h) async {
  final tzTime = TZDateTime.from(
    h.durusmaTarihi.subtract(const Duration(days: 1, hours: -20)),
    tz.getLocation('Europe/Istanbul'),
  );
  await _notif.zonedSchedule(
    h.id,
    'Yarın duruşmanız var',
    '${h.mahkemeAdi} — ${DateFormat.Hm().format(h.durusmaTarihi)}',
    tzTime,
    NotificationDetails(
      android: AndroidNotificationDetails('hearings', 'Duruşmalar'),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

**Önemli:** Bildirimler **lokal schedule edildiği** için app kapalı/silinmiş bile değilse gelir. iOS arka plan kısıtı bunu etkilemez.

### 12.8. Senkron Tetikleme Stratejisi

**Tetikleyiciler:**
- App açılışı (son senkrondan 6+ saat geçmişse otomatik)
- Manuel "Senkronize et" butonu
- Pull-to-refresh (liste ekranlarında)
- Android'de `WorkManager` ile günlük opsiyonel arka plan denemesi (iOS'ta yok)

**Kullanıcıya gösterim:**
- Senkron sürerken: progress + "WebView'de e-Devlet'e giriş yap" yönlendirmesi
- Bittiğinde: "32 dosya kontrol edildi · 3 yeni duruşma · 1 değişen tarih"
- Hata: "UYAP'a ulaşılamadı, internet bağlantını kontrol et"

### 12.9. Test Stratejisi

**Unit testler (`test/`):**
- Parser: 5-10 örnek XML için fixture testleri
- Tarih parse: tüm format varyantları
- Idempotent merge: aynı input iki kez → 0 değişiklik

**Widget testler:**
- Onboarding akışı
- Liste/detay ekranları

**Integration testler (`integration_test/`):**
- Tam senkron akışı (mocked WebView ile)
- Takvim yazma (gerçek cihazda)

**Manuel test:**
- 5-10 gerçek avukat ile beta — farklı UYAP hesap konfigürasyonları (m-imza vs e-Devlet, az/çok dosyalı, çoklu mahkeme)

### 12.10. Reverse Engineering İş Akışı (Kritik)

UYAP şemasını çıkarmak projenin en kritik adımı. Sıralama:

1. **Bir avukat dostundan** (veya kendi hesabınla) UYAP Avukat Portal'a Chrome DevTools açık şekilde gir
2. **Network sekmesi**ni kaydet, "Dosyalarım", "Duruşma takvimi", "XML export" gibi sayfaları gez
3. Her endpoint için:
   - Request: URL, method, headers, body
   - Response: format (XML/HTML/JSON), schema
4. **Anonim örnek dosyalar topla** (3-5 farklı avukat) — taraf isimlerini fixture'larda anonimleştir
5. `docs/uyap_parse_schema.md` içinde her endpoint'i + örneği dokümante et
6. Parser'ı bu örneklerle TDD yaklaşımıyla yaz

**Bu adımı atlama** — şema bilgisi olmadan yazılan parser bir hafta çöpe gider.

### 12.11. Yayın Hazırlığı

**iOS — App Store:**
- Apple Developer hesabı ($99/yıl)
- App Store Connect'te uygulama oluştur
- Privacy nutrition labels: "Veri toplanmıyor (cihaz tarafı)"
- Review notları: "Kullanıcı kendi e-Devlet/UYAP hesabıyla giriş yapar, veri kullanıcının cihazında kalır, sunucumuza iletilmez"
- TestFlight ile beta dağıt

**Android — Google Play:**
- Google Play Developer hesabı ($25 tek seferlik)
- Data safety formu: hiçbir veri toplanmıyor
- Internal testing → Closed beta → Production

**Sürüm yönetimi:** `pubspec.yaml` `version: 1.0.0+1` formatında. Semver.

---

## 13. MVP Sonrası (Faz 2+)

- **Sunucu tarafı push** — iOS arka plan kısıtını aşmak için minimum sunucu, sadece push tetikleme
- **Çoklu cihaz sync** — bürodaki avukatların ortak takvimi
- **Sekreterli kullanım** — sekreter avukat hesabına okuma erişimi
- **Mevzuat arama** — UYAP içtihat / mevzuat veritabanı entegrasyonu
- **AI asistan** — duruşma özeti, hazırlık notları
- **Resmi UYAP protokolü** — başvuru sonuçlandığında WebView yerine SOAP/REST entegrasyon

---

## 14. Lisans ve Katkı

İç proje. Lisans modeli ürün stratejisine göre yayın öncesi netleşecek.

---

## 15. İletişim

Repo: https://github.com/oguzhnsglm/law
