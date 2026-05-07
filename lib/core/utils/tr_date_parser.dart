/// UYAP Avukat Portal'da görülen tarih/saat varyantlarını ayrıştıran
/// tolerant parser.
///
/// UYAP, tek bir kanonik formatta dönmüyor; aynı sayfada `dd.MM.yyyy HH:mm`,
/// salt tarih, ISO 8601 ve hatta Türkçe ay isimleri karışabiliyor. Bu parser
/// hepsini tek API ile çözer ve **null döner** (throw etmez) — caller
/// hatalı satırı log'layıp atlayabilsin.
///
/// Türkiye saat dilimi UTC+3 sabit (2016'dan bu yana DST yok). Parse edilen
/// "naive" DateTime'lar **yerel Türkiye saati** kabul edilir; [toUtc] true
/// ise UTC'ye çevrilerek döndürülür (DB UTC sakladığı için varsayılan).
library;

class TrDateParser {
  TrDateParser._();

  static const _months = <String, int>{
    'ocak': 1,
    'şubat': 2,
    'subat': 2,
    'mart': 3,
    'nisan': 4,
    'mayıs': 5,
    'mayis': 5,
    'haziran': 6,
    'temmuz': 7,
    'ağustos': 8,
    'agustos': 8,
    'eylül': 9,
    'eylul': 9,
    'ekim': 10,
    'kasım': 11,
    'kasim': 11,
    'aralık': 12,
    'aralik': 12,
  };

  // dd.MM.yyyy HH:mm | dd.MM.yyyy HH:mm:ss
  static final _dotDateTimeRe = RegExp(
    r'^(\d{1,2})\.(\d{1,2})\.(\d{4})(?:\s+(\d{1,2}):(\d{2})(?::(\d{2}))?)?$',
  );

  // dd/MM/yyyy HH:mm | dd-MM-yyyy HH:mm
  static final _slashDashDateTimeRe = RegExp(
    r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})(?:\s+(\d{1,2}):(\d{2})(?::(\d{2}))?)?$',
  );

  // 1 Mayıs 2026 14:30
  static final _trMonthRe = RegExp(
    r'^(\d{1,2})\s+([A-Za-zÇĞİıÖŞÜçğıöşü]+)\s+(\d{4})(?:\s+(\d{1,2}):(\d{2})(?::(\d{2}))?)?$',
  );

  /// UYAP'ta sık görülen formatları dener; başarısız olursa null.
  ///
  /// [toUtc] varsayılan true: çıktı UTC. False ise yerel (Türkiye) DateTime.
  static DateTime? parse(String? input, {bool toUtc = true}) {
    if (input == null) return null;
    final s = input.trim();
    if (s.isEmpty) return null;

    final fromCustom = _tryCustomFormats(s);
    if (fromCustom != null) {
      return toUtc ? _localTrToUtc(fromCustom) : fromCustom;
    }

    // ISO 8601 fallback (`2026-05-01T14:30`, `2026-05-01 14:30:00`, vb.)
    final iso = DateTime.tryParse(s);
    if (iso != null) {
      // ISO'da Z veya offset varsa zaten UTC; yoksa local Türkiye varsay.
      if (s.endsWith('Z') || RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(s)) {
        return toUtc ? iso.toUtc() : iso.toLocal();
      }
      return toUtc ? _localTrToUtc(iso) : iso;
    }

    return null;
  }

  static DateTime? _tryCustomFormats(String s) {
    final dot = _dotDateTimeRe.firstMatch(s);
    if (dot != null) return _buildFromMatch(dot);

    final slashDash = _slashDashDateTimeRe.firstMatch(s);
    if (slashDash != null) return _buildFromMatch(slashDash);

    final tr = _trMonthRe.firstMatch(s);
    if (tr != null) {
      final monthKey = tr.group(2)!.toLowerCase();
      final month = _months[_normalizeTr(monthKey)];
      if (month == null) return null;
      return _buildFromParts(
        day: int.parse(tr.group(1)!),
        month: month,
        year: int.parse(tr.group(3)!),
        hour: tr.group(4),
        minute: tr.group(5),
        second: tr.group(6),
      );
    }

    return null;
  }

  static DateTime? _buildFromMatch(Match m) {
    return _buildFromParts(
      day: int.parse(m.group(1)!),
      month: int.parse(m.group(2)!),
      year: int.parse(m.group(3)!),
      hour: m.group(4),
      minute: m.group(5),
      second: m.group(6),
    );
  }

  static DateTime? _buildFromParts({
    required int day,
    required int month,
    required int year,
    String? hour,
    String? minute,
    String? second,
  }) {
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;
    final h = hour != null ? int.parse(hour) : 0;
    final mi = minute != null ? int.parse(minute) : 0;
    final se = second != null ? int.parse(second) : 0;
    if (h < 0 || h > 23) return null;
    if (mi < 0 || mi > 59) return null;
    if (se < 0 || se > 59) return null;
    final result = DateTime(year, month, day, h, mi, se);
    // Defansif: 31 Şubat gibi taşma DateTime tarafından düzeltiliyor;
    // gün/ay tutarlılığını kontrol et.
    if (result.day != day || result.month != month) return null;
    return result;
  }

  /// Türkçe büyük I/i probleminin etrafından dolaş.
  static String _normalizeTr(String s) => s
      .replaceAll('İ', 'i')
      .replaceAll('I', 'ı')
      .toLowerCase();

  /// Yerel Türkiye saatini UTC'ye çevirir (sabit -3 saat).
  static DateTime _localTrToUtc(DateTime trLocal) {
    return DateTime.utc(
      trLocal.year,
      trLocal.month,
      trLocal.day,
      trLocal.hour,
      trLocal.minute,
      trLocal.second,
    ).subtract(const Duration(hours: 3));
  }
}
