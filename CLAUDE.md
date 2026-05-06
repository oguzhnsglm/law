# CLAUDE.md — Law Projesi İçin Asistan Talimatları

Bu dosya yeni bir Claude Code oturumu açıldığında otomatik yüklenir. Projeyi ve çalışma kurallarını tanıtır.

## Hızlı Tanıtım

**Proje:** Law — UYAP Avukat Takvim Asistanı (Flutter/Dart, iOS + Android).
**Hedef:** Avukatların UYAP duruşma verilerini cihaz tarafı WebView ile çekip native takvime ve bildirime aktaran mobil uygulama.
**Mimari özet:** Sunucusuz MVP. Kullanıcı kendi e-Devlet şifresiyle uygulama içi WebView'de UYAP'a girer; uygulama oturumdan veriyi parse edip yerel şifreli SQLite'a yazar, takvime ve bildirime schedule eder.

Detaylı plan için [README.md](README.md) (14 bölüm).

## Kural Dosyaları (oku ve uygula)

- [`.claude/rules/project.md`](.claude/rules/project.md) — proje vizyonu, mimari özet, sözlük
- [`.claude/rules/workflow.md`](.claude/rules/workflow.md) — ilerleme işaretleme, commit, branch, test kuralları
- [`.claude/rules/loop.md`](.claude/rules/loop.md) — `/loop` otonom modunda yapılacaklar
- [`.claude/rules/models.md`](.claude/rules/models.md) — alt-ajan görevlerinde model seçim rehberi

## En Kritik Üç Kural

1. **İlerleme işaretleme:** README/CLAUDE'da bir adım tamamlandığında satır sonuna `**(YAPILDI — YYYY-MM-DD)**` etiketi eklenir. Etiketsiz iş "tamamlandı" sayılmaz.
2. **Sunucu veri tutmaz:** Bu projede kullanıcı şifresi/dosya verisi sunucuya **gitmez**. Bu kural mimari kırmızı çizgisidir, ihlal edilirse KVKK riski doğar. Yeni özellik tasarlarken bu kuralı sor.
3. **UYAP login otomasyonu yok:** Login'i her zaman kullanıcı kendi parmaklarıyla WebView'e yapar. Sunucu tarafı/headless login yazma.

## Şu Anki Durum

Faz 0 büyük ölçüde tamam; Flutter SDK kurulumu kullanıcıdan bekleniyor (Faz 1 başlangıcı buna bağlı).

| # | Adım | Durum |
|---|---|---|
| 0.1 | Git repo init + remote | **(YAPILDI — 2026-05-06)** |
| 0.2 | README ve proje planı | **(YAPILDI — 2026-05-06)** |
| 0.3 | CLAUDE.md + kural dosyaları (`project`, `workflow`, `loop`, `models`, `user-setup`) | **(YAPILDI — 2026-05-06)** |
| 0.4 | İlk push to origin | **(BEKLİYOR — kullanıcı `git push` yapacak)** |
| U.1 | Flutter SDK kurulumu | **(BEKLİYOR — kullanıcı tarafı, [user-setup.md](.claude/rules/user-setup.md))** |
| U.2 | Android Studio + JDK 17 | **(BEKLİYOR — kullanıcı tarafı)** |
| U.3 | Git user config + GitHub auth | **(BEKLİYOR — kullanıcı tarafı)** |
| 1.1 | `flutter create` ve klasör iskeleti | bekliyor (U.1'e bağlı) |
| 1.2 | `pubspec.yaml` paket ekleme | bekliyor |
| 1.3 | Drift + SQLCipher şema | bekliyor |
| 1.4 | UYAP XML/HTML parser iskeleti | bekliyor (örnek fixture'a bağlı) |
| 1.5 | Tarih parse util + testleri | bekliyor |
| 2.1 | WebView entegrasyonu (`flutter_inappwebview`) | bekliyor |
| 2.2 | e-Devlet → UYAP login akışı | bekliyor |
| 2.3 | Idempotent merge servisi | bekliyor |

Detay: [README.md §8 yol haritası](README.md).

## Bakım Kuralları (Bu Dosya)

Her iş tamamlandığında bu tablo güncellenir (`(YAPILDI — tarih)` ya da kısmen-not). `.gitignore` da yeni paket/build çıktısı geldikçe güncellenir. İkisi de commit'in parçası, ayrı commit YOK.

## `/loop` Davranışı (Özet)

`/loop` otonom modunda çağrıldığında: README'deki yol haritasından **bir sonraki yapılmamış adımı** bul, uygula, `(YAPILDI)` ile işaretle, commit at, dur (loop kendisi tetikler tekrar). Detay: [`.claude/rules/loop.md`](.claude/rules/loop.md).
