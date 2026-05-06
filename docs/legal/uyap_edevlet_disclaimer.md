# UYAP / e-Devlet İlişkisi — Resmi Açıklama

> **DRAFT — İLERİDE BİLİŞİM HUKUKÇUSU TARAFINDAN İNCELENMESİ ZORUNLUDUR.**

**Yürürlük:** [YYYY-MM-DD] · **Sürüm:** v0.1 (taslak)

---

## Net Olalım

**Law uygulaması, T.C. Adalet Bakanlığı, UYAP (Ulusal Yargı Ağı Projesi),
e-Devlet kapısı veya T.C. Cumhurbaşkanlığı Dijital Dönüşüm Ofisi'nin resmi
ürünü, ortağı, iş birliği yaptığı yazılımı veya iştiraki DEĞİLDİR.**

Law, [LİMİTED ŞİRKET ADI] tarafından bağımsız olarak geliştirilen, ücretsiz
(MVP aşamasında) bir yardımcı yazılımdır.

---

## Uygulama Ne Yapıyor?

Avukat, telefonundaki Law uygulamasını açar. Uygulama içindeki bir
WebView (cihaz içi tarayıcı) penceresinde **resmi e-Devlet sitesine
(`giris.turkiye.gov.tr`) yönlendirilir.** Avukat, kendi e-Devlet
şifresini bu pencerede girer ve UYAP Avukat Portal'a kendi tarayıcısından
giriyormuş gibi giriş yapar.

Login başarılı olduktan sonra Law, yalnızca **avukatın kendi oturumunda
zaten görüntülenen** dosya ve duruşma bilgilerini cihaza aktarır. Bu
işlem, avukatın UYAP'taki sayfaları kendi tarayıcısında manuel açıp
göz gezdirmesinden farksızdır.

---

## Uygulama Ne Yapmıyor?

- **Avukatın şifresini saklamıyor.** Şifre yalnızca avukatın
  parmaklarıyla resmi siteye girilir. Şifre Law'ın sunucularına
  iletilmez (zaten bir sunucumuz yok).
- **UYAP'a sahte/bot trafik göndermiyor.** Login işlemini kullanıcı
  kendisi tıklayarak gerçekleştirir.
- **Avukat olmayan kişiler adına UYAP'a erişmiyor.** Yalnızca login
  yapan avukatın kendi verisi okunur.
- **UYAP altyapısını taklit etmiyor.** Uygulama içindeki WebView, resmi
  siteyi olduğu gibi gösterir; arayüzde değişiklik yapmaz.
- **UYAP'a ait verileri sunucumuzda biriktirmiyor.** Veri yalnızca
  avukatın cihazında, şifreli olarak tutulur.
- **Üçüncü partilere veri satmıyor / paylaşmıyor.**

---

## Resmi Protokole Geçiş Niyeti

Bu mimari MVP içindir. Paralel olarak, T.C. Adalet Bakanlığı'nın UYAP
Avukat Web Servisleri programına resmi başvuru süreci başlatılmıştır
(başvuru numarası: [DOLDURULACAK]). Söz konusu protokol açıldığında,
uygulamada WebView yerine doğrudan resmi web servis entegrasyonu
kullanılacaktır.

---

## Markalar

- "UYAP", T.C. Adalet Bakanlığı'na ait bir tescilli marka/sistem adıdır.
- "e-Devlet", T.C. Cumhurbaşkanlığı Dijital Dönüşüm Ofisi'ne ait bir
  hizmet adıdır.
- "Türkiye.gov.tr", aynı şekilde resmi bir alan adıdır.

Law uygulamasında bu adların kullanılması, yalnızca **referans amaçlıdır**
ve bir sponsorluk, onay veya bağlantı imali içermez.

---

## Avukatın Sorumluluğu

Avukat, uygulamayı kullanarak:

- UYAP Avukat Portal kullanım şartlarına uymayı,
- e-Devlet kullanım şartlarına uymayı,
- Kendi şifresinin güvenliğinden sorumlu olmayı,
- Uygulamanın gösterdiği bilgilerin **yardımcı bilgi** olduğunu, asli
  bilginin UYAP olduğunu kabul eder.

---

## İletişim

Bu açıklamada ele alınan konularla ilgili sorularınız için:

- E-posta: [İLETİŞİM E-POSTASI]
- KEP: [KEP ADRESİ]

Resmi UYAP/e-Devlet konularında doğrudan ilgili kurumlara başvurulmalıdır.

---

Sürüm geçmişi:
- v0.1 — [YYYY-MM-DD] — İlk taslak.
