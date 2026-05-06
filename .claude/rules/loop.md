# `/loop` Otonom Mod Davranışı

`/loop` argümansız (otonom) çağrıldığında uygula.

## Her İterasyonda

1. **Durum oku:** [CLAUDE.md](../../CLAUDE.md) §"Şu Anki Durum" tablosu + [README.md](../../README.md) §8 yol haritası.
2. **Bir sonraki yapılmamış adımı bul.** Sıralama: Faz 0 → 1 → 2 → ... Aynı faz içinde README'de yazılı sıra.
3. **Adımı kategorile:**
   - **Kullanıcı eylemi gerektiriyor** (Flutter SDK kur, Apple Developer hesabı aç, UYAP başvurusu yap, vb.) → adımı atla, [`.claude/rules/user-setup.md`](user-setup.md) içine işaretle, kullanıcıya bildir, sıradaki **kod** adımına geç.
   - **Salt kod/dokümantasyon** → uygula.
4. **Modeli seç** ([`models.md`](models.md)). Ağır mimari işleri için ana oturum (Opus). Standart kod yazımı için Sonnet alt-ajan. Haiku KULLANMA.
5. **İşi yap.** Kod yaz, dosyaları oluştur/değiştir.
6. **Test et.** Mümkünse `flutter analyze` + `flutter test`. Kullanıcı SDK kurmadıysa bu adım atlanır, durum CLAUDE.md'ye not düşülür.
7. **İşaretle:** README ve CLAUDE.md'de ilgili satıra `**(YAPILDI — YYYY-MM-DD)**` ekle.
8. **Commit:** workflow.md formatında.
9. **Özet ver:** Kullanıcıya 2-3 satırlık ilerleme raporu.
10. **Devam:** `ScheduleWakeup` ile bir sonraki iterasyonu planla. Eğer kullanıcı eylemi bekleniyorsa loop'u DURDUR (ScheduleWakeup çağırma).

## Durdurma Koşulları
- Faz biter (faz tamamlandı raporu).
- Kullanıcı eylemi bekleniyor (SDK kurulumu, hesap açma, vb.).
- Üst üste 2 iterasyon başarısızsa.
- README'de yapılacak iş kalmamışsa.

## Yapma
- Kullanıcı onayı olmadan büyük mimari karar değiştirme.
- Kırmızı çizgileri ihlal etme (sunucu veri tutmaz, login otomasyonu yok).
- Test atlama (sadece SDK eksikse).
- Dokümantasyon güncellemeden commit at.
