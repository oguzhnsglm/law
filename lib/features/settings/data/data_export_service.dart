import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:law/core/db/database.dart';
import 'package:law/core/db/database_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Yerel veritabanı içeriğini JSON olarak dışa aktarır.
///
/// Kullanım: kullanıcı "Verilerimi dışa aktar" butonuna basar, oluşan JSON
/// string `share_plus` veya benzeri bir mekanizma ile paylaşılır. Bu servis
/// sadece serialization yapar; paylaşma UI tarafında bağlanır.
class DataExportService {
  DataExportService(this._db);

  final AppDatabase _db;

  /// Tüm dava + duruşma + not + senkron log'larını JSON map olarak döndürür.
  Future<Map<String, dynamic>> exportAsMap() async {
    final cases = await _db.casesDao.getAll();
    final hearings = await _db.select(_db.hearings).get();
    final notes = await _db.select(_db.userNotes).get();
    final logs = await _db.select(_db.syncLogs).get();

    return <String, dynamic>{
      'exportVersion': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'cases': cases.map(_caseToMap).toList(),
      'hearings': hearings.map(_hearingToMap).toList(),
      'userNotes': notes.map(_noteToMap).toList(),
      'syncLogs': logs.map(_logToMap).toList(),
    };
  }

  Future<String> exportAsJsonString({bool pretty = true}) async {
    final map = await exportAsMap();
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(map);
    }
    return jsonEncode(map);
  }

  /// JSON içeriği temp dizinine yazıp dosya yolunu döner. Caller bu yolu
  /// `share_plus` ile paylaşabilir.
  Future<String> exportToTempFile() async {
    final json = await exportAsJsonString();
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(dir.path, 'law_export_$stamp.json'));
    await file.writeAsString(json);
    return file.path;
  }

  Map<String, dynamic> _caseToMap(Case c) => <String, dynamic>{
        'id': c.id,
        'dosyaNo': c.dosyaNo,
        'mahkemeAdi': c.mahkemeAdi,
        'mahkemeTuru': c.mahkemeTuru,
        'dosyaTuru': c.dosyaTuru,
        'taraflar': c.taraflarJson.map((p) => p.toJson()).toList(),
        'durum': c.durum,
        'sonIslemTarihi': c.sonIslemTarihi?.toIso8601String(),
        'sonSenkronTarihi': c.sonSenkronTarihi.toIso8601String(),
      };

  Map<String, dynamic> _hearingToMap(Hearing h) => <String, dynamic>{
        'id': h.id,
        'caseId': h.caseId,
        'durusmaTarihi': h.durusmaTarihi.toIso8601String(),
        'salon': h.salon,
        'gundem': h.gundem,
        'bildirimTetiklendi': h.bildirimTetiklendi,
        'takvimEventId': h.takvimEventId,
        'sonSenkronTarihi': h.sonSenkronTarihi.toIso8601String(),
      };

  Map<String, dynamic> _noteToMap(UserNote n) => <String, dynamic>{
        'id': n.id,
        'hearingId': n.hearingId,
        'notMetni': n.notMetni,
        'olusturmaTarihi': n.olusturmaTarihi.toIso8601String(),
      };

  Map<String, dynamic> _logToMap(SyncLog l) => <String, dynamic>{
        'id': l.id,
        'baslangicZamani': l.baslangicZamani.toIso8601String(),
        'bitisZamani': l.bitisZamani?.toIso8601String(),
        'basarili': l.basarili,
        'eklenenSayi': l.eklenenSayi,
        'guncellenenSayi': l.guncellenenSayi,
        'hataMesaji': l.hataMesaji,
      };
}

final dataExportServiceProvider = Provider<DataExportService>((ref) {
  return DataExportService(ref.watch(appDatabaseProvider));
});
