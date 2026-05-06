# Component Inventory — Law

> Yeniden kullanılacak Flutter widget envanteri. Her bileşen için: amaç,
> public API (constructor parametreleri), varyantlar, kullanım yerleri,
> erişilebilirlik notları. Geliştirici bu listeden çalışır; "yeni" bir
> kart/buton yazmadan önce envantere bakar.

## Envanter Düzenleme Kuralları

- Yeni bir bileşene başlamadan önce: önce envantere bak; benzer varsa
  varyant ekle, yoksa yeni satır aç.
- Her bileşen `lib/core/widgets/` altında. Feature-spesifik (sadece bir
  ekranda) bileşenler `lib/features/<x>/widgets/` altında kalır.
- Her bileşene golden test ekle (Flutter `flutter_test` golden file).

---

## 1. Atomlar

### 1.1 `LawButton`

Birincil aksiyon butonu, M3 `FilledButton` üzerine ince bir abstraction.

```dart
LawButton({
  required String label,
  required VoidCallback? onPressed,
  IconData? icon,
  LawButtonVariant variant = LawButtonVariant.primary,
  bool loading = false,
  bool fullWidth = false,
})
```

**Varyantlar:** `primary`, `secondary`, `tonal`, `text`, `destructive`.

**Loading state:** Etiket yerine 16dp `CircularProgressIndicator`. onPressed
otomatik null olur.

**Erişilebilirlik:** Loading sırasında `Semantics(label: '$label, yükleniyor')`.

### 1.2 `LawTextField`

`TextField` etrafında ince wrapper. Hata mesajı, helper text, prefix/suffix
ikon, clear button.

```dart
LawTextField({
  required String label,
  TextEditingController? controller,
  String? helper,
  String? error,
  IconData? prefixIcon,
  bool obscure = false,
  TextInputType? keyboardType,
  void Function(String)? onChanged,
})
```

### 1.3 `LawChip`

Filtre/etiket çipi. M3 `FilterChip` ve `InputChip` üzerine.

```dart
LawChip({
  required String label,
  bool selected = false,
  VoidCallback? onTap,
  IconData? leading,
  VoidCallback? onDelete,
})
```

### 1.4 `LawBadge`

Kart üzerinde küçük rozet ("BUGÜN", "YENİ", "2 saat sonra").

```dart
LawBadge({
  required String label,
  LawBadgeColor color = LawBadgeColor.neutral, // info|success|warn|danger
  IconData? icon,
})
```

### 1.5 `LawDivider`, `LawSectionHeader`

Section başlığı + üst/alt boşluk standardı.

```dart
LawSectionHeader({ required String title, Widget? trailing })
```

---

## 2. Moleküller

### 2.1 `HearingCard`

Bir duruşmayı listede temsil eder. Ana ekran ve takvim alt listesinde
kullanılır.

```dart
HearingCard({
  required Hearing hearing,
  HearingCardLayout layout = HearingCardLayout.standard,
  VoidCallback? onTap,
})
```

**Varyantlar (`layout`):**
- `standard` — saat, mahkeme, esas no, salon
- `compact` — saat + mahkeme adı (takvim alt listesinde)
- `featured` — bugünkü ilk duruşma için, "X saat sonra" rozetli

**İçerik:**
```
[saat]   [icon]  ← üst sol/sağ
[mahkeme adı]    ← titleMedium
[esas no]        ← bodySmall
[salon]          ← bodySmall
[rozet]          ← duruma göre
```

**Tıklama:** Duruşma detay ekranı.

### 2.2 `CaseListTile`

Dosya listesindeki bir dosyayı temsil eder.

```dart
CaseListTile({
  required Case caseModel,
  Hearing? nextHearing,
  VoidCallback? onTap,
})
```

**İçerik:** Esas no, mahkeme, taraflar (kısa), sonraki duruşma tarihi
(varsa).

### 2.3 `SyncStatusBanner`

Ana ekranın üstünde "X dakika önce senkron edildi" bilgisi. Tıklanırsa
manuel senkron başlar.

```dart
SyncStatusBanner({
  required SyncState state, // idle|syncing|error|success
  required DateTime? lastSync,
  VoidCallback? onTap,
})
```

**Varyantlar:**
- `idle`: gri bilgi banner
- `syncing`: spinner + "Senkronize ediliyor"
- `error`: kırmızı + "Tekrar Dene" butonu
- `success`: yeşil, otomatik 3 sn sonra kaybolur

### 2.4 `EmptyState`

Boş liste/sonuç gösterimleri.

```dart
EmptyState({
  required IconData icon,
  required String title,
  String? message,
  Widget? action, // genelde LawButton
})
```

**Önceden tanımlı varyantlar:** `noHearingsToday`, `noCasesFound`,
`noSearchResult`, `noNotes`.

### 2.5 `PermissionCard`

Onboarding ve ayarlarda kullanılan izin isteme kartı.

```dart
PermissionCard({
  required IconData icon,
  required String title,
  required String description,
  required PermissionStatus status,
  required VoidCallback onRequest,
})
```

**Status'a göre buton:** `notRequested` → "İzin Ver", `denied` → "Ayarlardan
Aç", `granted` → ✓ ikon (buton yok).

### 2.6 `ConsentCheckbox`

KVKK gibi rıza checkbox'ları.

```dart
ConsentCheckbox({
  required String label,
  required bool value,
  required ValueChanged<bool> onChanged,
  Widget? trailing, // "Metni oku" link
})
```

---

## 3. Organizmalar

### 3.1 `OnboardingScaffold`

3 sayfa onboarding için ortak iskelet (sayfa noktası, alt buton, "Atla"
linki).

```dart
OnboardingScaffold({
  required int currentStep,    // 0..2
  required int totalSteps,     // 3
  required Widget child,
  required String primaryLabel,
  required VoidCallback? onPrimary, // disabled için null
  VoidCallback? onSkip,
})
```

### 3.2 `CalendarView`

Aylık takvim grid'i. Duruşma olan günleri renkli noktayla işaretler.

```dart
CalendarView({
  required DateTime focusedMonth,
  required DateTime selectedDay,
  required Map<DateTime, int> hearingCountByDay,
  required ValueChanged<DateTime> onDaySelected,
  ValueChanged<DateTime>? onMonthChanged,
})
```

**Üçüncü parti tercih:** `table_calendar` paketi yeterli, custom yapma.
Sadece `calendarBuilders` ile dot rendering kustomize edilir.

### 3.3 `HearingDetailScaffold`

Duruşma detay sayfasının iskeleti. Üst alanda büyük tarih/saat,
ortada bilgiler, altta hatırlatma listesi.

### 3.4 `CaseDetailScaffold`

Dosya detay sayfasının iskeleti (üst başlık, taraflar, expandable
duruşma listeleri, notlar).

### 3.5 `WebViewSyncShell`

WebView ekranının iskeleti — alt info bar + iptal butonu + URL bar gizli.

```dart
WebViewSyncShell({
  required String initialUrl,
  required ValueChanged<UyapSession> onLoginDetected,
  required VoidCallback onCancel,
})
```

---

## 4. Şablonlar (Templates)

### 4.1 `LawScaffold`

Ana ekran iskeletleri için ortak Scaffold. AppBar standardı, BottomNav
opsiyonu, FAB opsiyonu.

```dart
LawScaffold({
  required String title,
  Widget? subtitle,
  required Widget body,
  List<Widget>? actions,
  Widget? bottomNavigationBar,
  Widget? floatingActionButton,
})
```

### 4.2 `BottomTabBar`

4 sekmeli BottomNav. (Ana ekran şablonunun bir parçası.)

```dart
BottomTabBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
})
```

Sekmeler sabit: Bugün, Takvim, Dosyalar, Ayarlar.

---

## 5. Yardımcı Bileşenler

### 5.1 `LawDialog`

Confirmation/info dialog wrapper. M3 `AlertDialog` üzerinde tutarlı padding/
buton sırası.

```dart
LawDialog.confirm({
  required String title,
  required String message,
  String confirmLabel = 'Onayla',
  String cancelLabel = 'İptal',
  bool destructive = false,
})
```

### 5.2 `LawSnackbar`

Toast/snackbar wrapper. Renk + ikon `LawSnackbarType`'a göre.

```dart
LawSnackbar.show(context, {
  required String message,
  LawSnackbarType type = LawSnackbarType.info, // info|success|warn|error
  SnackBarAction? action,
});
```

### 5.3 `LawBottomSheet`

Modal bottom sheet wrapper. Drag handle + standard padding.

```dart
LawBottomSheet.show(context, {
  required String title,
  required Widget child,
});
```

---

## 6. Bileşen Bağımlılık Haritası

```
LawScaffold
  ├─ AppBar (M3)
  └─ BottomTabBar
      └─ NavigationDestination (M3)

HearingCard ──► LawBadge
            ──► LawDivider

CaseListTile ──► HearingCard (compact)

SyncStatusBanner ──► LawButton (text)

OnboardingScaffold ──► LawButton
                  ──► PageIndicator (M3)

CalendarView ──► (table_calendar)

WebViewSyncShell ──► LawButton (text "İptal")
```

---

## 7. Henüz Yapılmamış / Sonraya Bırakılan

- `HearingTimelineView` (yatay timeline) — Faz 5+
- `MultiSelectChip` (toplu seçim) — Faz 5+
- `ExportProgressDialog` — XML export geldiğinde

Bu envanter Faz 1-4 boyunca canlı tutulur; her yeni widget eklendikçe
satır eklenir.
