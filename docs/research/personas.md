# Avukat Persona'ları — Law

> Law'ın hedef kullanıcı segmentini somutlaştıran 3 persona. Tasarım,
> ürün, pazarlama kararlarında "X persona için bu nasıl çalışır?"
> sorusunu sorabilmek için tutuluyor.
>
> Persona'lar **kurmaca**dır; gerçek bir kişiyi temsil etmez. İsimler ve
> detaylar Türkiye hukuk sektöründeki tipik profillerden türetildi.

---

## P1 — Solo Avukat: "Mert"

```
┌──────────────────────────────────────────┐
│  👤  Mert Yıldız, 34                     │
│                                          │
│  • Solo avukat, kendi ofisi              │
│  • İstanbul Barosu, 8 yıllık avukat      │
│  • Aktif dosya sayısı: 80-120            │
│  • Aylık duruşma sayısı: 25-40           │
│  • Mahkeme dağılımı: 5+ farklı adliye    │
└──────────────────────────────────────────┘
```

### Bağlam

- Hukuk fakültesini İstanbul'da bitirdi, 2 yıl orta büyüklükte bir büroda
  çalıştıktan sonra kendi ofisini açtı.
- Ofiste yarı zamanlı bir sekreter (Ayşe) çalışıyor; ama Ayşe duruşma
  takvimine doğrudan müdahale etmiyor.
- Çoğunlukla aile, iş ve ticaret hukuku dosyaları.

### Ekipman ve Yazılım Alışkanlığı

- iPhone 14 (özel + iş aynı)
- iPad Pro (mahkeme koridorunda dilekçe için)
- MacBook Air (ofis ana ekranı)
- Mevcut takvim sistemi: **Apple Calendar**, manuel girilmiş duruşmalar
- UYAP'a günde 2-3 kez bilgisayardan girer
- Excel "duruşma listesi.xlsx" — sekreterle paylaşılan, hep güncel olmayan

### Hedefler

1. Bir duruşmayı **asla** kaçırmamak (en büyük kabusu).
2. Sabah hangi duruşmaların olduğunu telefonda kahve eşliğinde görmek.
3. UYAP'a sürekli giriş yapmaktan yorulmamak.
4. Sekreterine bağımlı kalmadan kendi takvimini görmek.

### Ağrı Noktaları

- UYAP Avukat Portal mobil uyumlu değil; telefonda açtığında pinch-zoom
  bezdirici.
- Bir önceki ay hızlı bir tarih değişikliği (mahkeme erteledi) bildirimini
  kaçırdı, son anda fark etti — adrenalin patlaması.
- Apple Calendar'a manuel duruşma girmek 1-2 dakika alıyor; günde 5
  duruşma → 10 dakika kayıp + hata riski.
- Excel listesini sekreter güncellemeyi bazen unutuyor.

### Law Onun İçin Ne Demek

- "Sabah uyandığımda ekrana bakınca ne var ne yok görüyorum" — `Bugün`
  sekmesi.
- "Apple Calendar'ıma kendiliğinden işleniyor, başka uygulama açmama
  gerek yok" — takvim senkronu.
- "Bir şey unutmamış olmaktan emin olduğum için rahat uyuyorum" — 1 gün
  önce + 2 saat önce hatırlatma.
- "Sekreter olmasa bile kendim ayakta durabiliyorum" — sekreter
  bağımsızlığı.

### Önemli Tasarım Sonucu

- iOS optimizasyonu Mert için kritik — Apple Calendar entegrasyonu
  öncelik.
- Mahkeme koridorunda hızlı erişim önemli — `Bugün` sekmesi varsayılan
  açılış ekranı.
- Sekreter modu (P3) onun için MVP'de gerekli değil; Faz 2.

---

## P2 — Küçük Büro Ortağı: "Ayşegül"

```
┌──────────────────────────────────────────┐
│  👤  Ayşegül Demir, 45                   │
│                                          │
│  • 3 ortaklı bir hukuk bürosu (Ankara)   │
│  • Ankara Barosu, 18 yıllık avukat       │
│  • Aktif dosya sayısı: 200+ (ortaklık)   │
│  • Kendi takip ettiği: ~60 dosya          │
│  • Aylık duruşma: 30-50                   │
└──────────────────────────────────────────┘
```

### Bağlam

- 3 ortakla kurduğu bürodaki kıdemli ortak.
- 1 sekreter, 1 stajyer, 2 katip büroda. Sekreter dosya takibinde aktif.
- Ağırlıklı dava konusu: ticaret, idari, vergi.
- Büro kendi ERP yazılımı kullanıyor (UyumSoft); ama Ayşegül "yine de
  duruşmamı telefonda görmem lazım" diyor.

### Ekipman ve Yazılım Alışkanlığı

- Samsung Galaxy S23 (Android)
- Bilgisayar: Windows 11
- Büro takvimi: UyumSoft içinde + Outlook senkronu
- Telefon takvimi: Samsung Calendar

### Hedefler

1. Büro ERP'si işin ofis kısmını yapsın; o telefonunda **kendi**
   duruşmalarını görmek istiyor.
2. Stajyer/katiplere bağımlı olmadan da bilgi sahibi olmak.
3. Yolda (taksi/araba) hızlıca "yarınki duruşmaları" gözden geçirmek.

### Ağrı Noktaları

- UyumSoft mobil app'i yavaş, açılışı uzun sürüyor.
- Outlook'a senkronlanan ERP duruşmaları bazen 1-2 günlük gecikmeli.
- Stajyer "bunu UYAP'tan baktım" dediğinde teyit etmenin yolu uzun.
- Büro ERP'sinin tüm verilerini kendi telefonunda taşımak istemiyor
  (gizlilik kaygısı + KVKK).

### Law Onun İçin Ne Demek

- "Büro yazılımım ne yaparsa yapsın, telefonumda duruşmalarımı kendim
  görüyorum" — bağımsız bir teyit aracı.
- "Stajyerden duyacağıma kendim okurum" — UYAP'tan birinci kaynaktan
  veri.
- "Büro ERP'sinin gizlilik problemini taşımıyorum" — cihaz tarafı
  mimari.

### Önemli Tasarım Sonucu

- Android UX en az iOS kadar parlak olmalı.
- "Sadece kendi dosyalarım" filtresi zorunlu (ortaklık dosyaları diğer
  ortaklardan izinsiz görünmemeli).
- Çoklu kullanıcı (büro ortak takvimi) Faz 2 talebi — şimdi MVP'de yok.
- ERP entegrasyonu YOK; tamamlayıcı olarak konumlanıyor.

---

## P3 — Stajyer Avukat: "Kerem"

```
┌──────────────────────────────────────────┐
│  👤  Kerem Aksoy, 26                     │
│                                          │
│  • Stajyer avukat (1 yıllık staj devam)  │
│  • İzmir Barosu (staj kaydı)             │
│  • Yanında staj yaptığı: bir kıdemli     │
│    avukatın yanında (P1 benzeri)         │
│  • Aktif takip: hocasının ~50 dosyası    │
└──────────────────────────────────────────┘
```

### Bağlam

- Hukuk fakültesinden geçen yıl mezun oldu, 1 yıllık avukatlık stajına
  başladı.
- Hocası (kıdemli avukat) ona "duruşma takvimini takip et, beni
  uyar" diyor.
- Kendi UYAP hesabı yok; hocasının hesabıyla giriş yapıp dosya/duruşma
  bilgilerini takip ediyor (yetki vekaleti çerçevesinde — bu pratik
  yaygın olsa da gri alan).

### Ekipman ve Yazılım Alışkanlığı

- Android orta segment (Xiaomi)
- Samimi kullandığı uygulama: WhatsApp, Google Calendar
- Excel'le hocaya günlük duruşma listesi gönderir
- Her gece UYAP'a bilgisayardan girip değişen tarihleri kontrol eder

### Hedefler

1. Hocaya "şu duruşma şu saatte" demeyi unutmamak.
2. Gece UYAP kontrolü süresini 30 dakikadan 5 dakikaya indirmek.
3. Profesyonel görünmek (zamanında bilgi vererek).

### Ağrı Noktaları

- UYAP'ı manuel taramak çok uzun.
- Excel listesini her gün güncellemek can sıkıcı.
- Hoca son dakika "duruşma erkene mi alındı?" diye soruyor; cevap için
  tekrar UYAP'a giriliyor.
- Hocasının şifresiyle giriyor — bu konuda kendisi de huzursuz, daha
  güvenli bir sistem arıyor.

### Law Onun İçin Ne Demek

- "Senkron yaptığımda 30 dakikalık iş 30 saniyede bitiyor" — hız.
- "Hoca telefonda direkt bakar, ben aracılığa indirgenmem" —
  paylaşılabilir model (Faz 2'de hoca da uygulamayı kullanırsa
  Kerem'in işi tamamen değişir).
- **Önemli not:** Hocasının e-Devlet şifresiyle Law'ı hocasının
  telefonunda kullanmak, hocanın **kendi** uygulamasıyla mümkün —
  Kerem değil, hoca login olur. Bu doğru kullanım modeli MVP'de net
  iletilmeli.

### Önemli Tasarım Sonucu

- "Sekreter modu" (başka birinin hesabıyla giriş yapma) MVP'de
  **desteklenmiyor**; doğru çözüm avukatın kendi telefonunda Law
  kullanması. Bu, Kerem'in talebine doğrudan yanıt **değil**, ama
  çözmek istediği problem için doğru yön.
- Hocayı uygulamaya çekmek pazarlama açısından önemli (P3 kanaldır,
  P1/P2 alıcı).
- Faz 2+ "büro ortak takvimi": Hoca login olur, Kerem o cihaza
  okuma erişimi alır → KVKK uyumlu çoklu kullanıcı modeli.

---

## Persona Önceliklendirme (MVP)

| Persona | MVP Hedef? | Gerekçe |
|---|---|---|
| P1 — Solo Avukat | **Birincil** | En düz user journey; ürünün karşıladığı core problem direkt onun problemi |
| P2 — Küçük Büro Ortağı | İkincil | Ürün onu da çekecek ama özel feature gerekmiyor |
| P3 — Stajyer | Pazarlama kanalı | MVP onun problemini doğrudan çözmüyor; o hocayı bize getirir |

**Tasarım kuralı:** Bir feature'ın "P1'e değer katmıyor" olması veto
sebebidir; "P3'e değer katmıyor" olması veto sebebi değildir.

## Kullanılmayan Persona'lar (Açıkça Hedef Dışı)

- **Müvekkil (gerçek kişi):** Avukat değil, kendi davasını takip etmek
  isteyen vatandaş. UYAP'ın e-Devlet "Vatandaş" modülü farklı bir
  kullanıcı arayüzü; Law bu kapsamda değil.
- **Kurumsal hukuk müşaviri (in-house):** Şirket içinde çalışan, dış
  dosyalarla daha az ilişkili. Faz 3+.
- **Mahkeme katibi / hâkim:** Yargı görevlileri; UYAP'taki rolü farklı,
  Law kapsam dışı.
