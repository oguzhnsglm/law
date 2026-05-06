# tasks.md — Paralel Ajan Görev Listesi

Bu dosya **ikinci AI ajanı** içindir. Ana ajan (Claude Opus 4.7) Flutter scaffold, UYAP entegrasyonu, parser, DB ve WebView gibi **kod tarafını** yürütüyor. İkinci ajan **dokümantasyon, hukuki metinler, tasarım, lokalizasyon ve araştırma** çalışmalarını yapacak.

İlk önce [README.md](README.md) ve [CLAUDE.md](CLAUDE.md) dosyalarını oku — proje bağlamı orada.

---

## Çakışma Kuralı (KRİTİK)

İkinci ajan **YALNIZCA** aşağıdaki dosya/klasörleri oluşturabilir veya değiştirebilir:

```
docs/legal/**
docs/design/**
docs/research/**
docs/marketing/**
assets/i18n/**
LICENSE
```

**ASLA dokunma:**

- `lib/`, `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/` (Flutter scaffold)
- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`
- `test/`, `integration_test/`
- `README.md`, `CLAUDE.md`, `.claude/rules/**`, `.gitignore`
- Kök dizindeki diğer her şey (Ana ajanın bölgesi)

Bu kural ihlal edilirse merge conflict oluşur. Şüphede ol → dokunma.

## Workflow

1. Yeni bir branch aç: `git checkout -b parallel/docs-<görev-adı>`
2. Görevi yap, dosyaları **sadece izinli zonlarda** oluştur.
3. Commit'i [`.claude/rules/workflow.md`](.claude/rules/workflow.md) formatında at.
4. Push: `git push -u origin parallel/docs-<görev-adı>`
5. PR aç (GitHub üzerinden), açıklamada hangi göreve karşılık geldiğini belirt.
6. Ana ajan veya kullanıcı PR'ı incelesin → merge.

Branch'ler kısa ömürlü olsun, görev başına ayrı PR.

## İlerleme İşaretleme

Görev tamamlandığında bu dosyada satıra `**(YAPILDI — YYYY-MM-DD — PR #X)**` etiketi ekle.

---

## Görevler

### G1. Hukuki Metinler Paketi (`docs/legal/`) **(YAPILDI — 2026-05-06)**
**Süre:** 1 gün. **Çıktı:**

- `docs/legal/kvkk_aydinlatma.md` — KVKK Aydınlatma Metni (Türkçe). Veri sorumlusu, işlenen veri kategorileri, işleme amacı, hukuki sebep, saklama süresi, veri sahibi hakları, başvuru yolu. **Bu projede sunucu yok**, bu vurgulanmalı: kullanıcı verisi cihazda kalır.
- `docs/legal/privacy_policy_tr.md` — Gizlilik Politikası (Türkçe), kullanıcıya yönelik dilde
- `docs/legal/privacy_policy_en.md` — İngilizce versiyon (App Store için)
- `docs/legal/terms_of_service_tr.md` — Kullanım Şartları (Türkçe)
- `docs/legal/uyap_edevlet_disclaimer.md` — UYAP/e-Devlet ile ilişkimizin net açıklaması: "Resmi temsilci değiliz, kullanıcı kendi oturumunu kendi cihazında açar, biz sadece görüntü aracıyız"

**Önemli:** Avukat son onayı şart. Bu draft'tır, "İLERİDE BİLİŞİM HUKUKÇUSU TARAFINDAN İNCELENMESİ ZORUNLUDUR" notunu her dosyaya ekle.

**G1 Tamamlanma Notu (2026-05-06):** 5 dosya da yazıldı, "bilişim hukukçusu incelemesi zorunludur" uyarısı her dosyanın başında. **Eksikler (placeholder olarak bırakıldı, kullanıcı dolduracak):** limited şirket unvanı, MERSİS no, adres, KEP, iletişim e-posta, VERBİS sicil no, UYAP Avukat Web Servisleri başvuru numarası, yetkili mahkeme şehri (İstanbul/Ankara), domain adı (`https://[DOMAIN]`). Bu placeholder'lar tüm dosyalarda köşeli parantez içinde işaretli — yayın öncesi tek seferde global bul-değiştir ile doldurulabilir.

### G2. Store Metadata (`docs/marketing/`) **(YAPILDI — 2026-05-06)**
**Süre:** 0.5 gün. **Çıktı:**

- `docs/marketing/app_store_listing.md` — Apple App Store için: app adı (≤30 karakter), subtitle (≤30), promotional text (≤170), description (≤4000), keywords (≤100), TR + EN
- `docs/marketing/play_store_listing.md` — Google Play için: short description (≤80), full description (≤4000), TR + EN
- `docs/marketing/screenshot_brief.md` — 5 zorunlu screenshot için brief (hangi ekran, ne anlatıyor, hangi metin overlay)
- `docs/marketing/icon_brief.md` — Uygulama ikonu için brief (semboller: terazi/duruşma çekici, renk paleti, kaçınılacak şeyler)

**G2 Tamamlanma Notu (2026-05-06):** 4 dosya yazıldı (App Store + Play Store TR/EN listings, screenshot brief 5 ekran için, icon brief). **Eksikler / sonraki adımda kullanıcıdan beklenen:** (1) destek e-postası ve domain — placeholder `[destek@DOMAIN]` / `https://[DOMAIN]/...`; (2) **görsel üretim henüz yok** — bu görev sadece brief'tir, gerçek screenshot ve ikon dosyalarını tasarımcı Figma'da üretecek; (3) App Preview Video opsiyonel ve v1.1'e ertelendi. Brief'ler tasarımcının "production-ready" üretimi için yeterli detayda.

### G3. Design System ve Wireframe'ler (`docs/design/`) **(YAPILDI — 2026-05-06)**
**Süre:** 1 gün. **Çıktı:**

- `docs/design/design_system.md` — Material 3 tabanlı: renk paleti (light + dark), tipografi ölçeği, spacing scale (4/8/12/16/24/32), elevation, border radius standartları
- `docs/design/wireframes.md` — Metin tabanlı wireframe'ler şu ekranlar için:
  - Onboarding (3 sayfa: hoş geldin, KVKK rıza, izinler)
  - Ana ekran (alt sekmeler: Bugün / Takvim / Dosyalar / Ayarlar)
  - Dosya listesi
  - Dosya detay
  - Duruşma detay
  - Senkron ekranı (WebView)
  - Ayarlar
- `docs/design/component_inventory.md` — Tekrar kullanılacak widget envanteri (HearingCard, CaseListTile, SyncStatusBanner, EmptyState, vb.)

**G3 Tamamlanma Notu (2026-05-06):** 3 dosya yazıldı. Design system M3 token'larıyla light + dark renk paleti, Inter tipografi ölçeği, 8'lik spacing, elevation, radius, ikonografi, motion ve erişilebilirlik kurallarını kapsıyor. Wireframes 7 ana ekran + modal pattern + tablet adaptasyonu içeriyor (ASCII tabanlı, Figma'ya çevrilecek). Component inventory 5 katmanlı (atom/molekül/organizm/şablon/yardımcı) ~25 widget tanımı + bağımlılık haritası. **Eksikler:** (1) gerçek Figma yüksek çözünürlüklü mockup'lar tasarımcıya bırakıldı; (2) tablet detay master-detail layout sadece özet düzeyinde — gerçek pikselli mockup yok; (3) `error_catalog.md` G7 görevinde ayrıca yapılacak (wireframe'lerde sadece referans verildi).

### G4. Lokalizasyon Hazırlığı (`assets/i18n/`) **(YAPILDI — 2026-05-06)**
**Süre:** 0.5 gün. **Çıktı:**

- `assets/i18n/tr.arb` — Türkçe string'ler (ARB formatı)
- `assets/i18n/en.arb` — İngilizce
- `assets/i18n/README.md` — Anahtar isimlendirme kuralı, yeni metin ekleme rehberi

İlk versiyonda en az şu alanlar dolu olsun: onboarding, ana navigasyon, sync mesajları, hata mesajları, izin diyalogları, settings, common (Save/Cancel/Delete vb.). ~80-150 anahtar yeterli.

**G4 Tamamlanma Notu (2026-05-06):** 3 dosya yazıldı: `tr.arb` (kaynak), `en.arb` (App Store EN için), `README.md` (translator brief + workflow). ~158 anahtar — hedef aralıkta. ICU MessageFormat (plural, placeholder) örnekleriyle. **Eksikler:** (1) `l10n.yaml` ve `pubspec.yaml` `flutter_localizations` entegrasyonu ana ajan görevidir (Faz 3); (2) error_catalog (G7) sonrasında error_* anahtarları tekrar gözden geçirilip senkronlanacak; (3) gerçek profesyonel çeviri review'ı yayın öncesi yapılmalı (özellikle EN, App Store onayı için).

### G5. Rakip Analizi (`docs/research/`) **(YAPILDI — 2026-05-06)**
**Süre:** 0.5 gün. **Çıktı:**

- `docs/research/competitor_analysis.md` — UyumSoft, Hukuk360, Adli Takip, Kazancı Net, OnlineHukuk.net analizi: özellik matrisi, fiyat, mobil uygulama var mı, eksikleri ne, biz nasıl ayrışıyoruz
- `docs/research/uyap_endpoints_public_knowledge.md` — KAMU bilgisi seviyesinde UYAP Avukat Portal akışı (login → menü → dosyalar → XML export). **Hiçbir bypass/scraping rehberi YAZMA**, sadece kullanıcının manuel akışını dokümante et.

**G5 Tamamlanma Notu (2026-05-06):** 2 dosya yazıldı. Rakip analizi 6 oyuncu için özellik matrisi + müşteri şikayet dinamikleri + konumlandırma mottosu + SWOT içeriyor. UYAP doc kamu bilgisi sınırına sıkı bağlı kaldı — kapsam sınırı en üstte vurgulu, hiçbir bypass/automation rehberi yok, sadece "kullanıcının kendi tarayıcısında ne görüyor" dokümantasyonu. **Eksikler:** (1) Fiyat/özellik bilgileri 2026-05-06 snapshot'ı; pazarlama ekibi yayın öncesi refresh etmeli; (2) müşteri şikayet yüzdeleri tahmini, App Store/Play yorumları manuel sayım yapılmadı.

### G6. Avukat Persona ve User Journey (`docs/research/`)
**Süre:** 0.5 gün. **Çıktı:**

- `docs/research/personas.md` — 3 persona: solo avukat, küçük büro ortağı, stajyer/sekreter (sekreter avukat hesabı kullanan)
- `docs/research/user_journeys.md` — Her persona için tipik bir gün senaryosu, ağrı noktaları, uygulamanın hangi anlarda devreye gireceği

### G7. Hata Mesajı Kataloğu (`docs/design/`)
**Süre:** 0.5 gün. **Çıktı:**

- `docs/design/error_catalog.md` — Kullanıcıya gösterilecek tüm hata türleri için kullanıcı dostu TR + EN metinler:
  - WebView yüklenemedi
  - e-Devlet bağlantı hatası
  - SMS kodu zaman aşımı
  - Senkron başarısız
  - Takvim izni reddedildi
  - Bildirim izni reddedildi
  - DB şifreleme anahtarı bozuk
  - vs. (~20-30 case)
  
  Her hata için: kısa başlık, açıklama, kullanıcının yapabileceği aksiyon.

---

## Yapılacaklar Tablosu

| ID | Görev | Tahmini Süre | Durum |
|---|---|---|---|
| G1 | Hukuki Metinler Paketi | 1 gün | **(YAPILDI — 2026-05-06)** — kuruluş bilgileri placeholder; bilişim hukukçusu onayı bekliyor |
| G2 | Store Metadata | 0.5 gün | **(YAPILDI — 2026-05-06)** — brief tamam; gerçek görseller (screenshot/ikon) tasarımcıya bırakıldı |
| G3 | Design System + Wireframe | 1 gün | **(YAPILDI — 2026-05-06)** — text-only; Figma mockup tasarımcıya |
| G4 | Lokalizasyon ARB | 0.5 gün | **(YAPILDI — 2026-05-06)** — ~158 anahtar; pubspec/l10n.yaml entegrasyonu ana ajana |
| G5 | Rakip Analizi + UYAP akış | 0.5 gün | **(YAPILDI — 2026-05-06)** — fiyat/özellik snapshot 2026-05; refresh önerilir |
| G6 | Persona + User Journey | 0.5 gün | bekliyor |
| G7 | Hata Mesajı Kataloğu | 0.5 gün | bekliyor |

**Toplam: ~4.5 gün.**

Sıra serbest, **bağımlılık yok** — her görev kendi başına başlatılıp bitirilebilir. Tercihen G1 ve G2 ilk bitsin (yayın için kritik); G3-G7 paralel.

## Bittiğinde

Tüm görevler tamamlanınca bu dosyaya `**(TÜMÜ TAMAMLANDI — tarih)**` notu düş, ana ajan PR'ları merge'leyince tasks.md'yi `tasks_archive_phase0.md` olarak yeniden adlandır.
