# tasks.md — Paralel Ajan Görev Listesi (v4)

Ana ajan (ugras'ın PC'si) bu turda **token limitini bitirdi**. Bu listedeki tüm görevler **ikinci ajan** tarafından yapılacak. Geri kalanların hepsi sende — kod yaz, test yaz, iyileştir.

İlk önce `README.md`, `CLAUDE.md` ve commit history'yi oku — proje bağlamı orada. Mevcut durum:

- Faz 0 + 1.1 + 1.2 + 1.3 + 1.5 tamam
- F1-F4 (onboarding/settings/cases/hearings) feature kodu yazıldı, 74 test geçiyor
- Riverpod 3.x, Drift, SQLCipher, flutter_inappwebview, device_calendar, flutter_local_notifications paketleri pubspec'te hazır
- `lib/core/db/`, `lib/core/security/`, `lib/core/utils/tr_date_parser.dart` hazır
- `lib/app/app.dart` placeholder home gösteriyor — gerçek shell yok

---

## Çalışma Kuralları

- **Çalışabileceğin alan: tüm `lib/`, `test/`, `assets/i18n/`, `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`, `android/`, `ios/`** — yani aktif geliştirme bölgesi
- **DOKUNMA:** `README.md`, `CLAUDE.md`, `.claude/rules/**`, `.gitignore`, `tasks.md` (sadece progress marker eklemek için EDİT)
- Her görev için ayrı branch: `git checkout -b feat/<id>-<kısa>` (örn. `feat/S1-app-shell`)
- Commit format: [`.claude/rules/workflow.md`](.claude/rules/workflow.md), `Co-Authored-By:` satırı zorunlu
- Commit öncesi `flutter analyze && flutter test` mecburi, ikisi de yeşil olmalı
- Push + PR + bu dosyada satır sonuna `**(YAPILDI — YYYY-MM-DD — commit XXX)**` etiket ekle
- Tasks bağımsız değil, sırayla yapılması daha iyi: **S1 → S2 → S3 → S4 → S5 → ...** Sonraki bağımlı task'ı önceki PR merge olmadan başlatma

---

## Görev Listesi

### S1. App Shell + Routing (`lib/app/`, `lib/features/shell/`)

`go_router` ile rota tanımları, ana shell, alt sekme (BottomNavigationBar) navigasyonu.

- `lib/app/router.dart` — `GoRouter` config: `/onboarding`, `/`, `/cases`, `/hearings`, `/settings`, `/case/:id`, `/hearing/:id`, `/sync` rotaları
- `lib/features/shell/app_shell.dart` — `Scaffold` + `BottomNavigationBar` (Bugün/Dosyalar/Senkron/Ayarlar) + `IndexedStack` body
- `lib/app/app.dart`'ı yeniden yaz: `MaterialApp.router` kullansın, theme korunsun
- Router redirect: onboarding flag false ise `/onboarding`'e yönlendir (F1'deki `OnboardingCompletionRepository` kullan)
- Test: rota redirect'ini doğrulayan widget test

### S2. Lokalizasyon Entegrasyonu (`lib/l10n/`, `assets/i18n/`)

ARB dosyaları zaten hazır (`assets/i18n/tr.arb`, `en.arb`, ~158 anahtar). Generated `AppLocalizations`'ı kullan ve **F1-F4'teki hard-coded TR string'leri** ARB anahtarlarına refactor et.

- `l10n.yaml` oluştur: `arb-dir: assets/i18n`, `template-arb-file: tr.arb`, `output-localization-file: app_localizations.dart`, `output-class: AppLocalizations`
- `pubspec.yaml`'da `flutter: generate: true` zaten var (kontrol et)
- `flutter pub get && flutter gen-l10n` ile generation
- F1, F2, F3, F4'te `'Şifre yanlış'` gibi hard-coded literal'leri `AppLocalizations.of(context)!.errorWrongPassword` gibi çağrılara çevir
- Eksik anahtarı ARB'a ekle (TR + EN paralel)
- Mevcut testleri kıracak — dialog ve ekran testlerini güncelle, gereken yerlerde `MaterialApp(localizationsDelegates: ...)` ekle

### S3. Onboarding Bağlama (`lib/features/onboarding/`)

F1 tamam ama izole. Şimdi gerçek izin sistemine ve ana akışa bağla.

- F1'deki `PermissionAsker` interface'ini `permission_handler` paketiyle gerçekle:
  - `RealPermissionAsker` sınıfı: `Permission.calendarFullAccess` + `Permission.notification` iste, sonuçları toplu döndür
- `OnboardingCompletionRepository` flag'i set olunca router otomatik `/`'a yönlendirsin (S1'deki redirect logic ile birlikte)
- iOS `Info.plist` ve Android `AndroidManifest.xml`'e gerçek izin metinlerini ekle (proje plan §12.3 referans)
- Test: `FakePermissionAsker`'ı koru, gerçek için integration test

### S4. Native Takvim Entegrasyonu (`lib/core/calendar/`)

`device_calendar` wrapper, takvim seçimi UI, hearing → cihaz takvim event'i yazma.

- `CalendarService` (Riverpod provider): `listCalendars()`, `writeOrUpdateHearing(Hearing, String calendarId)`, `removeHearing(Hearing)`
- Native event UID `Hearing.takvimEventId` kolonunda saklı; idempotent: aynı UID varsa update, yoksa create
- Settings ekranında (F2) "Takvim seçimi" bölümünü doldur — kullanıcı hangi cihaz takvimine yazılacağını seçer, secure_storage'a id sakla
- iOS `NSCalendarsFullAccessUsageDescription`, Android `READ_CALENDAR/WRITE_CALENDAR` izinleri
- Test: in-memory mock plugin ile create/update flow

### S5. Lokal Bildirim Altyapısı (`lib/core/notifications/`)

`flutter_local_notifications` + `timezone` ile duruşma hatırlatmaları.

- `NotificationService`: app boot'ta init (`initializeTimeZones()` + `setLocalLocation('Europe/Istanbul')`), kanal kurulumu
- `scheduleForHearing(Hearing h)`: 1 gün önce + 2 saat önce iki bildirim (kullanıcı `NotificationPrefs`'te kapatabilir, F2)
- `cancelForHearing(int hearingId)`: senkron sırasında silinen duruşmalar için
- Android 13+ `POST_NOTIFICATIONS` izin akışı, Android 12+ `SCHEDULE_EXACT_ALARM`
- iOS `DarwinInitializationSettings` + `requestAlertPermissions`
- Test: schedule edilen bildirim sayısını ve zamanlarını assert eden unit test

### S6. Case Detay Ekranı (`lib/features/cases/presentation/case_detail_screen.dart`)

F3'teki tap callback'inin gerçek hedefi.

- Dosya bilgileri (esas no, mahkeme, taraflar, durum, son senkron)
- İlişkili duruşmalar listesi (HearingCard reuse)
- Manuel not ekleme bölümü (`UserNotesDao`)
- "Bu dosyayı sil" değil — UYAP'tan geliyor, kullanıcı silemez (sadece notlarını silebilir)
- Router parametresi `:id` üzerinden DB'den çek
- Widget testleri: render, not ekleme, duruşma alt-listesi

### S7. Hearing Detay Ekranı (`lib/features/hearings/presentation/hearing_detail_screen.dart`)

HearingCard tap → bu ekran.

- Tüm hearing field'ları (tarih, saat, salon, gündem, mahkeme, dosya no)
- Üst kısımda "Takvime ekle" + "Bildirim aç" toggle (S4 + S5'i kullanır)
- İlişkili dosya kısa-özeti + "Dosya detayına git" butonu
- Manuel not bölümü (UserNotesDao, hearingId FK ile)
- Widget testleri

### S8. UYAP Parser İskeleti (`lib/core/parse/`)

UYAP XML ve HTML parse arayüzü. Gerçek fixture (G8/G9) yokken **placeholder fixture** üret kendin: minimal kurgu XML/HTML test'lere koy, hepsini parse et.

- `lib/core/parse/uyap_xml_parser.dart` — `class UyapXmlParser { ParseResult parse(String xml) }`
- `lib/core/parse/uyap_html_parser.dart` — dosya listesi tablosu için
- `lib/core/parse/parse_result.dart` — `class ParseResult { List<Case> cases; List<Hearing> hearings; List<String> warnings; }`
- `lib/core/parse/parties_parser.dart` — XML'deki taraf elementlerini `List<Party>`'e çevir
- TrDateParser kullan
- `test/core/parse/` altında 3-5 fixture XML + parser unit testleri (örnek fixture'ları test/fixtures/ altına yaz)
- G8/G9 fixture'ları ileride geldiğinde sadece daha fazla test eklenecek; iskelet sabit kalacak

### S9. Senkron Servisi (`lib/features/sync/`)

ParseResult → idempotent merge → sync_logs.

- `SyncService`: 
  - `start()` → `SyncLogsDao.start()` ID alır
  - `merge(ParseResult)` → her case için `CasesDao.upsert`, her hearing için `HearingsDao.upsertByCaseAndDate`
  - `complete(success, added, updated, error)` → `SyncLogsDao.complete`
  - Çıktı: `SyncSummary { added, updated, deleted, durationMs }`
- Senkron sonrası: yeni hearing'ler için S5 schedule, S4 calendar yaz
- Test: in-memory DB ile mock ParseResult upsert testleri, idempotent doğrulama (aynı ParseResult iki kez → 0 değişiklik)

### S10. WebView Host Ekranı (`lib/features/sync/presentation/sync_webview_screen.dart`)

`flutter_inappwebview` ile e-Devlet → UYAP login akışı.

- `https://giris.turkiye.gov.tr/Giris/gir` URL'iyle başla, kullanıcı manuel login yapsın
- `onLoadStop` listener: URL `uyap.gov.tr` host'una geçtiğinde JS injection ile XML export endpoint'ini çağır
- Cookie persistence: aynı oturum 30 dk - birkaç saat geçerli, secure_storage'da kalmasın (sadece WebView session storage)
- Sayfa raporlama: hangi adımda (e-Devlet / UYAP yönlendirme / dosya çekme / parse / merge), ProgressIndicator
- Hata durumlarını G7 error catalog'a göre map et (E001-E030)
- "İptal" butonu — yarım kalan senkronu kapatır, sync_logs'a fail kaydı düşer
- Test: hata mapping unit testleri, mock WebView ile state machine widget testleri

### S11. Pull-to-refresh + Senkron Tetikleme

- F3 (CasesListScreen) ve F4 (HearingsTodayScreen)'a `RefreshIndicator` ekle, callback `SyncService.start()` veya WebView ekranını aç
- Settings'e (F2) "Manuel senkronize et" butonu ekle
- Son senkron zamanı, dakika cinsinden (örn. "5 dk önce senkronize edildi") banner — hearings listesinin üstünde
- Test: refresh tetikleme + son senkron metni

### S12. Empty/Error State Standardizasyonu

- `lib/core/ui/empty_state.dart` — `docs/design/component_inventory.md`'deki spec
- `lib/core/ui/error_banner.dart` — G7 error catalog'a göre kullanıcı dostu mesaj
- F2/F3/F4'teki kopyala-yapıştır boş durumları bu ortak widget'larla değiştir
- Test: golden test 2-3 varyant (light/dark)

### S13. CI Workflow (`.github/workflows/`)

- `ci.yml`: PR'larda `flutter analyze` + `flutter test --coverage` + format check
- Coverage threshold: yeni kod için %80 (lcov badge isteğe bağlı)
- Cache pub + gradle
- Maliyet: workflow başına ~3-5 dk

### S14. Hearings — "X saat sonra" Rozeti

F4 tamamlanma notunda `Faz 2`'ye ertelenmişti. Şimdi yap.

- HearingCard'a relative time chip: `today.length > 0 && hearing.tarih.difference(now) < 6 hour` ise "3 sa sonra" gibi gösterim
- TrDateParser ve `intl` ile relative format

### S15. Settings → Veri Dışa Aktarma + Paylaşım

F2'de stub: dialog'da SelectableText. `share_plus` ekleyip dosya olarak paylaşmaya çevir.

- `share_plus: ^10.x`'ı pubspec'e ekle
- `DataExportService.exportToFile()` → JSON yazıp temp file path döner
- "Paylaş" butonu → `Share.shareXFiles([XFile(path)])`
- Test: mocked share çağrısı

---

## Yapılacaklar Tablosu

| ID | Görev | Tahmini | Bağımlılık | Durum |
|---|---|---|---|---|
| S1 | App Shell + Routing | 0.5 gün | — | bekliyor |
| S2 | Lokalizasyon Entegrasyonu | 0.5-1 gün | S1 | bekliyor |
| S3 | Onboarding Bağlama | 0.5 gün | S1 | bekliyor |
| S4 | Native Takvim Entegrasyonu | 1 gün | — | bekliyor |
| S5 | Lokal Bildirim Altyapısı | 0.5-1 gün | — | bekliyor |
| S6 | Case Detay Ekranı | 0.5 gün | S1 | bekliyor |
| S7 | Hearing Detay Ekranı | 0.5 gün | S1, S4, S5 | bekliyor |
| S8 | UYAP Parser İskeleti | 1 gün | — (TrDateParser hazır) | bekliyor |
| S9 | Senkron Servisi | 0.5 gün | S8 | bekliyor |
| S10 | WebView Host Ekranı | 1-1.5 gün | S8, S9 | bekliyor |
| S11 | Pull-to-refresh + Senkron Tetik | 0.25 gün | S10 | bekliyor |
| S12 | Empty/Error State Standardizasyon | 0.5 gün | S2 | bekliyor |
| S13 | CI Workflow | 0.5 gün | — | bekliyor |
| S14 | "X saat sonra" Rozeti | 0.25 gün | — | bekliyor |
| S15 | Veri Paylaşımı (share_plus) | 0.25 gün | — | bekliyor |

**Toplam: ~9-10 gün.** Önerilen sıra: S1 → S3 → S2 → S13 → S4 → S5 → S6 → S7 → S14 → S8 → S9 → S10 → S11 → S12 → S15.

S13 (CI) erken yap — sonraki PR'ları otomatik test eder.

## Bittiğinde

Tüm S görevleri biterse Faz 1 + Faz 2'nin büyük kısmı tamam demektir. Geri kalanlar:
- KVKK aydınlatma metnini onboarding'e bağlama
- App ikonu üretimi (G2 brief'inden)
- App Store / Play Store screenshot üretimi
- Beta dağıtımı (Faz 5)

Bu üst seviye iş paketleri için ana ajan döndüğünde yeni `tasks.md` v5 yazılır.
