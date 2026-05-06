# Uygulama İkonu Brief — Law

> Tasarımcıya teslim edilecek brief. Hedef: profesyonel, ciddi, hukuk
> sektörüne yakışır, mağazada kalabalık simgeler arasında öne çıkan bir
> ikon.

## Kavramsal Yön

**Konsept önceliği:** "Düzenli takvim" + "hukuk" birleşimi.

Salt terazi (⚖) ya da çekiç ikonu yüzlerce hukuk uygulamasında var; bizi
ayrıştırmaz. Birincil sembol "takvim/duruşma günü" olmalı, hukuk sembolü
ikincil aksent olarak.

### Ana Yön (Tercih)

Stilize bir **takvim sayfası**. Üzerinde belirgin bir gün rakamı (örn.
"15"). Sayfanın üst spiral kenarı ya da alt köşesinde küçük bir terazi
sembolü altın renkte aksent.

### Alternatif Yönler (B/C planı)

- **B:** Sadece bir terazi sembolü — modern, geometrik, tek renkli. Çok
  jenerik olabilir.
- **C:** "L" harfi monogram — soyut, dikkat çekici ama hukuk sektörünü
  iletmez.

## Renk Paleti

- **Birincil:** Lacivert `#1D3557` (güven, profesyonellik, hukuk geleneği)
- **Aksent:** Altın `#F4A261` (terazi/aksanlar için)
- **Beyaz alan:** `#FAFAF8` (kağıt benzeri yumuşak beyaz, takvim sayfası)
- **Kontrast:** Koyu zemin üzerinde açık ikon, açık zemin üzerinde koyu —
  Apple/Google'ın hem light hem dark masaüstü duvar kağıtlarında okunaklı
  olmalı.

## Tipografi (İkon İçi Rakam)

Eğer takvim üzerinde gün rakamı kullanılırsa:
- **Font:** Geometric sans-serif (Inter, DM Sans, Plus Jakarta)
- **Stil:** Bold (700)
- **Rakam tercihi:** "15" (gözle dengeli iki haneli sayı)

## Format ve Boyutlar

### iOS

- Master: 1024×1024 px PNG, transparency YOK (Apple kabul etmez)
- Apple otomatik olarak alt boyutları üretir (60, 87, 120, 180 vb.)
- Köşe yuvarlama Apple tarafından uygulanır — **ikon kendisi düz kare
  olmalı**, köşe yuvarlama gönderilmemelidir.

### Android (Adaptive Icon)

- Foreground: 432×432 px PNG (orta 264px güvenli alan)
- Background: 432×432 px PNG (düz renk veya basit geometrik desen)
- Legacy round/square fallback: 512×512 px PNG

### Notification Icon (Android)

- 96×96 px monochrome PNG. Şeffaf zemin, beyaz üzerine alfa kanal.
- Tasarım sadeleştirilmiş bir takvim simgesi (rakam çıkar, kontur
  yaklaşımı).

## Kaçınılacak Şeyler

- **YASAK:** UYAP, e-Devlet, T.C. Adalet Bakanlığı, herhangi bir resmi
  kurum logosu/amblemi — telif ve onay sorunu.
- **Kaçın:** Türk bayrağı, ay-yıldız (resmi/milli sembollere yakınlık
  endişesi).
- **Kaçın:** Yargıç çekici (gavel) — Türk hukuk sisteminde kullanılan
  bir araç değil; ABD'lileştirir, sektörü tanımayan algısı yaratır.
- **Kaçın:** Sayfa üzerinde uzun metin (mağazada okunmaz).
- **Kaçın:** Çok karmaşık gradient/3D efektler (iOS dosağı: flat-modern).
- **Kaçın:** Dosya/klasör simgesi (jenerik, "ofis uygulaması" gibi).

## Test Kontrol Listesi

Tasarımcı teslimden önce şunları kontrol eder:

- [ ] 60×60 px'e indirildiğinde tanınabilir mi?
- [ ] Light masaüstü duvar kağıdında okunaklı mı?
- [ ] Dark masaüstü duvar kağıdında okunaklı mı?
- [ ] Ekran okuyucu için "alt text" tanımlandı mı?
  (önerilen: "Law — Avukat Duruşma Takvimi uygulama ikonu")
- [ ] App Store kategorisindeki diğer uygulamaların yanında öne çıkıyor mu?
- [ ] Renk körlüğü filtresinde (deuteranopia, protanopia) ana sembol hâlâ
  okunaklı mı?
- [ ] Push notification küçük ikon (24×24 dp) tanınabilir mi?

## Teslim Listesi

Tasarımcıdan beklenen final teslim:

```
icon/
├── ios/
│   └── icon-1024.png
├── android/
│   ├── adaptive_foreground.png
│   ├── adaptive_background.png
│   ├── legacy_512.png
│   └── notification_24.png
├── source/
│   └── icon.fig (veya .sketch / .ai)
└── README.md (versiyon notu, font lisansı, telif beyanı)
```

## Marka Bütünlüğü

İkon, splash ekranı ve onboarding görselleriyle aynı görsel dilde olmalı.
Splash ekranı ikondaki takvim sayfası animasyonuyla açılırsa marka
hatırlanırlığı artar.
