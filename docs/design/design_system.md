# Design System — Law

> Material 3 (M3) tabanlı, Türk hukuk profesyonelinin görsel beklentilerine
> kalibre edilmiş tasarım sistemi. Tüm değerler hem Figma token'ı hem
> Flutter `ThemeData` karşılığı düşünülerek tanımlanmıştır.

## Tasarım İlkeleri

1. **Ciddiyet > süs.** Avukat uygulaması bir oyun değil; gradient, neon,
   3D efekt yok. Lacivert + altın aksent + bol beyaz alan.
2. **Bilgi yoğunluğu > minimalizm.** Avukat günde onlarca duruşma görür;
   listeyi yapay olarak seyreltmek değil, tarama hızını artıran tipografi
   hiyerarşisi kullan.
3. **Türkçe okunaklılık.** Türkçe kelimeler İngilizce'den uzun (ortalama
   %15-30); buton ve etiketlerde minimum 4 karakter genişlik payı bırak.
4. **Tek elle kullanım.** Birincil aksiyonlar ekranın alt yarısında
   (avukat ayakta, mahkeme koridorunda telefonu tek elle kullanıyor).
5. **Erişilebilirlik AA.** Tüm metin/zemin kontrastı WCAG AA. 16+ pt
   metin için 3:1, 12-15pt için 4.5:1 minimum.

---

## 1. Renk Paleti

### Light Tema

| Token | Hex | Kullanım |
|---|---|---|
| `primary` | `#1D3557` | Birincil marka rengi (lacivert), ana CTA, AppBar |
| `onPrimary` | `#FFFFFF` | Birincil üstündeki metin/ikon |
| `primaryContainer` | `#D6E2F0` | Birincil renkli yumuşak konteyner |
| `onPrimaryContainer` | `#0F1F36` | PrimaryContainer üstündeki metin |
| `secondary` | `#264653` | İkincil aksiyonlar, sekonder vurgular |
| `onSecondary` | `#FFFFFF` | |
| `tertiary` | `#F4A261` | Altın aksent, rozetler, "yeni" işareti |
| `onTertiary` | `#1A1303` | |
| `error` | `#B3261E` | Hata, "sil" gibi tehlikeli aksiyonlar |
| `onError` | `#FFFFFF` | |
| `errorContainer` | `#F9DEDC` | Hata banner zemin |
| `onErrorContainer` | `#410E0B` | |
| `surface` | `#FAFAF8` | Sayfa zemini (kâğıt benzeri yumuşak beyaz) |
| `onSurface` | `#1A1A1A` | Birincil metin |
| `surfaceContainerHigh` | `#F1F1ED` | Kart zemini |
| `surfaceContainerHighest` | `#E8E8E2` | Vurgulu kart |
| `outline` | `#7A7A7A` | Border, ayırıcı |
| `outlineVariant` | `#D6D6D2` | İnce ayırıcı |
| `success` | `#2D6A4F` | Senkron başarılı, onay |
| `warning` | `#E07F00` | Yaklaşan duruşma uyarısı |

### Dark Tema

| Token | Hex | Kullanım |
|---|---|---|
| `primary` | `#A8C4E8` | Birincil (açık lacivert ton) |
| `onPrimary` | `#0F2647` | |
| `primaryContainer` | `#264F7E` | |
| `onPrimaryContainer` | `#D6E2F0` | |
| `secondary` | `#7AAAB8` | |
| `onSecondary` | `#0E2730` | |
| `tertiary` | `#FFB870` | |
| `onTertiary` | `#3A2300` | |
| `error` | `#F2B8B5` | |
| `onError` | `#601410` | |
| `errorContainer` | `#8C1D18` | |
| `onErrorContainer` | `#F9DEDC` | |
| `surface` | `#121417` | |
| `onSurface` | `#E5E5E5` | |
| `surfaceContainerHigh` | `#1E2126` | |
| `surfaceContainerHighest` | `#2A2D33` | |
| `outline` | `#8A8A8A` | |
| `outlineVariant` | `#3A3D42` | |
| `success` | `#74C69D` | |
| `warning` | `#FFB347` | |

### Anlam Renkleri (Hearing Status)

| Durum | Light | Dark | Anlam |
|---|---|---|---|
| `hearingToday` | `#B3261E` | `#F2B8B5` | Bugün gerçekleşecek |
| `hearingThisWeek` | `#E07F00` | `#FFB347` | Bu hafta içinde |
| `hearingFuture` | `#264653` | `#7AAAB8` | İleride |
| `hearingPast` | `#7A7A7A` | `#8A8A8A` | Geçmiş (gri) |

---

## 2. Tipografi

**Font ailesi:** **Inter** (birincil) — Latin alfabesi için optimize, Türkçe
özel karakterleri (ç, ğ, ı, ö, ş, ü) eksiksiz, Variable Font olarak gelir.
Sistem fontu fallback: iOS `SF Pro Text`, Android `Roboto`.

**Sayısal font:** Inter ile uyumlu, tabular-nums özelliği aktifleştirilir
(duruşma saatleri/dosya numaraları sütun hizası için).

### Tip Ölçeği (Material 3 uyumlu)

| Token | Boyut/Satır | Ağırlık | Kullanım |
|---|---|---|---|
| `displayLarge` | 57/64 | 400 | (Kullanılmıyor — splash dışında) |
| `displayMedium` | 45/52 | 400 | Onboarding büyük başlık |
| `displaySmall` | 36/44 | 400 | Empty state başlık |
| `headlineLarge` | 32/40 | 600 | Sayfa başlığı (Ana ekran "Bugün") |
| `headlineMedium` | 28/36 | 600 | Bölüm başlığı |
| `headlineSmall` | 24/32 | 600 | Kart başlığı (büyük) |
| `titleLarge` | 22/28 | 600 | AppBar başlığı |
| `titleMedium` | 16/24 | 600 | ListTile birincil metin |
| `titleSmall` | 14/20 | 600 | Sekme başlığı, küçük buton |
| `bodyLarge` | 16/24 | 400 | Birincil paragraf metin |
| `bodyMedium` | 14/20 | 400 | İkincil metin (mahkeme adı) |
| `bodySmall` | 12/16 | 400 | Yardımcı metin (zaman damgası) |
| `labelLarge` | 14/20 | 600 | Buton etiketi |
| `labelMedium` | 12/16 | 600 | Chip, rozet |
| `labelSmall` | 11/16 | 600 | Çok küçük etiket (kullanmaktan kaçın) |

**Locale-aware:** TR ve EN için aynı ölçek; TR'de buton genişliği için
otomatik padding artışı (Flutter `Tooltip.padding` benzeri yaklaşım).

---

## 3. Spacing Scale

8'lik grid + 4 ara değer. Tüm padding/margin bu listeden çekilir, "magic
number" kabul edilmez.

| Token | px |
|---|---|
| `space.xxs` | 2 |
| `space.xs` | 4 |
| `space.sm` | 8 |
| `space.md` | 12 |
| `space.lg` | 16 |
| `space.xl` | 24 |
| `space.xxl` | 32 |
| `space.xxxl` | 48 |
| `space.huge` | 64 |

**Standartlar:**
- Kart iç padding: `lg` (16)
- Kart dışı margin: `md` (12)
- Ekran kenar margin: `lg` (16) mobile, `xl` (24) tablet
- Buton iç padding: dikey `md` (12), yatay `xl` (24)
- ListTile dikey padding: `md` (12)
- Section başlığı üst boşluk: `xl` (24), alt boşluk: `md` (12)

---

## 4. Elevation (Material 3)

M3 elevation tonlu surface kullanır (gölge yerine ton). Dark temada gölge
yerine tonal yükseklik artar.

| Level | Yükseklik | Kullanım |
|---|---|---|
| `0` | 0 dp | Sayfa zemini |
| `1` | 1 dp | Kart (default) |
| `2` | 3 dp | AppBar (kayan), bottom sheet |
| `3` | 6 dp | Modal, dialog |
| `4` | 8 dp | FAB |
| `5` | 12 dp | (Kullanılmıyor — fazla agresif) |

Light temada hafif gölge (`shadow.color = onSurface @ 8% alpha`) eklenir;
dark temada gölge yok, sadece tonal yükseklik.

---

## 5. Border Radius

| Token | px | Kullanım |
|---|---|---|
| `radius.none` | 0 | Tam ekran |
| `radius.sm` | 4 | Chip, küçük rozet |
| `radius.md` | 8 | Buton, input field |
| `radius.lg` | 12 | Kart |
| `radius.xl` | 16 | Bottom sheet, dialog |
| `radius.xxl` | 24 | Modal, FAB extended |
| `radius.full` | 999 | Yuvarlak rozet, avatar |

**Tutarlılık kuralı:** Bir bileşen içindeki iç elemanlar dış konteynerden
en az bir adım küçük radius kullanır (örn. dış kart 12, iç buton 8).

---

## 6. İkonografi

- **Set:** Material Symbols Rounded (Flutter `material_symbols_icons`
  paketi). Outline varyant default; filled varyant aktif/seçili
  durumlarda.
- **Boyutlar:** 16, 20, 24, 32, 40, 48 dp. Genelde 24.
- **Renk:** İkonlar metin rengini takip eder (`onSurface`, `onPrimary`).
  Renkli ikon (semantik) sadece status göstergelerinde.

**Domain ikonları (sık kullanılan eşleşme):**

| Anlam | İkon |
|---|---|
| Duruşma | `gavel` |
| Dosya | `folder_open` |
| Takvim | `calendar_today` |
| Bildirim | `notifications` |
| Senkron | `sync` |
| Ayarlar | `settings` |
| Hatırlatma | `alarm` |
| Mahkeme | `account_balance` |
| Avukat | `work` |
| Kullanıcı | `person` |
| Güvenlik | `lock` |
| Veri/şifreleme | `shield` |

---

## 7. Motion / Animasyon

- **Süre standartları (M3):**
  - `short1`: 50ms (mikro state değişimi)
  - `short4`: 200ms (geçişler)
  - `medium2`: 300ms (sayfa geçişi)
  - `long1`: 450ms (büyük açılım, modal)
- **Easing:**
  - `standard`: `cubic-bezier(0.2, 0.0, 0, 1.0)` — default
  - `emphasized`: M3 emphasized easing — sayfa geçişleri
- **Reduce motion:** Sistem ayarı kullanıcı tarafından açıksa
  animasyonlar devre dışı bırakılır (Flutter `MediaQuery.disableAnimations`).

---

## 8. Tema Implementasyon Notları (Flutter)

Tek bir `ThemeData` üreteci, `ColorScheme.fromSeed(Color(0xFF1D3557))` ile
M3 dinamik renk dengelemesini kullanır. Kustom token'lar için
`ThemeExtension` yaklaşımı:

```dart
class LawColors extends ThemeExtension<LawColors> {
  final Color hearingToday;
  final Color hearingThisWeek;
  final Color hearingFuture;
  final Color hearingPast;
  // ...
}
```

Spacing, radius gibi sabitler tema dışında bir `LawSpacing` static class
içinde durabilir (tema bağımsız).

---

## 9. Erişilebilirlik

- Tüm interaktif bileşenler minimum 48×48 dp dokunma alanı.
- Form alanlarında `Semantics(label: ...)` zorunlu (vidalanmış metin
  yetmez).
- Renk yalnızca anlam taşıyıcısı OLAMAZ — metin/ikon ile destekle (örn.
  "bugün" rozetinde renk + "BUGÜN" metni).
- Sistem font scaler en az 200%'ye kadar bozulmadan çalışmalı.
- Tab order mantıklı (yukarıdan aşağı, soldan sağa).

---

## 10. Marka Uygulama Kuralları

- "Law" kelimesi her zaman büyük harfle "L" + küçük "aw" — her durumda
  `Law` yazılır, asla `LAW` ya da `law`.
- Marka rengi olarak `primary` ton dışında lacivert kullanılmaz.
- İkon ve splash ekranı arasında geçiş animasyonu marka kimliğini güçlendirir
  (bkz. `icon_brief.md`).
