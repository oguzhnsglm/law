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

### F1. Onboarding feature (`lib/features/onboarding/`)

3-6 sayfalık onboarding akışı: hoş geldin, KVKK rıza, izin istekleri, ilk senkron CTA. PageView + Riverpod state. ARB dosyalarındaki anahtarları kullan (`onboarding_*`). Onboarding tamamlandığında `flutter_secure_storage`'a flag yaz. Widget testleri: sayfa geçişleri, KVKK rıza checkbox'ı zorunlu olduğunda ileri butonu disabled olması.

### F2. Settings feature (`lib/features/settings/`)

Ayarlar ekranı: kullanıcı profili (ad/baro sicil), bildirim tercihleri (kaç saat önce hatırlatsın), takvim seçimi, **veri silme butonu** (DB'yi drop + secure storage temizle), **veri dışa aktar** (DB içeriğini JSON olarak paylaş). Riverpod ile state. Widget testleri.

### F3. Cases listesi feature (`lib/features/cases/`)

Dosya listesi ekranı: `CasesDao.watchAll()` Stream'inden besleniyor. ListView + arama field'ı + filtre chip'leri (durum: açık/kapalı/karar). Tek dosya tıklanınca detay sayfasına git (boş placeholder şimdilik). Empty state: "Henüz dosya yok, senkronize et". `docs/design/component_inventory.md`'deki `CaseListTile` widget'ını tasarla. Widget testleri: liste render, arama filtreleme, empty state.

### F4. Hearings — Bugün/Yakındaki ekranı (`lib/features/hearings/`)

Bugünkü ve yakındaki duruşmaları gösteren ana sayfa. `HearingsDao.watchUpcoming()` Stream. Tarihe göre gruplanmış liste (Bugün / Yarın / Bu hafta / Sonra). Her hearing için `HearingCard` widget'ı. Boş durum: "Yakında duruşmanız yok". Widget testleri.

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
