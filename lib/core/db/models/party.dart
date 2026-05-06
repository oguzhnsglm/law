import 'package:json_annotation/json_annotation.dart';

part 'party.g.dart';

/// Bir dava tarafını temsil eden değer nesnesi.
///
/// [ad] tarafın adı/unvanı, [tip] tarafın rolü (ör. 'DAVACI', 'DAVALI'),
/// [vekil] varsa avukat adı.
@JsonSerializable()
class Party {
  const Party({
    required this.ad,
    required this.tip,
    this.vekil,
  });

  final String ad;
  final String tip;
  final String? vekil;

  /// JSON nesnesinden [Party] oluşturur.
  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

  /// [Party]'yi JSON nesnesine dönüştürür.
  Map<String, dynamic> toJson() => _$PartyToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Party &&
          runtimeType == other.runtimeType &&
          ad == other.ad &&
          tip == other.tip &&
          vekil == other.vekil;

  @override
  int get hashCode => Object.hash(ad, tip, vekil);

  @override
  String toString() => 'Party(ad: $ad, tip: $tip, vekil: $vekil)';
}
