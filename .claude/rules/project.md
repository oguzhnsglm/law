# Proje Kuralı — Vizyon ve Mimari Özet

## Ne Yapıyoruz
Türkiye'deki avukatlar için UYAP duruşma takvim asistanı. Flutter/Dart ile tek kod tabanı, iOS + Android.

## Çekirdek Mimari Kararlar
- **Cihaz tarafı WebView** ile UYAP'a erişim (`flutter_inappwebview`). Sunucu scraping YOK.
- **Yerel şifreli SQLite** (Drift + SQLCipher). Sunucuda kullanıcı verisi YOK.
- **Native takvim** (`device_calendar` — iOS EventKit / Android CalendarProvider).
- **Lokal bildirim** (`flutter_local_notifications`) — app kapalıyken de schedule edilen bildirim gelir.
- **State:** Riverpod. **Routing:** go_router.

## Hukuki Kırmızı Çizgiler
- Kullanıcı şifresi sunucuya gönderilmez, hatta sunucu MVP'de yoktur.
- UYAP login'i kullanıcı kendisi yapar (WebView içinde, kendi parmağıyla).
- Çekilen veri kullanıcının cihazını terk etmez.
- KVKK aydınlatma metni + açık rıza onboarding'de.

## Sözlük
- **UYAP:** Ulusal Yargı Ağı Projesi (T.C. Adalet Bakanlığı'nın yargı bilişim sistemi).
- **Avukat Portal:** avukatbeta.uyap.gov.tr — avukatların kendi dosyalarını gördüğü web arayüzü.
- **e-Devlet:** giris.turkiye.gov.tr — UYAP'a giriş için zorunlu kapı.
- **Faz 0/1/2/...** — README §8 yol haritası evreleri.

## Detaylı Plan
[README.md](../../README.md) — 14 bölümlük tam plan; herhangi bir mimari soru çıktığında oradan kontrol et.
