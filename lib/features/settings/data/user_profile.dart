import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Avukatın temel profil bilgileri.
///
/// Onboarding sonrasında veya Ayarlar ekranından düzenlenir. Cihaz dışına
/// çıkmaz; flutter_secure_storage'da JSON olarak saklanır.
class UserProfile extends Equatable {
  const UserProfile({
    this.ad = '',
    this.soyad = '',
    this.baroSicil = '',
    this.baroAdi = '',
  });

  final String ad;
  final String soyad;
  final String baroSicil;
  final String baroAdi;

  bool get isEmpty =>
      ad.isEmpty && soyad.isEmpty && baroSicil.isEmpty && baroAdi.isEmpty;

  String get displayName {
    final parts = [ad, soyad].where((p) => p.isNotEmpty);
    return parts.join(' ');
  }

  UserProfile copyWith({
    String? ad,
    String? soyad,
    String? baroSicil,
    String? baroAdi,
  }) {
    return UserProfile(
      ad: ad ?? this.ad,
      soyad: soyad ?? this.soyad,
      baroSicil: baroSicil ?? this.baroSicil,
      baroAdi: baroAdi ?? this.baroAdi,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ad': ad,
        'soyad': soyad,
        'baroSicil': baroSicil,
        'baroAdi': baroAdi,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        ad: json['ad'] as String? ?? '',
        soyad: json['soyad'] as String? ?? '',
        baroSicil: json['baroSicil'] as String? ?? '',
        baroAdi: json['baroAdi'] as String? ?? '',
      );

  String toJsonString() => jsonEncode(toJson());

  factory UserProfile.fromJsonString(String s) =>
      UserProfile.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  List<Object?> get props => [ad, soyad, baroSicil, baroAdi];
}
