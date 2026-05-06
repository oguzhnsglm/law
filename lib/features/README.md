# features/

Her feature kendi içinde data + domain + presentation katmanlarını barındırır. Feature'lar birbirine doğrudan bağımlı OLMAMALIDIR — paylaşılan kod `lib/core/` veya `lib/shared/` altına çıkar.

- `onboarding/` — Hoş geldin, KVKK rıza, izinler
- `auth/` — Yerel kullanıcı profili, baro sicil, KVKK rıza durumu
- `sync/` — UYAP senkron motoru: WebView orkestrasyonu, parse, idempotent merge
- `cases/` — Dosya listesi/detay
- `hearings/` — Duruşma listesi/detay/takvim
- `notifications/` — Lokal bildirim schedule, ayarlar
- `settings/` — Genel ayarlar, veri silme, dışa aktarma
