import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:law/core/db/models/party.dart';

/// Drift TypeConverter: [List<Party>] ↔ JSON string.
///
/// Veritabanında tek bir TEXT sütununda saklanır.
class PartiesConverter extends TypeConverter<List<Party>, String> {
  const PartiesConverter();

  @override
  List<Party> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb) as List<dynamic>;
    return decoded
        .map((e) => Party.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String toSql(List<Party> value) =>
      jsonEncode(value.map((p) => p.toJson()).toList());
}
