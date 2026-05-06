# Screenshot Brief — Mağaza Ekran Görüntüleri

> Bu doküman, App Store ve Google Play için zorunlu 5 ekran görüntüsünün
> içerik, kompozisyon ve metin overlay'lerini tanımlar. Tasarımcı bu brief
> üzerinden Figma'da production-ready görselleri üretecektir.

## Genel Kurallar

- **Cihaz çerçevesi:** iPhone 15 Pro (6.7"), Samsung Galaxy S24 (6.2")
  mockup'ları. App Store ayrıca iPad ekranları ister; aynı içerikten 12.9"
  iPad uyarlaması yapılır.
- **Çözünürlük:**
  - iPhone 6.7": 1290×2796 px (portrait)
  - iPhone 6.5" (eski cihaz desteği): 1242×2688 px
  - iPad 12.9": 2048×2732 px
  - Android: 1080×1920 px minimum, 1440×2960 önerilir
- **Renk paleti:** Light tema; lacivert (#1D3557) + altın aksent (#F4A261)
  + gri (#264653 sekonder). Bkz. `docs/design/design_system.md`.
- **Tipografi:** Inter veya SF Pro Text. Headline 56-64pt, body 28-32pt.
- **Dil:** TR mağaza için Türkçe overlay, EN mağaza için İngilizce.
- **Yasal:** UYAP veya e-Devlet logosu KULLANILMAZ. Mahkeme/dava isimleri
  TAMAMEN KURMACA olmalı (gerçek dosya numarası, taraf adı yok).

---

## Screenshot 1 — Ana Vaat (Bugünkü Duruşmalar)

**Ekran:** Ana ekran — "Bugün" sekmesi. 2-3 duruşma kartı görünüyor.
**Üst overlay (büyük metin):**
> "Bir duruşmayı bir daha unutma."

**Alt overlay (küçük):**
> UYAP'tan otomatik takvim · Akıllı hatırlatma

**Cihaz içeriği:**
- Bugün, 5 Mayıs 2026
- 09:30 — İstanbul 12. Asliye Hukuk · Salon 4 · Esas 2025/[XXXX]
- 14:00 — Ankara 8. İş Mahkemesi · Salon 2 · Esas 2024/[YYYY]
- 16:30 — Bakırköy 3. Aile Mahkemesi · Salon 1 · Esas 2026/[ZZZZ]

**Vurgu:** İlk duruşma kartında "2 saat sonra" rozeti.

---

## Screenshot 2 — Senkron (Veri Mahremiyeti)

**Ekran:** Senkron başarılı sonrası özet ekranı.
**Üst overlay:**
> "Şifren bizde değil. Hiç gelmedi."

**Alt overlay:**
> Doğrudan e-Devlet'e girersin. Veri telefonunda kalır.

**Cihaz içeriği:**
- Yeşil onay simgesi
- "Senkron tamamlandı" başlığı
- "32 dosya kontrol edildi"
- "3 yeni duruşma eklendi"
- "1 değişen tarih güncellendi"
- Alt rozet: "🔒 Veri yalnızca cihazında"

---

## Screenshot 3 — Takvim Görünümü

**Ekran:** Aylık takvim — Mayıs 2026, duruşma günleri renkli noktalarla.
Bir gün seçili, alt yarıda o günün duruşmaları liste halinde.
**Üst overlay:**
> "Tüm duruşmaların tek ekranda."

**Alt overlay:**
> Aylık ve haftalık görünüm · Telefon takviminle senkron

**Cihaz içeriği:**
- Mayıs 2026 başlığı
- 6 farklı günde renkli noktalar (duruşma var)
- Seçili gün: 12 Mayıs Salı
- O günün altında 2 duruşma kartı

---

## Screenshot 4 — Bildirim

**Ekran:** Telefonun kilit ekranı, üstte uygulama bildirimi.
**Üst overlay:**
> "Yarın duruşman var, hatırlatıyoruz."

**Alt overlay:**
> 1 gün önce ve 2 saat önce iki bildirim. Her zaman.

**Cihaz içeriği:**
- Kilit ekranı saat 19:00, 4 Mayıs 2026
- Bildirim:
  - Uygulama: Law
  - Başlık: "Yarın 09:30'da duruşman var"
  - Açıklama: "İstanbul 12. Asliye Hukuk · Salon 4"

---

## Screenshot 5 — Dosya Detay

**Ekran:** Bir dosyanın detay sayfası — taraflar, geçmiş duruşmalar,
kullanıcı notları.
**Üst overlay:**
> "Notlarını kaybetme. Senkron silmez."

**Alt overlay:**
> Manuel notların korunur. UYAP'tan gelen veri ayrı.

**Cihaz içeriği:**
- Esas no: 2025/[XXXX]
- Mahkeme: İstanbul 12. Asliye Hukuk
- Taraflar (kurmaca): "A.Y. — B.K."
- Geçmiş duruşmalar: 3 satır
- Notlarım: "Tanık dinletilecek, dilekçe Cuma'ya."

---

## App Preview Video (Opsiyonel)

15-30 saniyelik bir önizleme video, App Store'da listelemenin tıklama
oranını %20-25 artırır. MVP yayını için zorunlu değil; v1.1 ile yapılabilir.

**Senaryo (15 sn):**
1. (0-3sn) "Bugün" ekranı — duruşma listesi
2. (3-7sn) "Senkronize et" tıklanır → e-Devlet ekranı kısaca → "Tamamlandı"
3. (7-11sn) Takvim ekranı, duruşmalar görünür
4. (11-15sn) Bildirim çıkar → "Yarın duruşman var"

Müzik: Sakin, profesyonel. Voice-over yok (uluslararası kullanım için).

---

## Üretim Akışı

1. Tasarımcı (Figma) bu brief'ten 5 mockup üretir.
2. Geliştirici, gerçek build üzerinde aynı içerikle ekran kaydı alır
   (kurmaca dosyalarla).
3. Tasarımcı kayıttan ekran görüntüsünü çıkarır, overlay metinleri ekler.
4. Pazarlama onayı sonrası mağazalara yüklenir.

**Teslim:** Yayın tarihinden 1 hafta önce.
