# Model Seçim Rehberi

**Genel kural:** En düşük seviye **Sonnet 4.6**. Haiku **KULLANILMAZ**. Bu projede karar verme/kod kalitesi taviz vermeyeceğimiz değer.

## Görev → Model Eşlemesi

| Görev tipi | Model | Nasıl |
|---|---|---|
| Mimari karar, çapraz dosya analiz, hukuki/UX trade-off | **Opus 4.7** | Ana oturum (kullanıcıyla konuşan ben) |
| Standart kod yazımı (parser, DAO, widget, service) | **Sonnet 4.6** | `Agent({ subagent_type: "general-purpose", model: "sonnet", ... })` |
| Kod araması, dosya bulma, hızlı keşif | **Sonnet 4.6** | `Agent({ subagent_type: "Explore", model: "sonnet", ... })` |
| Implementation planı (çok dosyalı görevde) | **Opus 4.7** | `Agent({ subagent_type: "Plan", ... })` (Plan zaten Opus) |
| Doküman güncelleme, küçük edit | Ana oturum | inline |
| UYAP HTML/XML reverse-engineering | **Opus 4.7** | Ana oturum |
| Test yazımı (fixture'a göre) | **Sonnet 4.6** | Sonnet alt-ajan |

## Opus mu Sonnet Alt-Ajan mı?

**Opus (ana oturum) tut:**
- Kararın geri alınması maliyetli ise
- Mimari etkisi ileride dallanıyorsa
- Hukuki/güvenlik boyutu varsa

**Sonnet alt-ajan'a delege et:**
- Şablon iş (CRUD, model sınıfı, basit widget)
- Çıktı tek dosya/küçük sayıda dosya
- Ana oturum context'ini boğacak hacimli kod üretimi
- Paralelleştirilebilir bağımsız işler

## Token Optimizasyonu Pratiği

- Tek dosyalı parser üretimi → Sonnet alt-ajan, çıktıyı oku, gerekirse refine et.
- Çoklu dosyalı feature scaffold → Sonnet alt-ajan'a brief ver.
- Açık uçlu "ne yapmalıyız" sorusu → Opus ana oturumda kal.

## Yasak
- Haiku'ya iş atama.
- Model'i ucuzlatmak için Sonnet'in altına düşme.
