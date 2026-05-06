# i18n — Lokalizasyon Dosyaları

Bu klasör Law uygulamasının tüm metinlerini ARB (Application Resource Bundle)
formatında tutar. Flutter `gen-l10n` aracı bu dosyalardan derleme zamanında
type-safe Dart sınıfları üretir.

## Diller

| Dosya | Locale | Durum |
|---|---|---|
| `tr.arb` | Türkçe | **Birincil** — kaynak dil |
| `en.arb` | English | İkincil — App Store EN için |

## Anahtar İsimlendirme Kuralı

Anahtarlar **camelCase** ve **`<scope>_<purpose>`** kalıbıyla yazılır:

```
common_save             // genel butonlar
common_cancel
nav_today               // alt navigasyon sekmesi
onboarding_welcome_title
hearing_caseNo          // duruşma alanı
sync_completedTitle     // senkron akışı
settings_autoSync
error_uyapUnreachable
permission_calendar_explainer
```

**Scope kısa listesi:**
- `common_*` — birden fazla yerde kullanılan jenerik metin (Save, Cancel, Today...)
- `nav_*` — alt navigasyon
- `onboarding_*` — onboarding akışı (alt scope: `welcome`, `consent`, `permissions`)
- `today_*`, `calendar_*`, `cases_*`, `case_*`, `hearing_*`, `note_*`, `sync_*`,
  `settings_*`, `legal_*`, `permission_*` — feature scope
- `error_*` — hata mesajları (bkz. `docs/design/error_catalog.md`)
- `time_*` — relative time helper

**Ayraç:** Scope ile alt scope arasında `_` (kebab değil). Çok seviyeli bir scope
gerekirse `<scope>_<sub>_<purpose>` (örn. `onboarding_consent_acceptKvkk`).

## Placeholder ve Plural

ARB ICU MessageFormat destekler:

```json
"sync_progress": "{done} / {total} dosya",
"@sync_progress": {
  "placeholders": {
    "done": { "type": "int" },
    "total": { "type": "int" }
  }
}
```

Plural:

```json
"sync_newHearings": "{count, plural, =0{Yeni duruşma yok} =1{1 yeni duruşma} other{{count} yeni duruşma}}",
"@sync_newHearings": { "placeholders": { "count": { "type": "int" } } }
```

`@key` meta her placeholder'lı veya plural anahtarda **zorunlu** — yoksa `gen-l10n`
hata verir.

## Yeni Metin Eklerken Workflow

1. Hangi scope'a ait olduğunu belirle.
2. **Önce `tr.arb`'ye ekle** (kaynak dil her zaman TR).
3. `en.arb`'ye İngilizce karşılığını ekle (aynı anahtar).
4. Eğer placeholder/plural varsa `@key` meta da ekle (her iki dosyaya).
5. `flutter gen-l10n` çalıştır → `lib/l10n/` altında `AppLocalizations` güncellenir.
6. Widget'ta kullan: `AppLocalizations.of(context).common_save`.

## Eksik Çeviri Politikası

- `tr.arb` **kaynak**: tüm anahtarlar burada bulunmak zorunda.
- `en.arb` eksikse Flutter fallback olarak TR'yi gösterir, ama bu bir hata.
- CI'de `flutter gen-l10n --untranslated-messages-file=...` ile eksikler
  raporlanır; eksik anahtar varsa build kırılır.

## Bağlam Notu (Translator Brief)

Çeviri yapılırken bilinmesi gereken bağlam:

- **Hedef kullanıcı:** Türkiye'de aktif avukat. Hukuki dilde rahat ama yazılım
  jargonuyla yorma; "Senkron" yerine "güncelle" ya da "veriyi çek" gibi sade
  alternatifler tercih edilir.
- **Ton:** Profesyonel, sen-li (TR'de "sen" — avukatla doğrudan konuşan asistan).
  EN'de neutral 2nd person (sen/siz ayrımı yok).
- **Kısalık:** Buton etiketleri 1-2 kelime; uzun çeviri butonları kırar.
- **Marka adları:** "UYAP", "e-Devlet", "KVKK" sabittir, çevrilmez.
- **Yer tutucular:** `{count}`, `{date}` gibi placeholder'ları çeviride
  KESİNLİKLE silme — anlam değişir, koddaki interpolasyon kırılır.

## Pubspec ve Generation Konfigürasyonu

Lokalizasyon ana ajan tarafından `pubspec.yaml` ve `l10n.yaml` ile
ayarlanır (Faz 3'te). Bu klasör asset olarak değil, source of truth olarak
kullanılır:

```yaml
# l10n.yaml (kök dizin, ana ajan ekleyecek)
arb-dir: assets/i18n
template-arb-file: tr.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n
```

## Anahtar Sayısı

Şu anki sayım (v0.1):

| Scope | Anahtar |
|---|---|
| common | 26 |
| onboarding | 19 |
| nav | 4 |
| today | 5 |
| hearing | 14 |
| calendar | 3 |
| cases | 11 |
| case | 9 |
| note | 4 |
| sync | 17 |
| settings | 24 |
| legal | 4 |
| permission | 4 |
| error | 10 |
| time | 4 |
| **Toplam** | **~158** |

Hedef: MVP yayını için ~150-180 anahtar. Faz 1-3 boyunca artış olacak.
