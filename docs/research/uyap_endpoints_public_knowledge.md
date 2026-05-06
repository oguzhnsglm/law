# UYAP Avukat Portal — Kamu Bilgisi Akışı

> **KAPSAM SINIRI (KRİTİK).** Bu doküman, UYAP Avukat Portal'a giriş yapan
> bir avukatın **kendi tarayıcısında** karşılaştığı tipik akışı, kamuya açık
> bilgilere dayanarak özetler. Hiçbir şekilde:
>
> - Otomatik (bot) login yöntemi,
> - Captcha bypass,
> - Rate-limit aşma tekniği,
> - Sunucu tarafı (headless) scraping rehberi
>
> **YAZILMAZ.** Law uygulaması, kullanıcının kendi parmaklarıyla cihaz içi
> WebView'de manuel olarak login olduğu, bu oturumda zaten görünür hale
> gelmiş veriyi parse eden bir araçtır. Bu doküman geliştiricinin
> "kullanıcının ekranında ne görüyoruz" sorusunu yanıtlamasına yardım eder.

## 1. Kamu Bilgisi Olarak UYAP Avukat Portal

T.C. Adalet Bakanlığı'nın işlettiği UYAP (Ulusal Yargı Ağı Projesi)
sistemi, Türkiye'deki tüm yargı süreçlerinin elektronik altyapısını
oluşturur. Avukatlar kendi dosyalarını **UYAP Avukat Portal** üzerinden
takip eder.

- **Resmi adres:** `https://avukatbeta.uyap.gov.tr` (beta etiketli olsa da
  fiilen tek üretim adresi)
- **Giriş kapısı:** `https://giris.turkiye.gov.tr` (e-Devlet kapısı)
- **Kimlik doğrulama:** T.C. Kimlik No + e-Devlet şifresi (veya mobil imza /
  e-imza alternatifleri)

Bu bilgilerin tamamı T.C. Adalet Bakanlığı, e-Devlet ve UYAP'ın resmi
sitelerinde ve avukat baroları kullanım kılavuzlarında kamuya açık olarak
paylaşılır.

## 2. Tipik Manuel Kullanıcı Akışı (Avukatın Tarayıcısında)

Aşağıdaki akış, herhangi bir avukatın kendi telefonu/bilgisayarındaki
tarayıcıda **bizzat** gerçekleştirdiği ve gerçekleştirebileceği akıştır.
Otomasyon değil, kullanıcı ergonomisi referansıdır:

```
1. Tarayıcı: avukatbeta.uyap.gov.tr
   → e-Devlet kapısına yönlendirir
2. Tarayıcı: giris.turkiye.gov.tr/Giris/gir
   → Avukat T.C. Kimlik No + e-Devlet şifresini girer
   → Gerekirse SMS doğrulama yapılır (kullanıcının kendi telefonuna)
3. Login başarılı → UYAP Avukat Portal ana sayfası
   → Sol menü: "Dosyalarım", "Duruşmalarım", "Süreler", "Mesajlarım"
4. "Dosyalarım" sekmesi:
   → Tablo halinde dosya listesi: Esas no, Mahkeme, Tür, Taraflar,
     Son işlem tarihi
   → Her satıra tıklanır → dosya detay sayfası
5. Dosya detay sayfası:
   → Üstte: Mahkeme bilgisi
   → Sekme: Taraflar / Safahat / Duruşmalar / Evraklar
   → "Duruşmalar" sekmesinde geçmiş ve gelecek duruşma tarihleri liste
6. "Duruşma Takvimi" üst seviye sekmesi (varsa):
   → Tüm dosyaların yaklaşan duruşmaları kronolojik sıralı
7. Avukat bir "XML olarak indir" veya "Yazdır" düğmesine basabilir
   (UYAP'ın kendi sağladığı ihracat — kullanıcının kendi yetkisi
   dahilinde)
```

## 3. Law'ın Bu Akıştaki Rolü

Law, yukarıdaki akışı **avukatın kendi telefonunda yeniden uygulanır**
biçimde, uygulama içi WebView üzerinde gerçekleştirir:

- Adım 1-3: WebView'i avukat **kendi parmağıyla** yönetir.
- Adım 4-6: Login geçerliyken, avukatın oturumunda zaten erişilebilir olan
  içeriği uygulama, JS injection ile aynı oturumdaki `fetch` çağrısı
  yaparak okur (avukatın tarayıcısı üzerinde değil, avukatın
  uygulamasındaki WebView içinde).
- Adım 7: Uygulama, UYAP'ın resmi olarak sağladığı XML/yazdırma çıktısını
  tercih eder; ancak XML çıktısı eksik veya değişmişse sayfa HTML'inden
  parse fallback'i kullanır.

Bu yaklaşımda Law'ın yaptığı iş **avukat kendi tarayıcısında ne yapabilir
ise onun aynısı**'dır; otomasyon avantajı yalnızca "tek tıklamayla yeniden
çekme + diff hesabı + bildirime çevirme" katmanındadır.

## 4. Veri Şeması (Public Knowledge Düzeyinde)

UYAP Avukat Portal'ın kullanıcı arayüzünde bir avukatın gördüğü veri
alanları (ekran görüntüleri kamuya açık birçok blog/baro eğitim
materyalinde paylaşıldığından bu liste kamuya açık bilgi seviyesindedir):

### Dosya (Case)

- Esas numarası (Yıl/Sıra)
- Mahkeme adı (örn. "İstanbul 12. Asliye Hukuk Mahkemesi")
- Mahkeme türü (Asliye Hukuk, Asliye Ceza, İş, Aile, İdare, Vergi, vb.)
- Dosya türü (Hukuk / Ceza / İcra / İdare / Vergi)
- Taraflar (Davacı / Davalı / Sanık / Müşteki / vb.)
- Açılış tarihi
- Son işlem tarihi
- Dosya durumu (Açık / Kapalı / Karar verilmiş)

### Duruşma (Hearing)

- Tarih (gün/ay/yıl)
- Saat
- Salon / oturum yeri
- Duruşma türü (ilk duruşma / esas / karar / vb.)
- Gündem (varsa)

### Safahat (Procedural Steps)

- Tarih
- İşlem türü (tebligat, dilekçe, ara karar, vb.)
- Açıklama

### Mesajlar / Duyurular

- Mahkemeden gelen tebligat bildirimleri

## 5. Format Varyasyonları

UYAP'ın yıllar içinde sayfa yapısı, tablo class isimleri ve XML çıktı
şeması birkaç kez değişmiştir. Ana stabil özellikler:

- **Tarih formatı:** `dd.MM.yyyy` (TR locale). Bazen `dd/MM/yyyy` veya
  saat ile `dd.MM.yyyy HH:mm`.
- **Karakter kodlama:** UTF-8 (modern); eski sayfalarda Windows-1254 (TR)
  görülebilir.
- **HTML yapı:** Tablo bazlı (`<table>`); class isimleri zaman zaman
  değişir → modüler parser zorunlu.
- **XML export (varsa):** Hiyerarşik (`<Dosya><Durusma>...`); şema
  resmi olarak yayınlanmamıştır, alan adları gözleme dayalıdır.

## 6. Reverse Engineering İş Akışı (Geliştirici Notu)

UYAP arayüzü değiştiğinde parser kırılır. Bu durumda yapılacaklar:

1. **Tek bir avukat hesabıyla** (geliştiricinin kendisi veya gönüllü)
   güncel UYAP Avukat Portal'a Chrome DevTools açık şekilde girilir.
2. Network sekmesinde "Dosyalarım", "Duruşmalarım" sayfaları için
   gönderilen istekler ve yanıtlar **kullanıcının kendi tarayıcısında**
   gözlenir.
3. Yeni schema `lib/core/parse/` altında `UyapHtmlParser` veya
   `UyapXmlParser` güncellenir.
4. Test fixture'ları (`test/fixtures/uyap/`) anonimleştirilmiş örneklerle
   güncellenir (taraf isimleri, esas numaraları sahte değerlerle
   değiştirilir).
5. Parser TDD ile yenilenir; eski testler korunur (geriye dönük uyumluluk).

**Bu süreçte hiçbir bypass / ek otomasyon yapılmaz.** Yalnızca
"kullanıcı tarayıcısında ne görüyor"un dokümantasyonu ve parse
katmanının yenilenmesi söz konusudur.

## 7. Resmi Protokol (Hedef)

Adalet Bakanlığı'nın UYAP Avukat Web Servisleri programı, başvurusu kabul
edilmiş yazılımlara doğrudan SOAP/REST API erişimi verir. Bu durumda:

- WebView yerine sertifika tabanlı API çağrısı.
- Parsing yerine resmi şema (XSD) ile deserialization.
- Bot tespit / arayüz değişim riski sıfır.
- KVKK ve hukuki risk minimum.

Law projesi MVP'yi cihaz tarafı WebView ile çıkarır, paralelde resmi
başvuru sürecini takip eder. Başvuru sonuçlandığında bu doküman
arşivlenir ve `uyap_official_api.md` ile değiştirilir.

## 8. Etik ve Hukuki Çerçeve

Law'ın UYAP'a yaklaşımının her zaman uyacağı ilkeler:

1. Login otomasyonu yok — avukat parmaklarıyla giriş yapar.
2. Şifre uygulamaya/sunucuya iletilmez.
3. Kullanıcının kendi yetkisi dışındaki veriye erişim hedeflenmez.
4. UYAP/e-Devlet'in kullanım şartları açık ihlal edilmez (örn. captcha
   bypass yapılmaz).
5. Kullanım pahalı olduğunda (rate limit) hızlandırma değil, **azaltma**
   stratejisi (daha seyrek senkron) tercih edilir.
6. Resmi protokol açılınca WebView yaklaşımı emekli edilir.

Bu prensipler `CLAUDE.md` "kırmızı çizgiler" maddesinde de geçer; bu
doküman ile tutarlıdır.
