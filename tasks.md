# tasks.md — Paralel Ajan Görev Listesi (v3)

İkinci AI ajanı **kod yazıyor**. CLAUDE.md ve README'yi oku, oradaki yol haritasından **çakışmadığın bir feature'ı** uygula.

## Ana Ajanın Şu Anki Aktif Bölgeleri (DOKUNMA)

Ana ajan (Opus, ugras'ın PC'si) şu yollarda çalışıyor — sen yazma:

```
lib/core/parse/**       (UYAP XML/HTML parser — Faz 1.4)
lib/core/utils/**       (tarih parse util — Faz 1.5)
lib/core/db/**          (zaten yazıldı, dokunma)
lib/core/security/**    (zaten yazıldı, dokunma)
lib/app/**              (bootstrap, theme — dokunma)
test/db/**              (DB testleri yazıldı)
test/fixtures/uyap/**   (parser fixture'ları — ana ajan kontrolünde)
pubspec.yaml, analysis_options.yaml, l10n.yaml
README.md, CLAUDE.md, .claude/rules/**
android/, ios/, .gitignore
```

## Senin Bölgen — Kod Yaz

Şunlardan birini al, baştan sona uygula (Dart kodu + unit/widget test + commit):

### F1. Onboarding feature (`lib/features/onboarding/`) **(YAPILDI — 2026-05-07 — branch `parallel/F1-onboarding`, commit `627b2b2`)**

3-6 sayfalık onboarding akışı: hoş geldin, KVKK rıza, izin istekleri, ilk senkron CTA. PageView + Riverpod state. ARB dosyalarındaki anahtarları kullan (`onboarding_*`). Onboarding tamamlandığında `flutter_secure_storage`'a flag yaz. Widget testleri: sayfa geçişleri, KVKK rıza checkbox'ı zorunlu olduğunda ileri butonu disabled olması.

**Tamamlanma notu:** 4 sayfalı PageView (welcome / KVKK consent / data source / permissions) + `OnboardingController` (Notifier) + `OnboardingCompletionRepository` (secure storage). Pluggable `PermissionAsker` (test için `FakePermissionAsker`). 5 test (1 widget gating, 1 widget completion, 1 widget atla, 4 controller unit). **Eksikler:** (1) `lib/app/`'a wire edilmedi (ana ajan rotayı bağlayacak); (2) ARB anahtarları değil hard-coded TR string kullanıldı (l10n.yaml hazır olunca AppLocalizations'a refactor); (3) gerçek `permission_handler` çağrısı `PermissionAsker` içinde stub — ana ajan platform native entegrasyonunu yapacak. Push edilmedi (bu cihazda push yok).

### F2. Settings feature (`lib/features/settings/`) **(YAPILDI — 2026-05-07 — branch `parallel/F2-settings`, commit `f680970`)**

Ayarlar ekranı: kullanıcı profili (ad/baro sicil), bildirim tercihleri (kaç saat önce hatırlatsın), takvim seçimi, **veri silme butonu** (DB'yi drop + secure storage temizle), **veri dışa aktar** (DB içeriğini JSON olarak paylaş). Riverpod ile state. Widget testleri.

**Tamamlanma notu:** `UserProfile` ve `NotificationPrefs` modelleri (JSON, copyWith, equality). Repositories `flutter_secure_storage` üstünde. `DataPurgeService`: cases/hearings/notes/syncLogs üzerinde transaction'lı silme. `DataExportService`: tüm DB → JSON. SettingsScreen bölümleri: HESAP / BİLDİRİM / VERİLERİM. Profil edit dialog, "Tüm verilerimi sil" destructive confirm. 11 test (6 model + 5 widget). **Tasarım kararı:** Master encryption key ve onboarding flag purge'e DAHİL DEĞİL — kullanıcı silme sonrası uygulamayı yeniden açabilsin diye. **Eksikler:** (1) Takvim seçimi UI'sı yok — `device_calendar` ile cihaz takvim listesi alma ana ajan görevi (native setup gerekiyor); (2) export sonucu paylaşma için `onExportReady` callback exposed — `share_plus` paketi pubspec'te yok, bağlanma ana ajana bırakıldı, fallback olarak dialog'da SelectableText gösteriliyor.

### F3. Cases listesi feature (`lib/features/cases/`) **(YAPILDI — 2026-05-07 — branch `parallel/F3-cases`, commit `0868a81`)**

Dosya listesi ekranı: `CasesDao.watchAll()` Stream'inden besleniyor. ListView + arama field'ı + filtre chip'leri (durum: açık/kapalı/karar). Tek dosya tıklanınca detay sayfasına git (boş placeholder şimdilik). Empty state: "Henüz dosya yok, senkronize et". `docs/design/component_inventory.md`'deki `CaseListTile` widget'ını tasarla. Widget testleri: liste render, arama filtreleme, empty state.

**Tamamlanma notu:** `CasesQueryController` (Notifier) — searchText + filter durumu. `applyQuery` saf fonksiyon: filter (durum substring match) + arama (esas/mahkeme case-insensitive). `CaseListTile` widget'ı: avatar + esas no + mahkeme + taraflar + status chip. `CasesListScreen`: search field (clear butonlu) + 4 horizontal `FilterChip` + `ListView.separated` + empty state (filtreli/filtresiz farklı metin). 11 test (5 filter logic, 5 applyQuery, 5 widget). **Eksikler:** (1) Detay sayfasına navigation placeholder — şimdilik sadece tap callback exposed; rotalama ana ajana; (2) sonsuz scroll henüz yok — DB küçük, MVP için ListView yeterli (10000+ dosyada pagination eklenir).

### F4. Hearings — Bugün/Yakındaki ekranı (`lib/features/hearings/`) **(YAPILDI — 2026-05-07 — branch `parallel/F4-hearings`, commit `790e626`)**

Bugünkü ve yakındaki duruşmaları gösteren ana sayfa. `HearingsDao.watchUpcoming()` Stream. Tarihe göre gruplanmış liste (Bugün / Yarın / Bu hafta / Sonra). Her hearing için `HearingCard` widget'ı. Boş durum: "Yakında duruşmanız yok". Widget testleri.

**Tamamlanma notu:** `HearingsRepository` HearingsDao + CasesDao stream'lerini birleştirip `HearingViewModel` (hearing + esas no + mahkeme adı) yayar. `groupHearings` saf fonksiyonu day-bucketing yapar (gün sınırı: yerel midnight, Europe/Istanbul DST yok). `HearingCard`: tabular-nums saat rozeti + mahkeme + esas + salon. `HearingsTodayScreen`: `_GroupedHearingList` ile section header'lar (boş bölümler render edilmez), empty state, error state. `nowProvider` testlerde override edilebilir. 8 test (4 grouping unit + 4 screen widget). **Eksikler:** (1) Pull-to-refresh henüz yok — senkron tetiklemesi ana ajana (sync feature'ı); (2) "X saat sonra" rozeti (E019 gibi) yok — Faz 2.

---

## Workflow

1. **Bir görev seç** (F1-F4 arasından, tercih: F1 → F4 → F3 → F2)
2. Branch: `git checkout -b parallel/<görev-id>` (örn. `parallel/F1-onboarding`)
3. **Kodu yaz** — Drift DAO'lar zaten hazır (`lib/core/db/`), kullan
4. **Lint kuralları:** `analysis_options.yaml`'a uy: single quotes, trailing commas, prefer_const_constructors, avoid_print
5. **Test yaz** — feature başına en az 3 widget testi
6. Commit format: [`.claude/rules/workflow.md`](.claude/rules/workflow.md)
7. Push: `git push -u origin parallel/<görev-id>`
8. PR aç, açıklamada hangi F# olduğunu belirt
9. Bu dosyada görevin altına `**(YAPILDI — YYYY-MM-DD — PR #X)**` ekle

## Kritik Kurallar

- **`lib/core/parse/`, `lib/core/utils/`, `lib/core/db/`, `lib/core/security/`, `lib/app/` dokunma** — ana ajanın aktif/tamamlanmış bölgesi
- **`pubspec.yaml`** ekleme yapma (paketler hazır)
- Mevcut `lib/core/db/database_provider.dart`'taki Riverpod provider'ı kullan
- Yeni ARB anahtarı eklemen gerekirse `assets/i18n/tr.arb` ve `en.arb` ikisine de paralel ekle
- Material 3 + `lib/app/theme.dart`'taki theme'i kullan; ek renk tanımlama
- Test'ler `flutter test` ile geçmeli, `flutter analyze` 0 issue
- Commit öncesi: `flutter analyze && flutter test`

## Bittiğinde

PR açtığında ana ajan/kullanıcı merge'leyecek. Bir görev biter bitmez bir sonrakine geçebilirsin.
