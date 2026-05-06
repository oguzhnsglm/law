# Law — Avukatlar için Mobil Duruşma Takvim Asistanı

Avukatların UYAP üzerindeki dosya ve duruşma bilgilerini mobil cihazlarına otomatik olarak aktaran, hem uygulama içi takvim sunan hem de iOS/Android native takvimleriyle senkronize olan Flutter tabanlı mobil uygulama.

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

## 12. MVP Sonrası (Faz 2+)

- **Sunucu tarafı push** — iOS arka plan kısıtını aşmak için minimum sunucu, sadece push tetikleme
- **Çoklu cihaz sync** — bürodaki avukatların ortak takvimi
- **Sekreterli kullanım** — sekreter avukat hesabına okuma erişimi
- **Mevzuat arama** — UYAP içtihat / mevzuat veritabanı entegrasyonu
- **AI asistan** — duruşma özeti, hazırlık notları
- **Resmi UYAP protokolü** — başvuru sonuçlandığında WebView yerine SOAP/REST entegrasyon

---

## 13. Lisans ve Katkı

İç proje. Lisans modeli ürün stratejisine göre yayın öncesi netleşecek.

---

## 14. İletişim

Repo: https://github.com/oguzhnsglm/law
