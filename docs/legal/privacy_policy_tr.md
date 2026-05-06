# Gizlilik Politikası — Law

> **DRAFT — İLERİDE BİLİŞİM HUKUKÇUSU TARAFINDAN İNCELENMESİ ZORUNLUDUR.**
> Bu metin geliştirme sürecinde teknik ekibin hazırladığı taslaktır. Yayın
> öncesi mutlaka uzman avukat onayı alınmalıdır.

**Yürürlük:** [YYYY-MM-DD] · **Sürüm:** v0.1 (taslak)

---

## Kısa Özet (Önemli Olan Üç Şey)

1. **Şifreniz bizde değil.** UYAP/e-Devlet şifrenizi giriş ekranında
   doğrudan T.C. Cumhurbaşkanlığı'nın `giris.turkiye.gov.tr` sitesine
   girersiniz. Şifre uygulamamıza ya da sunucumuza iletilmez.
2. **Verileriniz cihazınızda kalır.** UYAP'tan çekilen dosya ve duruşma
   bilgileri yalnızca telefonunuzdaki şifreli veritabanında saklanır.
3. **Bizim sunucumuz yok.** Bu uygulama, kişisel veri saklayan herhangi bir
   bulut altyapısı kullanmaz. Veri toplamıyoruz.

---

## 1. Hangi Verileri İşliyoruz

### Cihazınızda Tutulan ve Bize Hiç Gelmeyen Veriler

- Adınız, soyadınız, baro sicil numaranız (isteğe bağlı girersiniz).
- UYAP'tan çekilen dosya numarası, mahkeme adı, taraflar, duruşma
  tarih/saatleri, salon, gündem.
- Kendi yazdığınız duruşma notları.

Bu verilerin tamamı **yalnızca telefonunuzda**, AES-256 şifreli bir
veritabanında durur. Şifreleme anahtarı işletim sistemi güvenli alanında
(iOS Keychain / Android Keystore) saklanır.

### Bize Ulaşabilen Sınırlı Veriler

- **Çökme raporu (opsiyonel):** Onayınız varsa, uygulama beklenmedik şekilde
  kapandığında cihaz modeli, OS sürümü ve anonim hata izi gönderilir. Kişisel
  içerik gönderilmez.
- **Destek e-postaları:** Bize yazdığınızda e-posta adresiniz ve mesajınız
  bize ulaşır.
- **Mağaza analitikleri:** Apple App Store ve Google Play tarafından
  toplanan anonim indirme/çökme istatistikleri. Bu veriler kimliğinizi
  içermez.

---

## 2. Verileri Neden İşliyoruz

- Duruşma takviminizi size göstermek.
- Telefonunuzun takvimine duruşmaları yazmak.
- Yaklaşan duruşmalar için bildirim göndermek.
- Uygulamadaki hataları düzeltmek (çökme raporu).
- Sorularınıza cevap vermek (destek).

---

## 3. Verilerinizi Kimseyle Paylaşmıyoruz

Üçüncü kişilere veri satmıyor, paylaşmıyor, yurtdışına aktarmıyoruz.
Yasal zorunluluk halleri saklıdır (mahkeme kararı vb.).

---

## 4. Saklama Süresi

- Cihazınızdaki veriler: Uygulamayı silene veya "Tüm verilerimi sil" butonunu
  kullanana kadar.
- Destek e-postalarınız: 2 yıl.
- Çökme raporları: 90 gün.

---

## 5. Haklarınız

KVKK m.11 kapsamında veri sahibi haklarınızı kullanabilirsiniz. Detay için:
[KVKK Aydınlatma Metni](kvkk_aydinlatma.md).

Pratik kısayollar uygulama içinde:

- **Verilerimi gör:** Ayarlar → Verilerim
- **Verilerimi sil:** Ayarlar → Verilerim → "Tüm verilerimi sil"
- **Verilerimi dışa aktar:** Ayarlar → Verilerim → "XML olarak indir"

---

## 6. Çocukların Verisi

Uygulama 18 yaş altı kullanıcılara yönelik değildir.

---

## 7. Bize Ulaşın

- E-posta: [İLETİŞİM E-POSTASI]
- KEP: [KEP ADRESİ]
- Adres: [TAM ADRES]

---

## 8. Değişiklikler

Bu politikayı güncellediğimizde uygulama açılışında size bildirim göstereceğiz.
Önemli değişikliklerde yeniden onayınızı isteyeceğiz.

Sürüm geçmişi:
- v0.1 — [YYYY-MM-DD] — İlk taslak.
