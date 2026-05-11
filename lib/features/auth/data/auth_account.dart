import 'dart:convert';

/// Uygulama içi kullanıcı hesabı modeli.
///
/// Hesap yalnızca cihazda (flutter_secure_storage içinde) tutulur;
/// hiçbir sunucuya gönderilmez.
class AuthAccount {
  const AuthAccount({
    required this.email,
    required this.displayName,
  });

  final String email;
  final String displayName;

  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
      };

  factory AuthAccount.fromJson(Map<String, dynamic> json) => AuthAccount(
        email: json['email'] as String,
        displayName: json['displayName'] as String,
      );

  String toJsonString() => jsonEncode(toJson());

  factory AuthAccount.fromJsonString(String s) =>
      AuthAccount.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  String toString() => 'AuthAccount(email: $email, displayName: $displayName)';
}
