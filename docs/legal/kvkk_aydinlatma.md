# KVKK Aydınlatma Metni — Law Uygulaması

> **DRAFT — İLERİDE BİLİŞİM HUKUKÇUSU TARAFINDAN İNCELENMESİ ZORUNLUDUR.**
> Bu metin geliştirme sürecinde teknik ekibin hazırladığı taslaktır. Yayın
> öncesinde mutlaka KVKK ve bilişim hukuku alanında uzman bir avukat tarafından
> gözden geçirilmeli, kuruluş bilgileri (unvan, MERSİS, VERBİS sicil no, adres,
> KEP) doldurulmalı ve onaylanmalıdır.

**Yürürlük tarihi:** [YYYY-MM-DD]
**Sürüm:** Taslak v0.1

---

## 1. Veri Sorumlusu

- **Unvan:** [LİMİTED ŞİRKET ADI]
- **MERSİS No:** [MERSİS]
- **Adres:** [TAM ADRES]
- **KEP adresi:** [KEP]
- **E-posta:** [İLETİŞİM E-POSTASI]
- **VERBİS sicil no:** [DOLDURULACAK / KAPSAM DIŞI ise gerekçeli not]

İşbu metin, 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") ve ilgili
mevzuat kapsamında veri sorumlusu sıfatıyla tarafımızca hazırlanmıştır.

---

## 2. Uygulamanın Veri Mimarisi (Önemli)

Law uygulaması, "**cihaz tarafı**" ilkesine göre tasarlanmıştır. Bunun pratik
sonuçları:

- Kullanıcının e-Devlet/UYAP **şifresi uygulamamıza ya da herhangi bir
  sunucumuza iletilmez.** Şifre yalnızca cihaz içindeki WebView bileşeninde,
  T.C. Cumhurbaşkanlığı Dijital Dönüşüm Ofisi'nin işlettiği
  `giris.turkiye.gov.tr` adresine doğrudan girilir.
- UYAP üzerinden çekilen **dosya, duruşma, taraf bilgileri kullanıcının
  cihazında kalır.** Tarafımıza ait herhangi bir sunucuya, bulut hizmetine
  veya üçüncü partiye aktarılmaz.
- Veriler cihazda **AES-256 şifreli SQLite (SQLCipher)** veritabanında
  saklanır. Şifreleme anahtarı işletim sistemi seviyesindeki güvenli
  saklama alanlarında (iOS Keychain / Android Keystore) tutulur.

Bu mimari, KVKK kapsamındaki "veri işleme" eylemlerimizi olabilecek en dar
yüzeye indirger. Aşağıdaki maddeler, uygulamanın kullanıldığı esnada
gerçekleşen sınırlı işlemleri açıklar.

---

## 3. İşlenen Kişisel Veri Kategorileri

### 3.1. Kullanıcının Cihazında Saklanan Veriler (Tarafımıza İletilmeyen)

- **Kimlik bilgileri:** Ad, soyad, baro sicil numarası (kullanıcı isteğe bağlı
  olarak girer).
- **Mesleki veriler:** UYAP'tan çekilen dosya numarası, mahkeme adı, dosya
  türü, taraf bilgileri, duruşma tarih/saatleri, salon, gündem.
- **Kullanıcı notları:** Kullanıcının duruşmaya manuel olarak eklediği
  serbest metin notlar.

Bu veriler **yalnızca kullanıcının cihazında**, kullanıcının uygulamayı
silmesine kadar tutulur. Tarafımız bu verilere teknik olarak erişemez.

### 3.2. Tarafımızca İşlenen Veriler (Sınırlı)

- **Uygulama mağazası analitikleri:** Apple App Store / Google Play tarafından
  sağlanan anonim indirme/çökme verileri. Bu veriler kullanıcı kimliği
  içermez.
- **Çökme raporları (opsiyonel, kullanıcı onaylarsa):** Cihaz modeli, OS
  sürümü, anonim çökme stack trace. Kişisel veri içermez; içeriyorsa redaksiyon
  uygulanır.
- **Destek talepleri:** Kullanıcının bize e-posta ile gönderdiği iletişim
  bilgisi ve mesaj içeriği.

### 3.3. Hassas / Özel Nitelikli Kişisel Veri

UYAP üzerinde dosyaya konu suç tipi, sağlık durumu, ceza geçmişi gibi özel
nitelikli kişisel veriler bulunabilir. Uygulama, **veri minimizasyonu**
ilkesi gereği yalnızca duruşma takvimi için zorunlu alanları
(tarih, saat, mahkeme, dosya no) cihaz veritabanına yazar; **özel nitelikli
kişisel verileri parse etmez ve saklamaz.**

---

## 4. İşleme Amaçları

- Kullanıcının kendi UYAP duruşma takvimini mobil cihazda görüntülemesi.
- Native cihaz takvimine duruşmaların aktarılması.
- Yaklaşan duruşmalar için lokal bildirim gönderilmesi.
- Uygulamanın güvenli ve hatasız çalışmasının sağlanması (çökme raporu
  kullanıcı onayıyla).
- Talep halinde teknik destek sağlanması.

---

## 5. Hukuki Sebepler

KVKK m.5/2 kapsamında:

- (a) **Açık rıza:** Onboarding sırasında kullanıcıdan alınan açık rıza.
- (c) **Sözleşmenin kurulması veya ifası:** Uygulamanın kullanım şartları
  çerçevesinde sunulması.
- (e) **Bir hakkın tesisi, kullanılması veya korunması:** Kullanıcının kendi
  davalarını yönetme hakkı.
- (f) **Meşru menfaat:** Çökme raporu ve teknik istikrar (kullanıcı dengeleri
  gözetilerek).

---

## 6. Aktarım

Veriler **üçüncü kişilere aktarılmaz.** Yurtdışına aktarım yoktur.

İstisna: Apple App Store / Google Play uygulama dağıtım altyapısının
kendi sağladığı anonim teknik veriler (indirme/çökme), ilgili platformların
gizlilik politikaları çerçevesinde işlenir.

---

## 7. Saklama Süresi

- Cihazdaki veriler: Kullanıcı uygulamayı silene veya "Tüm verilerimi sil"
  butonunu kullanana kadar.
- Destek e-postaları: İlgili talebin sonuçlanmasından itibaren 2 yıl.
- Çökme raporları: 90 gün.

---

## 8. Veri Sahibi Hakları (KVKK m.11)

Kullanıcı, KVKK m.11 uyarınca aşağıdaki haklara sahiptir:

a) Kişisel verisinin işlenip işlenmediğini öğrenme,
b) Kişisel verisi işlenmişse buna ilişkin bilgi talep etme,
c) Kişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp
   kullanılmadığını öğrenme,
ç) Yurt içinde veya yurt dışında kişisel verilerin aktarıldığı üçüncü kişileri
   bilme,
d) Kişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların
   düzeltilmesini isteme,
e) KVKK m.7'de öngörülen şartlar çerçevesinde kişisel verilerin silinmesini
   veya yok edilmesini isteme,
f) (d) ve (e) bentleri uyarınca yapılan işlemlerin, kişisel verilerin
   aktarıldığı üçüncü kişilere bildirilmesini isteme,
g) İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi
   suretiyle kişinin kendisi aleyhine bir sonucun ortaya çıkmasına itiraz
   etme,
ğ) Kişisel verilerin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması
   hâlinde zararın giderilmesini talep etme.

Uygulama içinde bu hakları doğrudan kullanmak için:

- **Verilerimi gör:** Ayarlar → Verilerim → "Tüm yerel verileri görüntüle"
- **Verilerimi sil:** Ayarlar → Verilerim → "Tüm verilerimi sil"
- **Verilerimi taşı:** Ayarlar → Verilerim → "XML olarak dışa aktar"

---

## 9. Başvuru Yolları

KVKK kapsamındaki taleplerinizi aşağıdaki yollarla iletebilirsiniz:

- **E-posta:** [İLETİŞİM E-POSTASI]
- **KEP:** [KEP ADRESİ]
- **Posta:** [TAM ADRES]

Başvurularınız 30 gün içinde yanıtlanır. Veri Sorumlusuna Başvuru Usul ve
Esasları Hakkında Tebliğ uyarınca başvurunuzda kimliğinizi tespite yarayan
bilgilerin bulunması gerekir.

---

## 10. Değişiklikler

Bu aydınlatma metni gerektikçe güncellenir. Önemli değişikliklerde uygulama
açılışında kullanıcıya yeniden onay sunulur. Sürüm geçmişi:

- v0.1 — [YYYY-MM-DD] — İlk taslak (geliştirme ekibi).
