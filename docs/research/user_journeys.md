# User Journey'ler — Law

> Her persona için tipik bir gün senaryosu. Uygulama hangi anda devreye
> giriyor, hangi feature'lar tetikleniyor, kullanıcı ne hissediyor.
>
> Bu doküman tasarım ve ürün kararlarında "kullanıcı akışın bu
> noktasında ne bekliyor?" sorusunu yanıtlar. Tasarımcı için Figma
> prototipinin hikaye iskeleti; geliştirici için event takip listesi.

---

## J1 — Mert (Solo Avukat) — Tipik İş Günü

### 07:30 — Uyanış

**Aksiyon:** Yatakta telefonu açar, Law'ı tıklar.
**Beklenti:** Bugünkü duruşmaların kaç tane, ilki saat kaçta.

**Uygulama davranışı:**
- App açılışı: `Bugün` sekmesi varsayılan.
- Üst banner: "Son senkron 7 saat önce". Mert dokunur → arka planda
  yeni senkron başlar.
- Mert WebView'le karşılaşır, e-Devlet şifresini girer (cookie expire
  olduysa). Cookie geçerliyse senkron sessiz tamamlanır.
- 30 saniye sonra: "3 duruşma kontrol edildi. Yeni değişiklik yok."

**Hisset:** Güven. Gün kontrolü altında.

**Tasarım gereği:** Pull-to-refresh varsayılan; üstteki banner sadece
visual cue.

---

### 09:30 — Kahvaltıdan Sonra Ofise Hareket

**Aksiyon:** Galata'daki kafede kahvesini bitirir, taksiye biner.
**Olay:** 09:45'te kilit ekranında bildirim:

> **Law** — "İlk duruşman 11:30, İstanbul 12. Asliye Hukuk · Salon 4"

**Uygulama davranışı:**
- Bu bildirim, dün gece 21:00'de **lokal olarak schedule** edilmişti
  (1 gün önce hatırlatma).
- Bildirime dokunduğunda: Duruşma detay ekranı.
- Mert "Yol tarifi" butonuna basar → Apple Maps açılır, mahkeme
  adresine yön gösterir.

**Hisset:** "Tamam, geç kalmıyorum."

**Tasarım gereği:** Bildirimin tıklanma hedefi duruşma detayıdır
(uygulamanın açılış ekranı değil).

---

### 11:00 — Mahkemenin Önünde, Bekleme

**Aksiyon:** Mahkeme önündeki banka, bekliyor. Telefonunu açar.
**Soru:** "Bu davanın tarafları kimdi, gündem neydi?"

**Uygulama davranışı:**
- `Bugün` → ilk duruşma kartına dokunur.
- Duruşma detay: Esas no, mahkeme, salon, gündem.
- "Esas 2025/1234" linkine dokunur → Dosya detay.
- Tarafları görür: "A.Y. — B.K."
- "Notlarım" sekmesi: kendi yazdığı "Tanık dinletilecek, dilekçe
  Cuma'ya."

**Hisset:** Hazır. Ekstra bilgi yükü yok.

**Tasarım gereği:** Dosya → Duruşma navigasyonu hızlı (tek tap),
notlar her zaman görünür.

---

### 13:00 — Öğle Arası, Ofiste

**Aksiyon:** Yeni bir tebligat geldiğini hatırlatma servisinden öğrenir.
**Soru:** "UYAP'a girip kontrol etmeli miyim?"

**Uygulama davranışı:**
- Mert manuel olarak `Senkronize et` butonuna basar.
- WebView açılır, login zaten geçerli (cookie 1 saat öncesinden).
- Senkron sonucu: "1 yeni duruşma · 0 değişen tarih"
- Bildirim: "Yeni duruşma eklendi: 25 Mayıs 2026, 14:00".

**Hisset:** Aktif kontrol.

**Tasarım gereği:** Manuel senkron her zaman erişilebilir bir tıklama;
sonuç banner kalıcı olmamalı (auto-dismiss 5 sn).

---

### 16:30 — Üçüncü Duruşmaya Yetişme

**Aksiyon:** İkinci duruşması uzadı, üçüncüye yetişmek üzere.
**Olay:** 14:30'da gelen bildirim:

> **Law** — "Duruşma 2 saat sonra: 16:30, Bakırköy 3. Aile Mahkemesi"

**Hisset:** "Tam zamanında."

**Tasarım gereği:** 2 saat önce bildirimi bir kez schedule edilir; iptal
edilmediği sürece kapatılamaz (Mert dosyayı kendisi muafa almadıkça).

---

### 21:30 — Ev, Yatmadan Önce

**Aksiyon:** Yatağa girmeden Law'ı son bir kez kontrol eder.
**Beklenti:** Yarın için ne var?

**Uygulama davranışı:**
- `Bugün` sekmesi: bugün 0 (geçti); altta "Yarın (4)" başlığı.
- 4 duruşma listelenir.
- Mert herhangi birinin saatini tıklar → "Hatırlatma ayarları" görür,
  istediği gibi düzenler.

**Hisset:** Plan ve huzur.

**Tasarım gereği:** Yarınki duruşmalar `Bugün` sekmesinin altında
görünmeli; ayrı `Yarın` sekmesine gerek yok (bilgi yükü artar).

---

## J2 — Ayşegül (Küçük Büro Ortağı) — Yoğun Hafta

### Pazartesi 08:00 — Haftaya Bakış

**Aksiyon:** Ofiste kahvesini alır, telefonu açar.
**Soru:** "Bu hafta ne var?"

**Uygulama davranışı:**
- `Takvim` sekmesi → bu haftanın günlerinde renkli noktalar.
- Hafta görünümü: 11 duruşma görünür.
- Ayşegül kafede de kullandığı için BottomNav'ta `Takvim` ikinci tab.

**Hisset:** Genel resmi gördü.

**Tasarım gereği:** Aylık takvim default, hafta görünümü modu opsiyonel
(toggle).

---

### Salı 11:00 — Ofiste, Çoklu Pencere

**Aksiyon:** UyumSoft (büro ERP) bilgisayarda açık. Telefonda Law açık.
Bir dosya için stajyer "duruşma erkene alınmış" diyor.

**Uygulama davranışı:**
- Ayşegül stajyere "telefonumda bakayım" der.
- Manuel senkron tetikler.
- Sonuç: "1 değişen tarih: Esas 2024/8765 — 23 Mayıs → 16 Mayıs"
- Bildirim arşivinde değişiklik kayıtlı.

**Hisset:** "Stajyer haklıymış. Teyit ettim."

**Tasarım gereği:** Senkron sonucu özet ekranında "değişen tarih"
satırı tıklandığında ilgili duruşmaya gitmeli.

---

### Çarşamba 22:00 — Yolda, Eve Dönerken

**Aksiyon:** Şoförlü taksi. Telefonda yarınki duruşmaları kontrol.

**Uygulama davranışı:**
- `Bugün` → "Yarın (3)" bölümü.
- Bir duruşmanın salonuna çift tıklar → not alanı açılır.
- "Bilirkişi raporu hazır mı sor" notu ekler.
- Kaydeder. Bottom sheet kapanır.

**Hisset:** İş hızlı yapıldı.

**Tasarım gereği:** Not ekleme tek elle erişilebilir bottom sheet
olmalı (şoför arabasında tek elle telefon kullanılıyor).

---

### Cuma 18:00 — Ofiste, Hafta Kapanışı

**Aksiyon:** Sekreter "haftalık raporu mailliyorum" der; Ayşegül kendi
versiyonunu telefonda kontrol eder.

**Uygulama davranışı:**
- `Dosyalar` sekmesi → "Aktif" filtresi.
- En son güncellenen dosyalar üstte.
- Ayşegül liste üzerinde scroll yapar, sekreterin gönderdiği rapora
  paralel teyit yapar.

**Hisset:** Çift teyit, profesyonel rahatlık.

**Tasarım gereği:** Sıralama default "son işlem tarihine göre".

---

## J3 — Kerem (Stajyer) — Standart Akşam

### 21:00 — Hocasının Hesabıyla UYAP Kontrolü (Mevcut Durum)

**Şu an (Law'sız):**
- Bilgisayardan hocasının hesabıyla UYAP'a giriyor.
- Her dosyaya tek tek tıklayıp duruşma değişikliğine bakıyor.
- 30-45 dakika.
- Excel listesini güncelliyor.

### Law İle (İdeal Senaryo)

Bu senaryo MVP'de **doğrudan desteklenmiyor**. Doğru kullanım: hocası
Law'ı kendi telefonuna kursun, kendi şifresiyle login olsun. Sonra:

**Faz 1 (MVP) — Kerem'e direkt değer:**
- Yok. Ürün hocaya yönelik. Kerem kendi telefonunda Law'ı kullanıp
  hocasının şifresini girerse → bu *teknik olarak* çalışır ama tasarım
  hedefi değil.

**Faz 2 (Çoklu Kullanıcı) — Hedef Senaryo:**
- Hoca Law'ı kendi telefonuna kurmuş.
- Hoca, ayarlar → "Stajyerime okuma erişimi ver" → Kerem'in mailine
  davet linki.
- Kerem kendi telefonuna Law'ı kurar; hocaya ait verileri okuma
  yetkisiyle görür.
- Aksiyon: yorum/düzeltme önerisi yapabilir; ama UYAP'ı tetikleyemez
  (sadece hoca yapar).

**Faz 2 user journey'si:**

#### 21:00 — Akşam Kontrol

- Kerem Law'ı açar.
- "Hocamın takvimi" görünümüne geçer.
- Yarınki 4 duruşmayı görür, bir tarih değişikliği var.
- "Hocaya bildir" butonu → Law içi mesaj veya WhatsApp share-link.
- 5 dakikada işin biter.

**Hisset:** Profesyonellik, hız.

---

## Cross-Persona Akışlar

### A. İlk Kullanım (Onboarding)

**Persona ortaklıkları:** Hepsi 18+, e-Devlet kullanıcısı, mobil bildirim
deneyimine aşina.

```
1. App Store'dan indir
2. Splash → "Hoş geldin" sayfası
3. KVKK rıza → checkbox işaretle
4. İzin akışları → takvim + bildirim
5. "İlk Senkronu Başlat"
6. WebView açılır → e-Devlet login
7. Senkron çalışır
8. `Bugün` sekmesine dön
```

**Sürtüşme noktası:** Adım 6'da WebView yüklenmesi yavaş olursa
kullanıcı vazgeçebilir. Loading state'te "Resmi e-Devlet sayfası
yükleniyor..." metni eklenmeli.

### B. Senkron Kırılması (Mutlaka Yaşanacak)

UYAP arayüzü değişti, parser kırıldı. Senaryo:

- Kullanıcı senkron tetikler.
- Backend (parser) hata atar.
- Uygulama: "Senkron yapılamadı. Bizim tarafımızda kayıtlı, hızlıca
  düzelteceğiz. Yeniden dene"
- Kullanıcı 1-2 kez yeniden dener, çalışmıyor.
- App Store'da 1 yıldız bırakır.

**Tasarım gereği:**
- Hata mesajı dürüst (suçu kullanıcıya atma).
- "Hata raporu gönder" butonu (anonim, kullanıcı opt-in).
- Geliştiriciye Sentry/log üzerinden bildirim.
- Hızlı parser fix → yeni release (ideal: 24 saat).

### C. Kullanıcı Verisini Silmek İstiyor (KVKK)

```
1. Ayarlar → Verilerim → "Tüm verilerimi sil"
2. Onay dialog: "Tüm yerel verilerin silinecek..."
3. Kullanıcı onaylar → DB silinir, secure storage temizlenir,
   takvim event'leri (opsiyonel) silinir
4. Uygulama "İlk açılış" durumuna döner (onboarding)
```

**Tasarım gereği:** Kullanıcının takvim event'lerini silmek/saklamak
seçimi: "Telefon takviminize yazdığım duruşma kayıtları da silinsin
mi? [Evet] [Sadece uygulama verilerimi sil]".

---

## Journey Önceliklendirme

| Journey | MVP | Faz 2 | Faz 3+ |
|---|---|---|---|
| J1 (Solo) — sabah/öğle/akşam | ✓ | — | — |
| J2 (Büro ortağı) — hafta | ✓ | — | — |
| J3 (Stajyer) — akşam | (sınırlı) | ✓ paylaşım | — |
| A. Onboarding | ✓ | — | — |
| B. Senkron kırılması | ✓ | iyileştir | — |
| C. Veri silme | ✓ | — | — |

MVP'de tüm akışlar çalışır halde olmalı; Faz 2'de J3 için çoklu
kullanıcı katmanı eklenir.

## Kullanım Sıklığı (Tahmini)

- **Günlük açma:** 3-5 kez (sabah, mahkeme öncesi, akşam)
- **Manuel senkron:** Günde 0-1 (otomatik fonksiyon yeterli olmalı)
- **Not ekleme:** Haftada 2-3 (önemli dosyalar için)
- **Ayarlar dokunma:** Ayda 1-2 (set-and-forget)

Bu sıklığa göre **`Bugün` sekmesi** uygulamanın kalbi; en hızlı
yüklenmeli (cold start <2 sn hedef).
