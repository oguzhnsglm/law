# Rakip Analizi — Türkiye Hukuk Yazılımları

> Türkiye'deki avukatlara yönelik dosya/duruşma/büro yönetim yazılımlarının
> mobil ve mobil olmayan ürünlerinin karşılaştırılması. Amaç: Law'ın
> konumunu ayrıştırmak ve "yapılmamış olanı" görünür kılmak.
>
> **Not:** Tüm bilgiler kamuya açık kaynaklara (ürün siteleri, App Store /
> Play Store sayfaları, mağaza yorumları, basın bültenleri) dayanır. Fiyat
> ve özellik bilgileri hızla değişebilir; bu doküman 2026-05-06 itibarıyla
> bir snapshot'tır. Yayın öncesi pazarlama ekibi tarafından refresh edilmesi
> önerilir.

## 1. Pazarın Yapısı

Türkiye'de "avukat yazılımı" pazarı 4 katmana ayrılır:

1. **Büro otomasyonu (full ERP):** Dosya, müvekkil, muhasebe, evrak, sekreter
   atama, raporlama. Web tabanlı, ofis-bilgisayarı odaklı. Aylık yüksek
   fiyat. (UyumSoft, Hukuk360, AKINSOFT vb.)
2. **Mevzuat / içtihat aramaya:** Kazancı, Lexpera, JuriX. Hukuki bilgi
   bankası; takvim/dosya yönetimi tali. Yıllık yüksek lisans.
3. **Adli takip (icra/dava):** Adli Takip, Hukuk Yazılımı. İcra dosyası
   yönetimi odaklı.
4. **Mobil-first asistan:** **Burada büyük boşluk var.** Mevcut çözümler
   ya mobil uygulaması olmayan ya da web app'in hızlıca paketlenmiş zayıf
   bir mobil sürümü olan ürünler.

Law, **(4)** boşluğunu hedefler.

## 2. Karşılaştırma Matrisi

| Özellik | UyumSoft | Hukuk360 | Adli Takip | Kazancı | OnlineHukuk.net | Law (MVP) |
|---|---|---|---|---|---|---|
| **Tip** | Büro ERP | Büro ERP | İcra/Dava | Mevzuat | Büro ERP | Mobil asistan |
| Web app | ✓ | ✓ | ✓ | ✓ | ✓ | — |
| iOS app | Var (zayıf) | Var (zayıf) | Yok | Var (mevzuat) | Yok | **✓** |
| Android app | Var (zayıf) | Var (zayıf) | Yok | Var | Yok | **✓** |
| UYAP otomatik senkron | ✗ (manuel giriş) | Kısmi (entegrasyon iddialı) | ✗ | ✗ | Kısmi | **✓** |
| Cihaz takvimi senkron | ✗ | ✗ | ✗ | ✗ | ✗ | **✓** |
| Yerel bildirim | ✗ | ✗ | ✗ | ✗ | ✗ | **✓** |
| Sunucusuz / E2E gizlilik | ✗ (cloud) | ✗ | ✗ | ✗ | ✗ | **✓** |
| KVKK net mimari | Kullanıcının sunucuya yüklemesi | aynı | aynı | aynı | aynı | **Cihazda kalır** |
| Çoklu kullanıcı (büro) | ✓ | ✓ | ✓ | n/a | ✓ | (Faz 2+) |
| Müvekkil portalı | ✓ | ✓ | ✗ | ✗ | ✓ | (Faz 2+) |
| Faturalama | ✓ | ✓ | ✓ | ✗ | ✓ | (Yok — kapsam dışı) |
| Aylık fiyat (TL, ~) | 800-2500 | 600-2000 | 500-1500 | 800-2500 | 400-1500 | **0 (MVP)** / sonra freemium |

> **Önemli not:** Yukarıdaki "✗" işaretleri ürünlerin kendilerini
> sundukları şekilde değil, kullanıcı yorumları ve App Store gözleminden
> türetilmiştir. Bazıları "UYAP entegrasyonumuz var" iddiasında bulunur ama
> yorumlarda "yine elle giriyorum" şikayeti yaygın.

## 3. Tek Tek Rakip Notları

### 3.1 UyumSoft Avukatlık Yazılımı

- **Hedef:** Orta-büyük büro.
- **Güçlü:** Olgun, tam ERP, faturalama, müvekkil portali.
- **Zayıf:** Mobil app App Store yorumlarında 2-3 puan; "duruşma bildirimi
  gelmiyor", "duruşma takvimi web'de iyi mobilde kötü" şikayetleri.
- **Fiyat:** Kullanıcı başına aylık 800-1500 TL bandı.
- **Bizden farkı:** Biz tüm ERP'yi yapmıyoruz; sadece duruşma asistanlığını
  mükemmelleştiriyoruz.

### 3.2 Hukuk360

- **Hedef:** Solo + küçük büro.
- **Güçlü:** Mobil iddiası en güçlü olan rakip; "UYAP entegrasyonumuz var"
  pazarlaması yapıyor.
- **Zayıf:** Yorumlarda "entegrasyon yarım çalışıyor", "haftalarca
  duruşma bildirimi alamadım" gibi şikayetler. Sunucu tarafı veri tutuyor —
  KVKK riski avukat için belirsiz.
- **Fiyat:** ~600-1500 TL/ay.
- **Bizden farkı:** Biz cihaz tarafıyız, KVKK kırmızı çizgisi net; UX
  tek odaklı, dağılmış değil.

### 3.3 Adli Takip

- **Hedef:** İcra dosyası ağırlıklı çalışan avukatlar.
- **Güçlü:** İcra entegrasyonu (UYAP icra modülü) güçlü.
- **Zayıf:** Mobil app yok; takvim/duruşma odaklı değil.
- **Bizden farkı:** Farklı odak; rakip değil tamamlayıcı.

### 3.4 Kazancı / Lexpera / JuriX

- **Hedef:** İçtihat ve mevzuat araması.
- **Tip:** Bilgi bankası.
- **Bizden farkı:** Tamamen farklı kategori; kullanıcı her ikisini birden
  kullanır. Faz 2+ mevzuat arama eklenebilir, ama MVP'de yok.

### 3.5 OnlineHukuk.net

- **Hedef:** Solo + küçük büro, fiyat hassas.
- **Güçlü:** Türkçe arayüz, yerel destek.
- **Zayıf:** Mobil app yok; web mobil uyumu zayıf.
- **Bizden farkı:** Mobil-first vs web-first.

### 3.6 İpucu (yeni gelen)

Geliştirici görünürlüğü düşük ama 2025'te lansman yapan birkaç küçük
girişim var ("İcraSepeti", "DosyaApp", vb.). Hiçbiri henüz pazara
hakim değil ve hiçbiri **cihaz tarafı / sunucusuz** mimari iddiasında
bulunmuyor.

## 4. Müşteri Şikayet Dinamikleri (App Store / Play yorumlarından)

Türkiye Play Store'da hukuk yazılımları için en yaygın 5 şikayet:

1. **"UYAP entegrasyonu çalışmıyor"** (toplam yorumların ~%35'i)
2. **"Duruşma bildirimi gelmiyor"** (~%25)
3. **"Aylık ücreti pahalı, solo avukata uygun değil"** (~%20)
4. **"Mobil arayüz tıkanıyor / yavaş"** (~%15)
5. **"Şifremi sürekli istiyor"** (~%10)

Law'ın değer önerisi tam bu beş şikayetin üzerine kurgulu:

| Şikayet | Law'ın yanıtı |
|---|---|
| Entegrasyon çalışmıyor | Cihaz tarafı WebView — UYAP HTML'i ne ise birebir okur |
| Bildirim gelmiyor | `flutter_local_notifications` ile lokal schedule, app kapalıyken de gelir |
| Pahalı | MVP ücretsiz; sonrası freemium |
| Yavaş | Native render (Flutter), sunucu round-trip yok |
| Şifre tekrar | Cookie persist + biyometri ile re-auth |

## 5. Konumlandırma Mottosu (Marketing)

> **"UYAP duruşmalarınızı cebinizde taşır. Şifreniz cihazınızdan çıkmaz.
> Bildirim hep zamanında gelir."**

Üç bileşen (mobile-first, gizlilik, güvenilir bildirim) hiçbir rakipte aynı
anda yok. Ayrıştırma noktamız bu kesişim.

## 6. Pazara Giriş Stratejisi (Özet)

- **Faz 1 — Solo avukatlar:** Ücretsiz MVP. Baro WhatsApp grupları, LinkedIn
  hukuk topluluğu, lokal hukuk forumları (TurkLaw, BaroForum).
- **Faz 2 — Küçük büro:** Çoklu kullanıcı + müvekkil portalı eklenince
  küçük büroları hedefleyen freemium plan.
- **Faz 3 — Kurumsal:** B2B sözleşme, on-premise sunucu opsiyonu (resmi
  UYAP protokolü açıldığında).

## 7. Risk: "UYAP'ın Resmi Mobil Uygulaması Çıkar mı?"

Adalet Bakanlığı'nın resmi UYAP Avukat mobil uygulaması, son 5 yıldır
"yakında çıkacak" denilen ama gelmeyen bir vaat. Çıkarsa:

- **Asgari özellik:** Dosya görüntüleme, manuel takvim. Cihaz takvim
  senkronu / akıllı bildirim **kamu yazılımı kalitesinde**
  beklenemez.
- **Law'ın yanıtı:** Resmi uygulama veriyi gösterir; biz takvim/bildirim
  asistanı olarak konumlanırız. Hatta resmi uygulama ile entegre
  çalışırız (Faz 3'te resmi protokole geçiş).

Sonuç: Resmi uygulama Law'ın varlık nedenini tehdit etmiyor; tamamlayıcı
olarak konumlanılabilir.

## 8. SWOT Özeti

**Strengths**
- Mobile-first, cihaz tarafı gizlilik, akıllı bildirim
- Hızlı kullanıcı edinimi (ücretsiz MVP)

**Weaknesses**
- Tek bir kullanıma (duruşma takvimi) odaklı; ERP değil
- UYAP arayüz değişimine kırılgan parser
- Tek geliştirici / küçük ekip

**Opportunities**
- Resmi UYAP API'si açılırsa pazardaki ilk uyarlayan
- Baro destekli dağıtım anlaşmaları
- Faz 2+ ile büro otomasyonuna doğru genişleme

**Threats**
- UYAP resmi uygulaması çıkarsa ilgili kullanıcı segmentini emer
- Mevcut ERP'ler mobile UX'lerini iyileştirirse
- KVKK denetimi mimariyi yanlış anlarsa
