# tasks.md — Paralel Ajan Görev Listesi (v2)

Bu dosya **ikinci AI ajanı** içindir. Ana ajan (Claude Opus 4.7) Flutter scaffold, UYAP entegrasyonu, parser, DB ve WebView gibi **kod tarafını** yürütüyor. İkinci ajan **dokümantasyon, test fixture'ları, hukuki/UX metinleri ve operasyonel içerik** üretecek.

İlk önce [README.md](README.md) ve [CLAUDE.md](CLAUDE.md) dosyalarını oku — proje bağlamı orada.

> **Versiyon notu (2026-05-06):** v1'deki G1-G7 görevleri tamamlandı (commit `90dd9ce`'e kadar). Bu dosya v2'dir; yeni görev seti G8-G13. Eski tamamlanan görevler `docs/` altında zaten yazılı, dokunma.

---

## İkinci PC Ortam Kısıtı (KRİTİK)

İkinci ajan **Flutter SDK, Android Studio veya Dart araçlarına sahip DEĞİL**. Bu nedenle:

- **YASAK:** `flutter`, `dart`, `pub`, `build_runner` komutu çalıştırmak — komutlar yok zaten
- **YASAK:** `.dart` dosyası yazmak veya değiştirmek — derlenip test edilemez, sessiz hata bırakır
- **YASAK:** Şu uzantıları yazmak: `.dart`, `.lock`, `.gradle`, `.kts`, `.swift`, `.kt`, `.h`, `.m`, `.plist` (manuel düzenleme riskli)
- **İZİN:** `.md`, `.xml`, `.html`, `.svg`, `.png`, `.jpg`, `.json`, `.arb`, `.txt`, `.yml` (sadece veri/içerik)

## Çakışma Kuralı (KRİTİK)

İkinci ajan **YALNIZCA** aşağıdaki dosya/klasörleri oluşturabilir veya değiştirebilir:

```
docs/legal/**            (mevcut — sadece refinement)
docs/design/**           (mevcut — sadece refinement)
docs/research/**         (mevcut + yeni alt klasör: uyap_schema/)
docs/marketing/**        (mevcut)
docs/help/**             (YENİ klasör)
docs/operations/**       (YENİ klasör)
assets/i18n/**           (mevcut — refinement, yeni anahtarlar)
assets/icons/**          (YENİ klasör — SVG/PNG kaynak draft'ları)
test/fixtures/uyap/**    (YENİ klasör — sadece .xml/.html/.json fixture'lar; .dart YASAK)
LICENSE
```

**ASLA dokunma:**

- `lib/`, `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`
- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`, `l10n.yaml`
- `test/**` (sadece `test/fixtures/uyap/**` izinli — başka yerde dosya YOK)
- `integration_test/`
- `README.md`, `CLAUDE.md`, `.claude/rules/**`, `.gitignore`
- Kök dizindeki diğer her şey

Bu kural ihlal edilirse merge conflict oluşur veya derleme bozulur. Şüphede ol → dokunma, sor.

## Workflow

1. Yeni bir branch aç: `git checkout -b parallel/<görev-id>` (örn. `parallel/G8-uyap-schema`)
2. Görevi yap, dosyaları **sadece izinli zonlarda** oluştur.
3. Commit'i [`.claude/rules/workflow.md`](.claude/rules/workflow.md) formatında at.
4. Push: `git push -u origin parallel/<görev-id>`
5. PR aç (GitHub üzerinden), açıklamada hangi göreve karşılık geldiğini belirt.
6. Ana ajan veya kullanıcı PR'ı incelesin → merge.

Branch'ler kısa ömürlü olsun, görev başına ayrı PR.

## İlerleme İşaretleme

Görev tamamlandığında bu dosyada ilgili başlığa `**(YAPILDI — YYYY-MM-DD — PR #X)**` etiketi ekle. Ek olarak her görev altına 3-5 satırlık tamamlanma notu yaz: ne üretildi, neyin eksik bırakıldığı, ana ajan/insan tarafından ne beklenir.

---

## Görevler (G8 — G13)

### G8. UYAP Veri Şeması Detaylı Dokümantasyonu

**Çıktı klasörü:** `docs/research/uyap_schema/`
**Süre:** 1 gün

UYAP Avukat Portal'dan indirilebilen XML export'unun ve dosya/duruşma sayfalarındaki HTML yapısının **kamu bilgisi seviyesinde** (avukatların kamu forumlarında, hukuk yazılım blog'larında, üçüncü parti entegrasyon dokümanlarında paylaştığı) ayrıntılı şema dokümantasyonu.

**Üretilecek dosyalar:**

- `docs/research/uyap_schema/xml_export_schema.md` — XML kök elementi, alt elementler, her field için: ad, tip (string/date/int), zorunlu/opsiyonel, örnek değer, format (özellikle tarih formatları: `dd.MM.yyyy`, `dd.MM.yyyy HH:mm`, vb.)
- `docs/research/uyap_schema/html_pages_structure.md` — Avukat Portal'daki ana sayfaların DOM yapısı: dosya listesi tablosu (hangi `<table>`, hangi `<td>` sırası), dosya detay sayfası, duruşma takvimi sayfası
- `docs/research/uyap_schema/field_glossary.md` — UYAP terminolojisi sözlüğü: "Esas No", "Karar No", "Safahat", "Tebligat", "Müzekkere" vb. — her terim için kısa Türkçe + İngilizce açıklama, hangi alanda bulunur

**Kurallar:**
- Sadece kamu bilgisi. Bypass, scraping, automation script'i içermez.
- Her sayfa/şema için ASCII örneği ver (anonim).
- "Tahmin" olan kısımları açıkça `(tahmin — fixture geldiğinde doğrulanacak)` ile işaretle.
- Eski G5'teki `uyap_endpoints_public_knowledge.md` ile çakışma yok; bu daha derin teknik şema.

**Neden önemli:** Ana ajanın UYAP XML/HTML parser'ı (`lib/core/parse/`) yazarken referans olacak. Şema bilgisi olmadan parser yazılamaz.

---

### G9. Synthetic UYAP Test Fixture'ları

**Çıktı klasörü:** `test/fixtures/uyap/`
**Süre:** 0.5-1 gün

Parser unit testleri için **tamamen kurgu** UYAP XML ve HTML örnek dosyaları. Gerçek dava/avukat verisi YOK.

**Üretilecek dosyalar:**

- `test/fixtures/uyap/xml/case_simple.xml` — 1 dosya, 1 duruşma (en sade durum)
- `test/fixtures/uyap/xml/case_multi_hearings.xml` — 1 dosya, 5 duruşma (sıralama testi)
- `test/fixtures/uyap/xml/multi_cases.xml` — 3 dosya, her biri 1-3 duruşma (toplu export simülasyonu)
- `test/fixtures/uyap/xml/edge_no_hearings.xml` — duruşması olmayan dosya
- `test/fixtures/uyap/xml/edge_special_chars.xml` — Türkçe karakterli isim/mahkeme adı (encoding testi)
- `test/fixtures/uyap/xml/edge_dates_mixed_format.xml` — aynı dosya içinde farklı tarih formatları
- `test/fixtures/uyap/html/dosya_listesi_sample.html` — fake avukat dashboard, 5 dosyalı liste tablosu
- `test/fixtures/uyap/html/dosya_detay_sample.html` — fake dosya detay sayfası, safahat ve duruşma listesi
- `test/fixtures/uyap/html/durusma_takvimi_sample.html` — fake aylık duruşma takvimi sayfası
- `test/fixtures/uyap/README.md` — fixture'ların kullanım rehberi: hangi parser senaryosu için, hangi alanları test eder

**Veri tipi kuralları:**
- Tarafların adı: "Ahmet Yılmaz", "Şirket A.Ş." gibi yaygın isimler — YANLIZCA kurgu, gerçek olamayacak
- Dosya numaraları: `2025/E.{rastgele}` formatında
- Mahkeme isimleri: gerçek mahkeme isim formatı ("İstanbul 1. Asliye Hukuk Mahkemesi") ama dosya/karar bağlantısı yok
- T.C. kimlik numaraları: HİÇ KULLANMA. Yer tutucu olarak `[ANONIM-TC]` yaz
- Tarihler: 2025-2026 aralığında, Avrupa/İstanbul saat dilimi
- HTML'lerde herhangi bir gerçek URL/path bırakma; tüm src/href'leri `#` veya `javascript:void(0)` yap

**Neden önemli:** Ana ajan parser yazıp `flutter test` ile bunlarla doğrulayacak. Fixture olmadan parser TDD ile yazılamaz.

---

### G10. Onboarding & KVKK Rıza UI Copy (Final Metinler)

**Çıktı dosyaları:**
- `docs/design/copy_onboarding.md` (yeni)
- `assets/i18n/tr.arb` ve `assets/i18n/en.arb` — yeni anahtarlar EKLE (mevcut anahtarlara dokunma, sadece append)

**Süre:** 0.5 gün

**Üretilecek içerik:**

`docs/design/copy_onboarding.md`:
- Sayfa 1 (Hoş geldin): başlık + 2-3 satır alt metin (TR + EN)
- Sayfa 2 (Bu uygulama nasıl çalışır): "veriniz cihazınızda kalır" mesajı, 3-4 madde (TR + EN)
- Sayfa 3 (KVKK Aydınlatma): tam KVKK rıza ekranı metni — 6-8 paragraf, kullanıcı dostu (G1'deki resmi metnin sadeleştirilmiş hali, link verecek). TR + EN
- Sayfa 4 (Veri kaynağınız): "UYAP'tan veri çekmek için e-Devlet hesabınızla giriş yapacaksınız" açıklaması (TR + EN)
- Sayfa 5 (İzinler): Takvim ve bildirim izinleri için açıklama (TR + EN)
- Sayfa 6 (Hazırsınız!): bitiş mesajı, ilk senkron CTA (TR + EN)
- Her sayfa için **tek cümle özet** (analytics event adı için)
- "Şimdi değil" / "Daha sonra" gibi ertelendi seçeneği metinleri

`tr.arb` / `en.arb` ekleri:
- ~30-40 yeni anahtar: `onboarding_p1_title`, `onboarding_p1_subtitle`, `onboarding_kvkk_para1` ... vb.
- ICU placeholder kullan ({appName} gibi)

**Kurallar:**
- Hukuki dilden kaç, kullanıcı dostu yaz
- Avukatlara hitap ediyorsun: "siz" formal kullan, jargonu açıkla
- TR ve EN paralel yazılmalı, anahtar isimleri aynı

---

### G11. In-App Help & SSS İçeriği

**Çıktı klasörü:** `docs/help/`
**Süre:** 0.5-1 gün

Uygulama içi "Yardım" bölümünde gösterilecek SSS, sorun giderme rehberi ve sözlük.

**Üretilecek dosyalar:**

- `docs/help/faq.md` — En az 20 SSS sorusu/cevabı:
  - "UYAP şifrem sizde saklanır mı?" (KVKK paniği)
  - "İlk senkron neden uzun sürüyor?"
  - "Duruşma takvimimde görünmeyen dosya var, ne yapmalıyım?"
  - "Senkron başarısız oldu, ne yapayım?"
  - "Mobil İmza ile UYAP girişi destekleniyor mu?"
  - "İki cihazda kullanabilir miyim?"
  - "Verilerimi nasıl silerim?"
  - "Bildirim gelmiyor, ne yapmalıyım?"
  - vb.
- `docs/help/troubleshooting.md` — Adım adım sorun giderme:
  - WebView yüklenmiyor
  - Senkron sürekli kod istiyor
  - Takvime yazmıyor
  - Bildirim gecikiyor
- `docs/help/glossary.md` — Uygulama içi terim sözlüğü: "Senkronizasyon", "Duruşma takvimi", "Cihaz takvimi", "KVKK rıza", "İdempotent merge" gibi 15-20 terim, kullanıcı diliyle açıklama

**Kurallar:**
- Türkçe, açık dil
- Her FAQ cevabı 2-4 cümle, gerekirse linklere yönlendir
- Resmi/teknik dilden kaç ama yanlış bilgi verme

---

### G12. Beta Tester Recruitment + Outreach Şablonları

**Çıktı dosyaları:** `docs/marketing/beta/`
**Süre:** 0.5 gün

Yayın öncesi 5-10 avukatın beta'ya alınması için plan + iletişim şablonları.

**Üretilecek dosyalar:**

- `docs/marketing/beta/recruitment_plan.md` — Hedef profil (yaş, şehir, baro, dosya yoğunluğu), kanal listesi (LinkedIn, baro grupları, Twitter avukat çevresi, üniversite hocaları), aşama akışı (ilan → başvuru formu → mülakat → seçim → onboarding)
- `docs/marketing/beta/outreach_email_tr.md` — TestFlight/Play beta davet maili (TR), 200 kelime
- `docs/marketing/beta/outreach_linkedin_tr.md` — LinkedIn DM şablonu (TR), 80 kelime
- `docs/marketing/beta/feedback_survey.md` — Beta sonu anketi soruları (10-12 soru: NPS, en sevdiğiniz özellik, en kötü deneyim, sorun gördüğünüz alanlar, bug bildirimi)
- `docs/marketing/beta/onboarding_checklist.md` — Beta tester'a ilk gün ne yapması gerektiğini anlatan adım listesi

**Kurallar:**
- Mailler kişisel ton, otomatize görünmesin
- Avukatlara saygılı dil ("Sayın Avukat", "Beyefendi/Hanımefendi")
- KVKK ve gizlilik kısaca vurgulanmalı (ama paniğe yol açmadan)

---

### G13. Müşteri Destek Playbook'u

**Çıktı dosyası:** `docs/operations/support_playbook.md`
**Süre:** 0.5 gün

Yayın sonrası kullanıcı destek talepleri için yanıt şablonları + eskalasyon akışı.

**Üretilecek içerik:**

- Tipik destek senaryoları (15-20):
  - "UYAP'a giriş yapamıyorum" → adım adım yönlendirme
  - "Senkron yapmıyor" → diagnostic akış
  - "Takvime yazmadı" → izin kontrolü, app yeniden başlatma
  - "Şifremi sizinle paylaşmak istemiyorum" → güven inşası, mimari açıklaması
  - "İade istiyorum" → store iade prosedürü
  - vb.
- Her senaryo için: kullanıcı diline çeviri + 3-5 satır profesyonel yanıt + iç eskalasyon notu
- E-posta imza şablonu
- Eskalasyon kuralları: ne zaman geliştirici ekibe iletilir, kritik bug protokolü
- Yanıt SLA hedefleri (örn. 24 saat ilk yanıt, 72 saat çözüm)

**Kurallar:**
- Profesyonel, empatik dil
- Asla "biz suçluyuz" deme; "yaşadığınız sorun için üzgünüz, çözmek için..." formatı
- KVKK soruları için hazır referans cevap (G1 dokümanlarına link ile)

---

## Yapılacaklar Tablosu

| ID | Görev | Tahmini Süre | Klasör | Durum |
|---|---|---|---|---|
| G8 | UYAP Veri Şeması Detay Dokümantasyonu | 1 gün | `docs/research/uyap_schema/` | bekliyor |
| G9 | Synthetic UYAP Test Fixture'ları | 0.5-1 gün | `test/fixtures/uyap/` | bekliyor |
| G10 | Onboarding & KVKK Rıza UI Copy | 0.5 gün | `docs/design/`, `assets/i18n/` | bekliyor |
| G11 | In-App Help & SSS | 0.5-1 gün | `docs/help/` | bekliyor |
| G12 | Beta Recruitment + Outreach | 0.5 gün | `docs/marketing/beta/` | bekliyor |
| G13 | Müşteri Destek Playbook | 0.5 gün | `docs/operations/` | bekliyor |

**Toplam: ~3-4 gün.**

**Sıra önerisi (ana ajan açısından önem sırası):**
1. **G8 (en kritik)** — parser yazımı buna bağlı
2. **G9 (G8 sonrası)** — parser test'leri buna bağlı
3. G10 — onboarding feature başladığında lazım
4. G11, G12, G13 — sonraki haftalarda yetişir

G8 ve G9 birbirine bağlı: G8'i yazarken referans alacağı şema, G9 fixture'ında kullanılacak. Aynı kişi yapsın iyi olur.

## Bittiğinde

Tüm görevler tamamlanınca bu dosyaya `**(TÜMÜ TAMAMLANDI — tarih)**` notu düş, ana ajan PR'ları merge'leyince tasks.md'yi `tasks_archive_phase1.md` olarak yeniden adlandır ve yeni bir tasks.md oluştur (Faz 2 görevleri için).

---

## Geçmiş Versiyonlar

- **v1 (2026-05-06)**: G1-G7 tamamlandı (legal, marketing, design system, i18n, competitor analysis, personas, error catalog). Detay için `git log --grep="docs:" --oneline | head -20`.
