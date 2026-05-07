import 'package:equatable/equatable.dart';
import 'package:law/core/db/database.dart';

/// UI tarafında bir duruşmayı temsil eden hafif DTO.
///
/// [Hearing] tek başına dosya bilgisi taşımadığı için (yalnızca [Hearing.caseId]
/// FK), repository katmanı dosya bilgileriyle birleştirip bu modeli üretir.
class HearingViewModel extends Equatable {
  const HearingViewModel({
    required this.hearing,
    required this.mahkemeAdi,
    this.dosyaNo,
  });

  final Hearing hearing;

  /// Bağlı dosyanın UYAP esas numarası (ör. '2025/1234'). Eşleşme yoksa null.
  final String? dosyaNo;

  /// Mahkemenin tam adı; eşleşme yoksa boş string.
  final String mahkemeAdi;

  DateTime get tarih => hearing.durusmaTarihi;

  String? get salon => hearing.salon;

  String? get gundem => hearing.gundem;

  @override
  List<Object?> get props => [hearing, dosyaNo, mahkemeAdi];
}
