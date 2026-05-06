# Wireframes — Law

> Metin tabanlı (ASCII) düşük çözünürlüklü wireframe'ler. Geliştiricinin
> ekran iskeletini anlaması ve tasarımcının Figma'da yüksek çözünürlüklü
> mockup üretmesi için referans. Her ekran: amaç, layout, etkileşim,
> empty/error state.

## Genel Layout Konvansiyonu

```
┌─────────────────────────┐
│ AppBar                  │  64 dp
├─────────────────────────┤
│                         │
│  İçerik                 │  scrollable
│                         │
├─────────────────────────┤
│ BottomNav (4 sekme)     │  80 dp
└─────────────────────────┘
```

Onboarding ve modal akışlar BottomNav göstermez.

---

## 1. Onboarding (3 Sayfa)

### 1.1 Hoş Geldin

```
┌─────────────────────────┐
│                         │
│      [Law İkonu]        │
│                         │
│   Avukatın yeni asistanı│  displayMedium
│                         │
│   UYAP duruşmalarınızı  │  bodyLarge, gri
│   telefonunuza otomatik │
│   aktarır, hatırlatır.  │
│                         │
│   ●  ○  ○               │  sayfa noktaları
│                         │
│   ┌───────────────────┐ │
│   │  Devam Et         │ │  primary button
│   └───────────────────┘ │
│   Atla                  │  text button, ortalanmış
└─────────────────────────┘
```

### 1.2 KVKK Açık Rıza

```
┌─────────────────────────┐
│                         │
│   🛡️ Verileriniz Sizin │  headlineMedium
│                         │
│   • Şifreniz cihazınızdan│  bullet list
│     çıkmaz              │
│   • Sunucumuz yok       │
│   • İstediğiniz zaman   │
│     silebilirsiniz      │
│                         │
│   [Aydınlatma Metnini  ]│  text link → modal
│   [oku                 ]│
│                         │
│   ☐ KVKK aydınlatma     │  checkbox (zorunlu)
│      metnini okudum,    │
│      kabul ediyorum     │
│                         │
│   ☐ İsteğe bağlı:       │  checkbox (opsiyonel)
│      Anonim çökme       │
│      raporu gönderilsin │
│                         │
│   ●  ●  ○               │
│                         │
│   ┌───────────────────┐ │
│   │  Devam Et         │ │  disabled if !checked
│   └───────────────────┘ │
└─────────────────────────┘
```

**Etkileşim:** Birinci checkbox işaretlenmeden "Devam Et" disabled.

### 1.3 İzinler

```
┌─────────────────────────┐
│                         │
│   📅 Birkaç İzin Lazım  │  headlineMedium
│                         │
│   Aşağıdaki izinler     │  bodyMedium
│   uygulamanın çalışması │
│   için gerekli:         │
│                         │
│   ┌─────────────────┐   │
│   │ 📅 Takvim       │   │  card
│   │ Duruşmaları     │   │
│   │ takviminize ekler│   │
│   │ [İzin Ver]      │   │  button
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │ 🔔 Bildirim     │   │
│   │ Hatırlatma için │   │
│   │ [İzin Ver]      │   │
│   └─────────────────┘   │
│                         │
│   ●  ●  ●               │
│                         │
│   ┌───────────────────┐ │
│   │  İlk Senkronu Başlat│
│   └───────────────────┘ │
│   Sonra yapacağım       │  text button
└─────────────────────────┘
```

**Etkileşim:** Her kart tıklandığında native izin diyalogu. Reddedilirse
buton "Ayarlardan Aç"a dönüşür ve native settings'e deep link.

---

## 2. Ana Ekran (BottomNav: Bugün / Takvim / Dosyalar / Ayarlar)

### 2.1 "Bugün" Sekmesi

```
┌─────────────────────────┐
│ Bugün         🔄 ⋮     │  AppBar
│ 5 Mayıs Salı            │  bodyMedium, gri
├─────────────────────────┤
│                         │
│ ┌─────────────────────┐ │
│ │ 09:30  ⚖           │ │  HearingCard
│ │ 12. Asliye Hukuk    │ │  titleMedium
│ │ Esas 2025/1234      │ │  bodySmall
│ │ Salon 4             │ │
│ │ [2 saat sonra]      │ │  rozet, kırmızı
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ 14:00               │ │
│ │ 8. İş Mahkemesi     │ │
│ │ Esas 2024/567       │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ 16:30               │ │
│ │ 3. Aile Mahkemesi   │ │
│ │ Esas 2026/89        │ │
│ └─────────────────────┘ │
│                         │
│  ─── Yarın (2) ───      │  section divider
│                         │
│ ┌─────────────────────┐ │
│ │ 10:00 ...           │ │
│ └─────────────────────┘ │
├─────────────────────────┤
│ ⚖ Bugün │ 📅 Takvim │  │  BottomNav
│ 📂 Dosya│ ⚙ Ayar   │  │
└─────────────────────────┘
```

**Empty state (bugün duruşma yoksa):**
```
   ✨
   Bugün için duruşman yok
   Yarınki duruşmaları görmek için
   takvime git.
   [Takvime Git]
```

**Pull-to-refresh:** Senkron tetikler.

### 2.2 "Takvim" Sekmesi

```
┌─────────────────────────┐
│ Takvim        🔄        │
│ ◀  Mayıs 2026  ▶       │  ay seçici
├─────────────────────────┤
│ Pz Sa Ça Pe Cu Ct Pa   │
│           1  2  3  4   │
│  5  6  7  8  9 10 11   │
│  •  •     •            │  • = duruşma var
│ 12 13 14 15 16 17 18   │
│  •  •  •     •         │
│ ...                     │
├─────────────────────────┤
│ 12 Mayıs Salı (2)       │  seçili gün başlığı
│                         │
│ ┌─────────────────────┐ │
│ │ 11:00 İstanbul ...  │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ 15:30 Ankara ...    │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

**Etkileşim:** Ay üst başlığa tıklandığında yıl seçici. Gün uzun bas →
"Bu güne not ekle" sheet.

### 2.3 "Dosyalar" Sekmesi

```
┌─────────────────────────┐
│ Dosyalar      🔍 🔄    │
├─────────────────────────┤
│ [Ara...]                │  search field
│ Filtre: Tümü ▼          │  chip filter
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ 📂 Esas 2025/1234   │ │  CaseListTile
│ │ 12. Asliye Hukuk    │ │
│ │ A.Y. — B.K.         │ │
│ │ Sonraki: 5 Mayıs    │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ 📂 Esas 2024/567    │ │
│ │ ...                 │ │
│ └─────────────────────┘ │
│                         │
│  (sonsuz scroll)        │
└─────────────────────────┘
```

**Boş arama sonucu:** "'xyz' için sonuç bulunamadı."

### 2.4 "Ayarlar" Sekmesi

```
┌─────────────────────────┐
│ Ayarlar                 │
├─────────────────────────┤
│ HESAP                   │
│  Profil bilgilerim      │ →
│  KVKK / Gizlilik        │ →
│                         │
│ SENKRON                 │
│  Otomatik senkron   ●●  │ toggle
│  Senkron sıklığı  6 sa ▼│
│  Manuel senkronla       │ →
│  Son senkron: ... önce  │ bodySmall
│                         │
│ BİLDİRİM                │
│  Bildirim göster    ●●  │
│  1 gün önce       21:00 │ time picker
│  2 saat önce kalsın ●●  │
│                         │
│ TAKVİM                  │
│  Takvim seç      Apple ▼│
│  Otomatik yaz      ●●   │
│                         │
│ VERİLERİM               │
│  XML olarak dışa aktar  │ →
│  Tüm verilerimi sil     │ → kırmızı
│                         │
│ HAKKINDA                │
│  Sürüm 1.0.0 (1)        │
│  Yasal belgeler         │ →
│  Destek                 │ →
└─────────────────────────┘
```

---

## 3. Dosya Detay

```
┌─────────────────────────┐
│ ←   Esas 2025/1234   ⋮ │  AppBar
├─────────────────────────┤
│ 12. Asliye Hukuk        │  titleLarge
│ Mahkemesi               │
│ İstanbul                │  bodyMedium gri
│                         │
│ TARAFLAR                │  section header
│  Davacı: A.Y.           │
│  Davalı: B.K.           │
│                         │
│ ─────────────────       │
│ DURUŞMALAR              │
│                         │
│ ▼ Yaklaşan (2)          │  expandable
│  • 5 May 2026 09:30     │
│  • 14 Haz 2026 11:00    │
│                         │
│ ▶ Geçmiş (3)            │  collapsed
│                         │
│ ─────────────────       │
│ NOTLARIM    [+ Ekle]    │
│                         │
│ ┌─────────────────────┐ │
│ │ "Tanık dinletilecek"│ │
│ │ 12 Nis 2026         │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

**AppBar ⋮ menüsü:** UYAP'ta aç (URL launcher), Paylaş, Notları sil.

---

## 4. Duruşma Detay

```
┌─────────────────────────┐
│ ←   Duruşma          ⋮ │
├─────────────────────────┤
│ 5 Mayıs 2026 Salı       │  headlineSmall
│ 09:30                   │  displaySmall (büyük)
│ [2 saat sonra]          │  rozet
│                         │
│ Mahkeme                 │
│ 12. Asliye Hukuk        │
│                         │
│ Salon                   │
│ Salon 4                 │
│                         │
│ Dosya                   │
│ Esas 2025/1234       →  │ tıklanır → dosya detay
│                         │
│ Gündem                  │
│ Tanık dinleme           │
│                         │
│ Hatırlatmalar           │
│  ☑ 1 gün önce 21:00     │
│  ☑ 2 saat önce          │
│  + Hatırlatma ekle      │
│                         │
│ ┌─────────────────────┐ │
│ │ 📅 Takvime Yazıldı  │ │  status banner
│ └─────────────────────┘ │
└─────────────────────────┘
```

**⋮ menüsü:** Yol tarifi (mahkeme adresi varsa), Paylaş, Bildirimleri kapat.

---

## 5. Senkron Ekranı (WebView)

### 5.1 WebView Açık (login esnasında)

```
┌─────────────────────────┐
│ ✕  e-Devlet'e giriş    │  AppBar (X kapatır)
├─────────────────────────┤
│                         │
│  [Resmi e-Devlet sayfası│
│   tam görünür — WebView]│
│                         │
│   T.C. Kimlik No: ____  │
│   e-Devlet Şifresi: ____│
│   [Sisteme Giriş Yap]   │
│                         │
├─────────────────────────┤
│ 🔒 Şifreniz uygulamamıza│  alt info bar
│ iletilmez. Doğrudan     │
│ giris.turkiye.gov.tr'ye │
│ girersiniz.             │
└─────────────────────────┘
```

### 5.2 Senkron İşleniyor (overlay)

```
┌─────────────────────────┐
│ ←   Senkronize ediliyor │
├─────────────────────────┤
│                         │
│       ⟳ (spinner)       │
│                         │
│   Dosyalar okunuyor...  │  bodyLarge
│                         │
│   ▓▓▓▓▓▓░░░░  60%       │  progress bar
│                         │
│   12 / 20 dosya         │  bodySmall
│                         │
│   [İptal]               │  text button
│                         │
└─────────────────────────┘
```

### 5.3 Senkron Sonuç

```
┌─────────────────────────┐
│ ←   Senkron Tamamlandı  │
├─────────────────────────┤
│                         │
│       ✓ (büyük yeşil)   │
│                         │
│   Senkron tamamlandı    │  headlineMedium
│                         │
│   ┌─────────────────┐   │
│   │ 32 dosya        │   │
│   │ kontrol edildi  │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ ➕ 3 yeni       │   │
│   │ duruşma         │   │
│   └─────────────────┘   │
│   ┌─────────────────┐   │
│   │ ✏ 1 değişen   │   │
│   │ tarih           │   │
│   └─────────────────┘   │
│                         │
│   ┌───────────────────┐ │
│   │  Bugüne Dön       │ │
│   └───────────────────┘ │
└─────────────────────────┘
```

### 5.4 Senkron Hatası

```
┌─────────────────────────┐
│       ⚠ (turuncu)       │
│   Senkron yapılamadı    │
│                         │
│   UYAP'a ulaşılamadı.   │  bodyMedium
│   İnternet bağlantını   │
│   kontrol et.           │
│                         │
│   [Tekrar Dene]         │
│   [Daha Sonra]          │
└─────────────────────────┘
```

(Hata türleri için bkz. `error_catalog.md`.)

---

## 6. Modal / Bottom Sheet Patterns

### Not Ekleme Bottom Sheet

```
┌─────────────────────────┐
│ ─                       │  drag handle
│                         │
│ Not Ekle                │  titleLarge
│ Esas 2025/1234          │  bodySmall
│                         │
│ ┌─────────────────────┐ │
│ │                     │ │  multiline TextField
│ │ Not yaz...          │ │
│ │                     │ │
│ └─────────────────────┘ │
│                         │
│ [İptal]    [Kaydet]     │  alt sağ
└─────────────────────────┘
```

### Ay Seçici (Takvim)

Native picker (CupertinoDatePicker iOS, MaterialDatePicker Android).

---

## 7. Tablet Adaptasyonu (özet)

- 768 dp+ genişlikte BottomNav yerine NavigationRail (sol).
- Liste + detay split view (master-detail).
- Onboarding sayfaları ortalanır, max-width 480 dp.

---

## Üretim Akışı

1. Bu wireframe'i tasarımcı (Figma) yüksek çözünürlüklü mockup'a çevirir.
2. Geliştirici, Component Inventory (`component_inventory.md`) referans
   alarak Flutter widget'larını yazar.
3. Widget testleriyle visual regression korunur.
