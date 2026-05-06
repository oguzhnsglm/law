# Kullanıcının Yapması Gereken Kurulumlar

Bu görevler sadece kullanıcı (insan) tarafından yapılabilir; loop bunları atlar ve burada işaretler.

## Hemen Şimdi (Faz 1'e başlamadan önce)

- [x] **Flutter SDK 3.41.9** — `C:\Users\ugras\flutter`, PATH'e eklendi **(YAPILDI — 2026-05-06, asistan kurdu)**
- [x] **JDK 17 (Microsoft OpenJDK)** — winget ile kuruldu **(YAPILDI — 2026-05-06, asistan kurdu)**
  - JAVA_HOME ayarı kullanıcı yapacak (yeni terminalde PATH yenilenince)
- [ ] **Android Studio + Android SDK 34** — winget kurulumu başlatıldı (`busw4wn2t`), kullanıcı UAC onayı verecek; alternatif: kullanıcı kendi kurar
- [ ] **Android SDK Manager içinden**: API 34 Platform + Build-Tools + Emulator + Platform-Tools
- [ ] **`flutter doctor --android-licenses`** — tüm lisansları kabul et
- [ ] **`flutter doctor -v`** — tüm satırlar ✅ olmalı (Flutter, Android toolchain)
- [ ] **VS Code + Flutter eklentisi** (tercih)
- [ ] **Git config (kullanıcı adı + email)** — `git config --global user.name/user.email`
- [ ] **GitHub remote auth** — `gh auth login` veya PAT
- [ ] **İlk push** — `git push -u origin main`

## iOS Build İçin (sadece Mac sahibiyseniz)

- [ ] Xcode + Command Line Tools
- [ ] CocoaPods (`sudo gem install cocoapods`)
- [ ] Apple Developer Program ($99/yıl) — TestFlight ve App Store için

## Hesaplar (Faz 5'e kadar zaman var)

- [ ] **Apple Developer hesabı** ($99/yıl)
- [ ] **Google Play Developer hesabı** ($25 tek seferlik)
- [ ] **Domain** — kurumsal mail + sözleşme adresi için
- [ ] **Sentry / Firebase** projesi (crash analytics, opsiyonel)

## Tüzel ve Hukuki

- [ ] **Limited şirket kuruluşu** (uygulamayı yayınlayacak tüzel kişilik)
- [ ] **VERBİS kaydı** (sunucu yoksa minimum kapsam — bilişim hukukçusuyla netleştir)
- [ ] **Bilişim hukuku danışmanlığı** (KVKK aydınlatma metni + UYAP TOS yorumu)
- [ ] **UYAP Avukat Web Servisleri başvurusu** — `bilgiislem@adalet.gov.tr`

## Test İçin

- [ ] **Bir avukatın yardımı** — UYAP Avukat Portal'a girip Chrome DevTools Network sekmesi açık şekilde dosya/duruşma sayfalarını gez, .HAR dosyası kaydet → projeye fixture olarak gelecek
- [ ] **2-3 anonim örnek XML** UYAP'ın "Dosyalarım → XML export"undan
- [ ] Beta için 5-10 avukat tanıdık

## Tamamlananlar

(boş — kullanıcı yaptıkça `**(YAPILDI — tarih)**` etiketi ile buraya taşı)
