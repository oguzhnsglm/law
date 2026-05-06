# Hata Mesajı Kataloğu — Law

> Kullanıcıya gösterilebilecek tüm hata türleri, TR + EN mesaj ve aksiyon
> seti. Geliştirici bu listeden ID seçer; UI metni asla "kod içine"
> yazılmaz, ARB üzerinden çekilir.

## Mesaj Kuralları

1. **Suçu kullanıcıya atma.** "Yanlış girdiniz" değil "İşlem tamamlanamadı".
2. **Net aksiyon ver.** "Bir hata oldu" değil "İnternet bağlantını kontrol et".
3. **Kısa.** Başlık 6 kelime üstü olmasın; gövde 2 cümleyi geçmesin.
4. **Tek aksiyon, varsa ikincil.** Birincil buton eylem; ikincil "Daha sonra"/"Kapat".
5. **Teknik ID gizleme.** Stack trace, error code yalnızca opt-in raporda.
6. **Üslup:** Sen-li (TR), neutral 2nd person (EN). Ünlem yok.

## Görüntüleme Kanalları

| Kanal | Kullanım |
|---|---|
| `Snackbar` | Geçici, otomatik kaybolur (3-5 sn). Tek satır. |
| `Dialog` | Kullanıcı kararı zorunlu. Birincil + ikincil buton. |
| `BottomSheet` | Çok satırlı açıklama + birden fazla aksiyon. |
| `EmptyState` | Liste boş + sebep + aksiyon. |
| `InlineBanner` | Form/sayfa içi sürekli görünür uyarı. |

---

## Katalog

### E001 — Genel / Bilinmeyen Hata
- **Kanal:** Snackbar
- **TR başlık:** "Bir şey ters gitti"
- **TR gövde:** "İşlem tamamlanamadı. Lütfen tekrar dene."
- **EN başlık:** "Something went wrong"
- **EN gövde:** "The operation could not be completed. Please try again."
- **Aksiyon:** "Tekrar Dene" / "Kapat"
- **ARB anahtarı:** `error_genericTitle`, `error_genericBody`

### E002 — İnternet Yok
- **Kanal:** Banner (sayfa üstü) + retry tetikleyicide Snackbar
- **TR:** "İnternet bağlantın yok gibi görünüyor."
- **EN:** "You appear to be offline."
- **Aksiyon:** "Tekrar Dene"
- **ARB:** `error_noInternet`
- **Geliştirici notu:** Ağ tipini kontrol et (`connectivity_plus`); WiFi/cell ikonuyla sembolik göstergesi olabilir.

### E003 — UYAP'a Ulaşılamadı
- **Kanal:** Dialog
- **TR başlık:** "UYAP'a ulaşılamadı"
- **TR gövde:** "Sunucu cevap vermiyor. İnternet bağlantını kontrol et veya birkaç dakika sonra tekrar dene."
- **EN başlık:** "Could not reach UYAP"
- **EN gövde:** "Server is not responding. Check your internet or try again in a few minutes."
- **Aksiyon:** "Tekrar Dene" / "Daha Sonra"
- **ARB:** `error_uyapUnreachable`

### E004 — UYAP Bakım / 503
- **Kanal:** Dialog
- **TR:** "UYAP geçici olarak hizmet dışı. Genelde kısa sürer; sonra tekrar dene."
- **EN:** "UYAP is temporarily down. It's usually brief — try again soon."
- **Aksiyon:** "Anladım"

### E005 — e-Devlet Login Tamamlanamadı
- **Kanal:** Dialog
- **TR başlık:** "Giriş tamamlanamadı"
- **TR gövde:** "e-Devlet'e giriş bitmedi. Sayfayı yeniden açıp dene."
- **EN başlık:** "Sign-in didn't complete"
- **EN gövde:** "The e-Devlet sign-in didn't finish. Reopen the page and try again."
- **Aksiyon:** "Tekrar Aç" / "İptal"
- **ARB:** `error_loginFailed`

### E006 — SMS Kodu Zaman Aşımı
- **Kanal:** Snackbar
- **TR:** "SMS kodu zaman aşımına uğradı. Tekrar dene."
- **EN:** "SMS code timed out. Try again."
- **Aksiyon:** "Tekrar Gönder"
- **ARB:** `error_smsTimeout`

### E007 — Yanlış Şifre / Hesap Kilitli
- **Kanal:** Dialog
- **TR:** "e-Devlet yanlış şifre veya kilitli hesap dedi. Sorun e-Devlet tarafında çözülmeli."
- **EN:** "e-Devlet reported wrong password or a locked account. Resolve on the e-Devlet side."
- **Aksiyon:** "e-Devlet'e Git" → `https://www.turkiye.gov.tr/sifre-yardim` / "Kapat"
- **Not:** Bu hatayı biz çözemeyiz; kullanıcıyı resmi destek kanalına yönlendir.

### E008 — UYAP Yanıtı Okunamadı (Parse Hatası)
- **Kanal:** Dialog
- **TR başlık:** "UYAP yanıtı okunamadı"
- **TR gövde:** "Bu hata bizim tarafımızda kayıtlı, hızlıca düzelteceğiz. Yeniden denemek istersen…"
- **EN başlık:** "Couldn't read UYAP response"
- **EN gövde:** "This is logged on our side and we'll fix it soon. Want to retry?"
- **Aksiyon:** "Tekrar Dene" / "Daha Sonra"
- **ARB:** `error_parseFailed`
- **Geliştirici notu:** Anonim error log + UYAP yanıt sample'ı (kullanıcı opt-in) gönderilir; KVKK kapsamında kişisel veri redaksiyonu uygulanır.

### E009 — Kısmi Senkron (Bazı Dosyalar Çekildi)
- **Kanal:** Banner (senkron sonuç ekranı içi)
- **TR:** "32 dosyadan 28'i çekildi. 4 dosya UYAP'tan okunamadı, sonra tekrar denenecek."
- **EN:** "Synced 28 of 32 cases. 4 couldn't be read; we'll retry later."
- **Aksiyon:** "Tamam" (otomatik retry sonraki senkronda)

### E010 — Senkron İptal Edildi
- **Kanal:** Snackbar
- **TR:** "Senkron iptal edildi."
- **EN:** "Sync canceled."
- **Aksiyon:** Yok

### E011 — Senkron Zaman Aşımı (Çok Uzun Sürdü)
- **Kanal:** Dialog
- **TR:** "Senkron 2 dakikayı geçti. Bağlantı yavaş olabilir; tekrar dener misin?"
- **EN:** "Sync took over 2 minutes. Connection may be slow; want to retry?"
- **Aksiyon:** "Tekrar Dene" / "Daha Sonra"

### E012 — Takvim İzni Reddedildi
- **Kanal:** Dialog (ilk sefer) → Banner (sonraki seferler)
- **TR başlık:** "Takvim izni gerekli"
- **TR gövde:** "Duruşmaları telefon takvimine yazmak için izin gerekli. Telefon ayarlarından açabilirsin."
- **EN başlık:** "Calendar permission needed"
- **EN gövde:** "Permission is required to write hearings to your phone calendar. Open phone settings to enable."
- **Aksiyon:** "Ayarları Aç" / "Şimdi Değil"
- **ARB:** `error_calendarWriteFailed`, `permission_calendar_explainer`

### E013 — Bildirim İzni Reddedildi
- **Kanal:** Dialog (ilk sefer) → Banner
- **TR:** "Bildirim izni olmadan duruşma hatırlatmaları gelmez. Ayarlardan açabilirsin."
- **EN:** "Without notifications you won't get hearing reminders. You can enable in settings."
- **Aksiyon:** "Ayarları Aç" / "Şimdi Değil"
- **ARB:** `error_notificationScheduleFailed`, `permission_notification_explainer`

### E014 — Tam Zamanlı Alarm İzni (Android 12+)
- **Kanal:** Dialog
- **TR:** "Tam zamanında bildirim için Android 12+ özel bir izin istiyor. Açmamak hatırlatmayı 5-15 dk gecikmeli yapabilir."
- **EN:** "On Android 12+, exact alarms need a special permission. Skipping it may delay reminders by 5-15 min."
- **Aksiyon:** "İzin İste" / "Tamam, Yaklaşık Olsun"

### E015 — Yerel DB Şifreleme Anahtarı Bulunamadı
- **Kanal:** Dialog (engelleyici)
- **TR başlık:** "Verine ulaşılamadı"
- **TR gövde:** "Telefon güvenli alanında şifreleme anahtarı bulunamadı. Telefon kilidi/biyometriyi sıfırladıysan bu olabilir. Verilerini sıfırlayıp baştan başlamak gerekiyor."
- **EN başlık:** "Couldn't access your data"
- **EN gövde:** "Encryption key not found in secure storage. This can happen if you reset your lock/biometrics. You'll need to reset and start over."
- **Aksiyon:** "Sıfırla ve Yeniden Başla" / "Çıkış"
- **ARB:** `error_dbCorrupted`
- **Geliştirici notu:** Bu durum nadirdir; Keychain/Keystore item'ı OS reset'te silinmiş olabilir. Loglama yapılır, kullanıcı kabul edince DB silinir.

### E016 — Yerel DB Bozuldu / Açılmadı
- **Kanal:** Dialog (engelleyici)
- **TR:** "Yerel veritabanı okunamadı. Verilerini sıfırlamak gerekebilir. Yeniden senkron yapınca UYAP'tan tekrar yüklenir."
- **EN:** "Local database is unreadable. You may need to reset your data; it will be re-fetched from UYAP."
- **Aksiyon:** "Sıfırla" / "Çıkış"

### E017 — Disk Dolu (Cihaz Storage)
- **Kanal:** Dialog
- **TR:** "Telefonunda yer kalmadı. Senkron yapamadık. Biraz yer açıp tekrar dene."
- **EN:** "Your phone is out of storage. Sync paused. Free some space and try again."
- **Aksiyon:** "Anladım"

### E018 — Saat Dilimi Yanlış (Bildirim Yanlış Çıkıyor)
- **Kanal:** Banner
- **TR:** "Telefonunun saat dilimi 'Otomatik' değil. Bu yüzden hatırlatmalar yanlış zamanda gelebilir."
- **EN:** "Your phone's time zone isn't automatic. Reminders may fire at the wrong time."
- **Aksiyon:** "Ayarları Aç"

### E019 — Çakışan Duruşma Tarihleri (Aynı Saat, İki Mahkeme)
- **Kanal:** Banner (duruşma detay sayfasında)
- **TR:** "Aynı saatte başka bir duruşman daha var: [Mahkeme adı]."
- **EN:** "You have another hearing at the same time: [Court name]."
- **Aksiyon:** "Diğerini Gör"

### E020 — XML Export Reddedildi
- **Kanal:** Dialog
- **TR:** "XML çıktısı yapılamadı. Cihaz tarafında dosya yazma izni eksik olabilir."
- **EN:** "Couldn't write XML export. The app may lack file write access."
- **Aksiyon:** "Tekrar Dene" / "Kapat"

### E021 — XML Import Format Hatası
- **Kanal:** Dialog
- **TR:** "Bu dosya UYAP XML formatında görünmüyor."
- **EN:** "This file doesn't look like a UYAP XML."
- **Aksiyon:** "Başka Dosya Seç" / "Kapat"

### E022 — Veri Silme Onay (yanlışlık önleme)
- **Kanal:** Dialog (destructive)
- **TR:** "Tüm yerel verilerin silinecek. Bu işlem geri alınamaz. Devam edilsin mi?"
- **EN:** "All local data will be deleted. This cannot be undone. Continue?"
- **Aksiyon:** "Evet, Sil (kırmızı)" / "İptal"
- **ARB:** `settings_deleteAll_confirm`
- **Not:** Hata değil ama destructive uyarı ailesinden; tutarlılık için burada listelendi.

### E023 — Cihaz Yetkisi Eksik (Apple/Google KVKK)
- **Kanal:** Dialog
- **TR:** "Bu özellik için cihaz takvim erişimi gerekli. App Store gizlilik politikası gereği yeniden onay vermen gerekiyor."
- **EN:** "This feature needs calendar access. App Store privacy rules require renewed permission."
- **Aksiyon:** "İzin Ver"

### E024 — Eski Uygulama Sürümü (UYAP Şeması Değişti)
- **Kanal:** Dialog (engelleyici)
- **TR başlık:** "Güncelleme gerekli"
- **TR gövde:** "UYAP'ta yapılan bir değişiklik bu sürümle çalışmıyor. Mağazadan güncelleyince çalışacak."
- **EN başlık:** "Update required"
- **EN gövde:** "A change in UYAP requires the latest app version. Update from the store to continue."
- **Aksiyon:** "Mağazaya Git" / "Çıkış"

### E025 — Beta / Erken Erişim Uyarısı
- **Kanal:** Banner (ilk açılışta bir kez)
- **TR:** "Bu sürüm erken erişim. Hatalar olabilir; geri bildirimin değerli."
- **EN:** "This is an early-access build. Bugs may occur; feedback is welcome."
- **Aksiyon:** "Anladım"

### E026 — Çift Hesap (Aynı Sicil Farklı Cihaz)
- **Kanal:** InlineBanner (ayarlarda)
- **TR:** "Bu sicil başka bir cihazdan giriş yapıyor görünüyor. Sorun yok; her cihaz kendi yerel verisini tutar."
- **EN:** "This bar number appears to sign in from another device. That's fine — each device keeps its own local data."

### E027 — UYAP Captcha / Bot Şüphesi
- **Kanal:** Dialog
- **TR başlık:** "Doğrulama gerekti"
- **TR gövde:** "UYAP bir doğrulama (captcha) istedi. Açılan sayfada doğrulamayı kendin tamamla."
- **EN başlık:** "Verification needed"
- **EN gövde:** "UYAP requested a verification (captcha). Complete it yourself on the page that opened."
- **Aksiyon:** "WebView'i Aç"
- **Not:** Captcha bypass YOK; kullanıcıya gösterip kendisi çözüyor.

### E028 — Bildirim Kuyruğu Dolu (>= 64 schedule)
- **Kanal:** Banner
- **TR:** "Çok fazla yaklaşan duruşman var, bazı hatırlatmalar atlanabilir. Yine de en yakın 64 duruşma kapsanır."
- **EN:** "Lots of upcoming hearings — some reminders may be skipped. The nearest 64 are covered."

### E029 — KVKK Rıza İptal (Sonra)
- **Kanal:** Dialog
- **TR:** "Rıza iptal edersen verilerin silinir ve uygulamayı kullanamazsın. Devam edilsin mi?"
- **EN:** "Revoking consent will delete your data and you'll be unable to use the app. Continue?"
- **Aksiyon:** "Evet, İptal Et" (kırmızı) / "Geri"

### E030 — Destek Maili Açılamadı
- **Kanal:** Snackbar
- **TR:** "Mail uygulaması bulunamadı. Adresimiz: destek@DOMAIN"
- **EN:** "No mail app found. Our address: support@DOMAIN"
- **Aksiyon:** "Adresi Kopyala"

---

## ARB Senkronu

`assets/i18n/tr.arb` ve `en.arb` zaten en kritik (E001, E002, E003, E005,
E006, E008, E012, E013, E015, E016) için anahtarları içerir. Diğer 20
hata için anahtarlar G7 sonrası i18n dosyalarına eklenecek (G4 notuna göre
ana ajan/i18n revizyonunda).

**Anahtar konvansiyonu:** `error_<id>_title`, `error_<id>_body`,
`error_<id>_actionPrimary`, `error_<id>_actionSecondary`. Mevcut bazı
anahtarlar (örn. `error_uyapUnreachable`) "id" yerine semantic isim
kullanıyor; **yeni hatalarda E0XX numara konvansiyonuna geçilecek** (Faz 1
sonunda mevcut anahtarlar normalize edilir).

## Loglama Politikası

- **Snackbar düzeyi (info/warn):** Loglanmaz (kullanıcı normal akış).
- **Dialog düzeyi (error):** Anonim log: error ID, timestamp, OS sürümü,
  app sürümü. Kullanıcı opt-in ise stack trace eklenir.
- **Engelleyici hatalar (E015, E016, E024):** Otomatik gönderim YOK;
  kullanıcı "Hata raporu gönder" butonuna basınca gönderilir.
- **KVKK:** Hiçbir log kişisel veri (taraf adı, esas no, mahkeme adı)
  içermez; redaksiyon zorunlu.

## Test Stratejisi

- Her hata ID'si için widget testi (`test/error_states/`).
- Golden file: dialog/banner görsel snapshot.
- Manual: gerçek cihaz, gerçek senaryo (offline, izin reddi, vs.).

## Erişilebilirlik

- Renk yalnızca anlam taşıyıcı OLAMAZ — hata simgesi (⚠) + metin.
- Screen reader: dialog başlığı `Semantics(header: true)`.
- Kırmızı butonlarda (destructive) ekstra `Semantics(label: 'tehlikeli aksiyon')`.

---

## Yapılacaklar Listesi (G7 Sonrası)

- [ ] Yeni hata anahtarlarını ARB dosyalarına ekle (E007, E009-E011, E014,
  E017-E030).
- [ ] Mevcut semantic isimli ARB anahtarlarını E0XX konvansiyonuna geçir
  (eski isimler alias olarak kalır 1 sürüm).
- [ ] Sentry / log backend'i yapılandır (kullanıcı opt-in).
- [ ] Her hata için golden test (faz 4 içinde).
