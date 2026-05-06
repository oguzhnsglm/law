# Workflow Kuralı

## İlerleme İşaretleme (ZORUNLU)
Bir görev tamamlandığında satır sonuna `**(YAPILDI — YYYY-MM-DD)**` ekle. README ve CLAUDE.md'deki listeler bu kurala tabi.
- İptal: `**(İPTAL — sebep)**`
- Bloklu: `**(BEKLİYOR — sebep)**`

İşaretsiz iş bitmiş sayılmaz; PR/commit yapılsa bile.

## Commit
- Format: `<tip>: <kısa açıklama>` (tip: feat, fix, docs, refactor, test, chore)
- TR veya EN serbest, tutarlı ol.
- Her anlamlı atomik adım = bir commit (ör. "feat: add Drift schema").
- Sonuna her zaman: `Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>`
- `--no-verify` veya hook bypass YASAK.

## Branch
- Ana dal: `main`.
- Yeni özellik: `feat/<konu>` (örn. `feat/uyap-parser`).
- Direkt `main`'e küçük dokümantasyon commit'leri OK.

## Test
- Yeni Dart kodu yazıldığında ilgili `test/` altına unit test ekle.
- Parser değişikliklerinde fixture ekle (`test/fixtures/uyap/`).
- Commit öncesi `flutter analyze` + `flutter test`.

## Dosya Düzeni
README §11'deki klasör yapısına uy. Yeni `lib/features/<x>` eklerken aynı şablon (data/domain/presentation).

## Dokümantasyon
- Her yeni feature için `docs/` altına bir not (gerektiğinde).
- UYAP endpoint keşifleri `docs/uyap_parse_schema.md` içine.

## CLAUDE.md Bakımı (ZORUNLU)
Her iş tamamlandığında [CLAUDE.md](../../CLAUDE.md) §"Şu Anki Durum" tablosu güncellenir. Yeni satır ekle ya da mevcut satırı işaretle. Yarım kalan iş varsa "kısmen — şu eksik" notu düş. Bu güncelleme commit'in parçası olur, ayrı commit yapma.

## .gitignore Bakımı (ZORUNLU)
Yeni araç/paket eklediğinde `.gitignore` da güncellenir:
- Generated dosyalar (`*.g.dart`, `*.freezed.dart` opsiyonel — ekibe göre)
- Build çıktıları, cache klasörleri
- Native build artefaktları (Pods, .gradle, vb.)
- Secret/key dosyaları (`.env`, `*.keystore`, `key.properties`)

Yeni paket eklendikten sonra `git status` çalıştır, beklenmedik dosya varsa `.gitignore`'a ekle.
