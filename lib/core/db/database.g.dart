// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CasesTable extends Cases with TableInfo<$CasesTable, Case> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dosyaNoMeta = const VerificationMeta(
    'dosyaNo',
  );
  @override
  late final GeneratedColumn<String> dosyaNo = GeneratedColumn<String>(
    'dosya_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _mahkemeAdiMeta = const VerificationMeta(
    'mahkemeAdi',
  );
  @override
  late final GeneratedColumn<String> mahkemeAdi = GeneratedColumn<String>(
    'mahkeme_adi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mahkemeTuruMeta = const VerificationMeta(
    'mahkemeTuru',
  );
  @override
  late final GeneratedColumn<String> mahkemeTuru = GeneratedColumn<String>(
    'mahkeme_turu',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dosyaTuruMeta = const VerificationMeta(
    'dosyaTuru',
  );
  @override
  late final GeneratedColumn<String> dosyaTuru = GeneratedColumn<String>(
    'dosya_turu',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Party>, String>
  taraflarJson = GeneratedColumn<String>(
    'taraflar_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<Party>>($CasesTable.$convertertaraflarJson);
  static const VerificationMeta _durumMeta = const VerificationMeta('durum');
  @override
  late final GeneratedColumn<String> durum = GeneratedColumn<String>(
    'durum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sonIslemTarihiMeta = const VerificationMeta(
    'sonIslemTarihi',
  );
  @override
  late final GeneratedColumn<DateTime> sonIslemTarihi =
      GeneratedColumn<DateTime>(
        'son_islem_tarihi',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sonSenkronTarihiMeta = const VerificationMeta(
    'sonSenkronTarihi',
  );
  @override
  late final GeneratedColumn<DateTime> sonSenkronTarihi =
      GeneratedColumn<DateTime>(
        'son_senkron_tarihi',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dosyaNo,
    mahkemeAdi,
    mahkemeTuru,
    dosyaTuru,
    taraflarJson,
    durum,
    sonIslemTarihi,
    sonSenkronTarihi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Case> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dosya_no')) {
      context.handle(
        _dosyaNoMeta,
        dosyaNo.isAcceptableOrUnknown(data['dosya_no']!, _dosyaNoMeta),
      );
    } else if (isInserting) {
      context.missing(_dosyaNoMeta);
    }
    if (data.containsKey('mahkeme_adi')) {
      context.handle(
        _mahkemeAdiMeta,
        mahkemeAdi.isAcceptableOrUnknown(data['mahkeme_adi']!, _mahkemeAdiMeta),
      );
    } else if (isInserting) {
      context.missing(_mahkemeAdiMeta);
    }
    if (data.containsKey('mahkeme_turu')) {
      context.handle(
        _mahkemeTuruMeta,
        mahkemeTuru.isAcceptableOrUnknown(
          data['mahkeme_turu']!,
          _mahkemeTuruMeta,
        ),
      );
    }
    if (data.containsKey('dosya_turu')) {
      context.handle(
        _dosyaTuruMeta,
        dosyaTuru.isAcceptableOrUnknown(data['dosya_turu']!, _dosyaTuruMeta),
      );
    }
    if (data.containsKey('durum')) {
      context.handle(
        _durumMeta,
        durum.isAcceptableOrUnknown(data['durum']!, _durumMeta),
      );
    }
    if (data.containsKey('son_islem_tarihi')) {
      context.handle(
        _sonIslemTarihiMeta,
        sonIslemTarihi.isAcceptableOrUnknown(
          data['son_islem_tarihi']!,
          _sonIslemTarihiMeta,
        ),
      );
    }
    if (data.containsKey('son_senkron_tarihi')) {
      context.handle(
        _sonSenkronTarihiMeta,
        sonSenkronTarihi.isAcceptableOrUnknown(
          data['son_senkron_tarihi']!,
          _sonSenkronTarihiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sonSenkronTarihiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Case map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Case(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dosyaNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosya_no'],
      )!,
      mahkemeAdi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mahkeme_adi'],
      )!,
      mahkemeTuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mahkeme_turu'],
      ),
      dosyaTuru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosya_turu'],
      ),
      taraflarJson: $CasesTable.$convertertaraflarJson.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}taraflar_json'],
        )!,
      ),
      durum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}durum'],
      ),
      sonIslemTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}son_islem_tarihi'],
      ),
      sonSenkronTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}son_senkron_tarihi'],
      )!,
    );
  }

  @override
  $CasesTable createAlias(String alias) {
    return $CasesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Party>, String> $convertertaraflarJson =
      const PartiesConverter();
}

class Case extends DataClass implements Insertable<Case> {
  final int id;

  /// UYAP'taki benzersiz dosya numarası. Upsert işlemlerinde anahtar olarak kullanılır.
  final String dosyaNo;

  /// Mahkemenin tam adı (ör. 'İstanbul 1. Asliye Hukuk Mahkemesi').
  final String mahkemeAdi;

  /// Mahkeme türü (ör. 'Asliye Hukuk', 'İdare').
  final String? mahkemeTuru;

  /// Dava türü (ör. 'Hukuk Davası').
  final String? dosyaTuru;

  /// JSON olarak kodlanmış [Party] listesi.
  final List<Party> taraflarJson;

  /// Davanın güncel durumu.
  final String? durum;

  /// UYAP'ta kayıtlı son işlem tarihi.
  final DateTime? sonIslemTarihi;

  /// Bu kaydın son senkronizasyon tarihi.
  final DateTime sonSenkronTarihi;
  const Case({
    required this.id,
    required this.dosyaNo,
    required this.mahkemeAdi,
    this.mahkemeTuru,
    this.dosyaTuru,
    required this.taraflarJson,
    this.durum,
    this.sonIslemTarihi,
    required this.sonSenkronTarihi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dosya_no'] = Variable<String>(dosyaNo);
    map['mahkeme_adi'] = Variable<String>(mahkemeAdi);
    if (!nullToAbsent || mahkemeTuru != null) {
      map['mahkeme_turu'] = Variable<String>(mahkemeTuru);
    }
    if (!nullToAbsent || dosyaTuru != null) {
      map['dosya_turu'] = Variable<String>(dosyaTuru);
    }
    {
      map['taraflar_json'] = Variable<String>(
        $CasesTable.$convertertaraflarJson.toSql(taraflarJson),
      );
    }
    if (!nullToAbsent || durum != null) {
      map['durum'] = Variable<String>(durum);
    }
    if (!nullToAbsent || sonIslemTarihi != null) {
      map['son_islem_tarihi'] = Variable<DateTime>(sonIslemTarihi);
    }
    map['son_senkron_tarihi'] = Variable<DateTime>(sonSenkronTarihi);
    return map;
  }

  CasesCompanion toCompanion(bool nullToAbsent) {
    return CasesCompanion(
      id: Value(id),
      dosyaNo: Value(dosyaNo),
      mahkemeAdi: Value(mahkemeAdi),
      mahkemeTuru: mahkemeTuru == null && nullToAbsent
          ? const Value.absent()
          : Value(mahkemeTuru),
      dosyaTuru: dosyaTuru == null && nullToAbsent
          ? const Value.absent()
          : Value(dosyaTuru),
      taraflarJson: Value(taraflarJson),
      durum: durum == null && nullToAbsent
          ? const Value.absent()
          : Value(durum),
      sonIslemTarihi: sonIslemTarihi == null && nullToAbsent
          ? const Value.absent()
          : Value(sonIslemTarihi),
      sonSenkronTarihi: Value(sonSenkronTarihi),
    );
  }

  factory Case.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Case(
      id: serializer.fromJson<int>(json['id']),
      dosyaNo: serializer.fromJson<String>(json['dosyaNo']),
      mahkemeAdi: serializer.fromJson<String>(json['mahkemeAdi']),
      mahkemeTuru: serializer.fromJson<String?>(json['mahkemeTuru']),
      dosyaTuru: serializer.fromJson<String?>(json['dosyaTuru']),
      taraflarJson: serializer.fromJson<List<Party>>(json['taraflarJson']),
      durum: serializer.fromJson<String?>(json['durum']),
      sonIslemTarihi: serializer.fromJson<DateTime?>(json['sonIslemTarihi']),
      sonSenkronTarihi: serializer.fromJson<DateTime>(json['sonSenkronTarihi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dosyaNo': serializer.toJson<String>(dosyaNo),
      'mahkemeAdi': serializer.toJson<String>(mahkemeAdi),
      'mahkemeTuru': serializer.toJson<String?>(mahkemeTuru),
      'dosyaTuru': serializer.toJson<String?>(dosyaTuru),
      'taraflarJson': serializer.toJson<List<Party>>(taraflarJson),
      'durum': serializer.toJson<String?>(durum),
      'sonIslemTarihi': serializer.toJson<DateTime?>(sonIslemTarihi),
      'sonSenkronTarihi': serializer.toJson<DateTime>(sonSenkronTarihi),
    };
  }

  Case copyWith({
    int? id,
    String? dosyaNo,
    String? mahkemeAdi,
    Value<String?> mahkemeTuru = const Value.absent(),
    Value<String?> dosyaTuru = const Value.absent(),
    List<Party>? taraflarJson,
    Value<String?> durum = const Value.absent(),
    Value<DateTime?> sonIslemTarihi = const Value.absent(),
    DateTime? sonSenkronTarihi,
  }) => Case(
    id: id ?? this.id,
    dosyaNo: dosyaNo ?? this.dosyaNo,
    mahkemeAdi: mahkemeAdi ?? this.mahkemeAdi,
    mahkemeTuru: mahkemeTuru.present ? mahkemeTuru.value : this.mahkemeTuru,
    dosyaTuru: dosyaTuru.present ? dosyaTuru.value : this.dosyaTuru,
    taraflarJson: taraflarJson ?? this.taraflarJson,
    durum: durum.present ? durum.value : this.durum,
    sonIslemTarihi: sonIslemTarihi.present
        ? sonIslemTarihi.value
        : this.sonIslemTarihi,
    sonSenkronTarihi: sonSenkronTarihi ?? this.sonSenkronTarihi,
  );
  Case copyWithCompanion(CasesCompanion data) {
    return Case(
      id: data.id.present ? data.id.value : this.id,
      dosyaNo: data.dosyaNo.present ? data.dosyaNo.value : this.dosyaNo,
      mahkemeAdi: data.mahkemeAdi.present
          ? data.mahkemeAdi.value
          : this.mahkemeAdi,
      mahkemeTuru: data.mahkemeTuru.present
          ? data.mahkemeTuru.value
          : this.mahkemeTuru,
      dosyaTuru: data.dosyaTuru.present ? data.dosyaTuru.value : this.dosyaTuru,
      taraflarJson: data.taraflarJson.present
          ? data.taraflarJson.value
          : this.taraflarJson,
      durum: data.durum.present ? data.durum.value : this.durum,
      sonIslemTarihi: data.sonIslemTarihi.present
          ? data.sonIslemTarihi.value
          : this.sonIslemTarihi,
      sonSenkronTarihi: data.sonSenkronTarihi.present
          ? data.sonSenkronTarihi.value
          : this.sonSenkronTarihi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Case(')
          ..write('id: $id, ')
          ..write('dosyaNo: $dosyaNo, ')
          ..write('mahkemeAdi: $mahkemeAdi, ')
          ..write('mahkemeTuru: $mahkemeTuru, ')
          ..write('dosyaTuru: $dosyaTuru, ')
          ..write('taraflarJson: $taraflarJson, ')
          ..write('durum: $durum, ')
          ..write('sonIslemTarihi: $sonIslemTarihi, ')
          ..write('sonSenkronTarihi: $sonSenkronTarihi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dosyaNo,
    mahkemeAdi,
    mahkemeTuru,
    dosyaTuru,
    taraflarJson,
    durum,
    sonIslemTarihi,
    sonSenkronTarihi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Case &&
          other.id == this.id &&
          other.dosyaNo == this.dosyaNo &&
          other.mahkemeAdi == this.mahkemeAdi &&
          other.mahkemeTuru == this.mahkemeTuru &&
          other.dosyaTuru == this.dosyaTuru &&
          other.taraflarJson == this.taraflarJson &&
          other.durum == this.durum &&
          other.sonIslemTarihi == this.sonIslemTarihi &&
          other.sonSenkronTarihi == this.sonSenkronTarihi);
}

class CasesCompanion extends UpdateCompanion<Case> {
  final Value<int> id;
  final Value<String> dosyaNo;
  final Value<String> mahkemeAdi;
  final Value<String?> mahkemeTuru;
  final Value<String?> dosyaTuru;
  final Value<List<Party>> taraflarJson;
  final Value<String?> durum;
  final Value<DateTime?> sonIslemTarihi;
  final Value<DateTime> sonSenkronTarihi;
  const CasesCompanion({
    this.id = const Value.absent(),
    this.dosyaNo = const Value.absent(),
    this.mahkemeAdi = const Value.absent(),
    this.mahkemeTuru = const Value.absent(),
    this.dosyaTuru = const Value.absent(),
    this.taraflarJson = const Value.absent(),
    this.durum = const Value.absent(),
    this.sonIslemTarihi = const Value.absent(),
    this.sonSenkronTarihi = const Value.absent(),
  });
  CasesCompanion.insert({
    this.id = const Value.absent(),
    required String dosyaNo,
    required String mahkemeAdi,
    this.mahkemeTuru = const Value.absent(),
    this.dosyaTuru = const Value.absent(),
    this.taraflarJson = const Value.absent(),
    this.durum = const Value.absent(),
    this.sonIslemTarihi = const Value.absent(),
    required DateTime sonSenkronTarihi,
  }) : dosyaNo = Value(dosyaNo),
       mahkemeAdi = Value(mahkemeAdi),
       sonSenkronTarihi = Value(sonSenkronTarihi);
  static Insertable<Case> custom({
    Expression<int>? id,
    Expression<String>? dosyaNo,
    Expression<String>? mahkemeAdi,
    Expression<String>? mahkemeTuru,
    Expression<String>? dosyaTuru,
    Expression<String>? taraflarJson,
    Expression<String>? durum,
    Expression<DateTime>? sonIslemTarihi,
    Expression<DateTime>? sonSenkronTarihi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dosyaNo != null) 'dosya_no': dosyaNo,
      if (mahkemeAdi != null) 'mahkeme_adi': mahkemeAdi,
      if (mahkemeTuru != null) 'mahkeme_turu': mahkemeTuru,
      if (dosyaTuru != null) 'dosya_turu': dosyaTuru,
      if (taraflarJson != null) 'taraflar_json': taraflarJson,
      if (durum != null) 'durum': durum,
      if (sonIslemTarihi != null) 'son_islem_tarihi': sonIslemTarihi,
      if (sonSenkronTarihi != null) 'son_senkron_tarihi': sonSenkronTarihi,
    });
  }

  CasesCompanion copyWith({
    Value<int>? id,
    Value<String>? dosyaNo,
    Value<String>? mahkemeAdi,
    Value<String?>? mahkemeTuru,
    Value<String?>? dosyaTuru,
    Value<List<Party>>? taraflarJson,
    Value<String?>? durum,
    Value<DateTime?>? sonIslemTarihi,
    Value<DateTime>? sonSenkronTarihi,
  }) {
    return CasesCompanion(
      id: id ?? this.id,
      dosyaNo: dosyaNo ?? this.dosyaNo,
      mahkemeAdi: mahkemeAdi ?? this.mahkemeAdi,
      mahkemeTuru: mahkemeTuru ?? this.mahkemeTuru,
      dosyaTuru: dosyaTuru ?? this.dosyaTuru,
      taraflarJson: taraflarJson ?? this.taraflarJson,
      durum: durum ?? this.durum,
      sonIslemTarihi: sonIslemTarihi ?? this.sonIslemTarihi,
      sonSenkronTarihi: sonSenkronTarihi ?? this.sonSenkronTarihi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dosyaNo.present) {
      map['dosya_no'] = Variable<String>(dosyaNo.value);
    }
    if (mahkemeAdi.present) {
      map['mahkeme_adi'] = Variable<String>(mahkemeAdi.value);
    }
    if (mahkemeTuru.present) {
      map['mahkeme_turu'] = Variable<String>(mahkemeTuru.value);
    }
    if (dosyaTuru.present) {
      map['dosya_turu'] = Variable<String>(dosyaTuru.value);
    }
    if (taraflarJson.present) {
      map['taraflar_json'] = Variable<String>(
        $CasesTable.$convertertaraflarJson.toSql(taraflarJson.value),
      );
    }
    if (durum.present) {
      map['durum'] = Variable<String>(durum.value);
    }
    if (sonIslemTarihi.present) {
      map['son_islem_tarihi'] = Variable<DateTime>(sonIslemTarihi.value);
    }
    if (sonSenkronTarihi.present) {
      map['son_senkron_tarihi'] = Variable<DateTime>(sonSenkronTarihi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CasesCompanion(')
          ..write('id: $id, ')
          ..write('dosyaNo: $dosyaNo, ')
          ..write('mahkemeAdi: $mahkemeAdi, ')
          ..write('mahkemeTuru: $mahkemeTuru, ')
          ..write('dosyaTuru: $dosyaTuru, ')
          ..write('taraflarJson: $taraflarJson, ')
          ..write('durum: $durum, ')
          ..write('sonIslemTarihi: $sonIslemTarihi, ')
          ..write('sonSenkronTarihi: $sonSenkronTarihi')
          ..write(')'))
        .toString();
  }
}

class $HearingsTable extends Hearings with TableInfo<$HearingsTable, Hearing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HearingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _durusmaTarihiMeta = const VerificationMeta(
    'durusmaTarihi',
  );
  @override
  late final GeneratedColumn<DateTime> durusmaTarihi =
      GeneratedColumn<DateTime>(
        'durusma_tarihi',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _salonMeta = const VerificationMeta('salon');
  @override
  late final GeneratedColumn<String> salon = GeneratedColumn<String>(
    'salon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gundemMeta = const VerificationMeta('gundem');
  @override
  late final GeneratedColumn<String> gundem = GeneratedColumn<String>(
    'gundem',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bildirimTetiklendiMeta =
      const VerificationMeta('bildirimTetiklendi');
  @override
  late final GeneratedColumn<bool> bildirimTetiklendi = GeneratedColumn<bool>(
    'bildirim_tetiklendi',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bildirim_tetiklendi" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _takvimEventIdMeta = const VerificationMeta(
    'takvimEventId',
  );
  @override
  late final GeneratedColumn<String> takvimEventId = GeneratedColumn<String>(
    'takvim_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sonSenkronTarihiMeta = const VerificationMeta(
    'sonSenkronTarihi',
  );
  @override
  late final GeneratedColumn<DateTime> sonSenkronTarihi =
      GeneratedColumn<DateTime>(
        'son_senkron_tarihi',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    durusmaTarihi,
    salon,
    gundem,
    bildirimTetiklendi,
    takvimEventId,
    sonSenkronTarihi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hearings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hearing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('durusma_tarihi')) {
      context.handle(
        _durusmaTarihiMeta,
        durusmaTarihi.isAcceptableOrUnknown(
          data['durusma_tarihi']!,
          _durusmaTarihiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durusmaTarihiMeta);
    }
    if (data.containsKey('salon')) {
      context.handle(
        _salonMeta,
        salon.isAcceptableOrUnknown(data['salon']!, _salonMeta),
      );
    }
    if (data.containsKey('gundem')) {
      context.handle(
        _gundemMeta,
        gundem.isAcceptableOrUnknown(data['gundem']!, _gundemMeta),
      );
    }
    if (data.containsKey('bildirim_tetiklendi')) {
      context.handle(
        _bildirimTetiklendiMeta,
        bildirimTetiklendi.isAcceptableOrUnknown(
          data['bildirim_tetiklendi']!,
          _bildirimTetiklendiMeta,
        ),
      );
    }
    if (data.containsKey('takvim_event_id')) {
      context.handle(
        _takvimEventIdMeta,
        takvimEventId.isAcceptableOrUnknown(
          data['takvim_event_id']!,
          _takvimEventIdMeta,
        ),
      );
    }
    if (data.containsKey('son_senkron_tarihi')) {
      context.handle(
        _sonSenkronTarihiMeta,
        sonSenkronTarihi.isAcceptableOrUnknown(
          data['son_senkron_tarihi']!,
          _sonSenkronTarihiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sonSenkronTarihiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {caseId, durusmaTarihi},
  ];
  @override
  Hearing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hearing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      durusmaTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}durusma_tarihi'],
      )!,
      salon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salon'],
      ),
      gundem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gundem'],
      ),
      bildirimTetiklendi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bildirim_tetiklendi'],
      )!,
      takvimEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}takvim_event_id'],
      ),
      sonSenkronTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}son_senkron_tarihi'],
      )!,
    );
  }

  @override
  $HearingsTable createAlias(String alias) {
    return $HearingsTable(attachedDatabase, alias);
  }
}

class Hearing extends DataClass implements Insertable<Hearing> {
  final int id;

  /// Bağlı dava kimliği. Dava silindiğinde duruşmalar da silinir (CASCADE).
  final int caseId;

  /// Duruşmanın UTC tarihi ve saati.
  final DateTime durusmaTarihi;

  /// Duruşmanın yapılacağı salon.
  final String? salon;

  /// Duruşma gündemi.
  final String? gundem;

  /// Yerel bildirim bu duruşma için tetiklendi mi?
  final bool bildirimTetiklendi;

  /// Native takvimde oluşturulan event ID'si.
  final String? takvimEventId;

  /// Bu kaydın son senkronizasyon tarihi.
  final DateTime sonSenkronTarihi;
  const Hearing({
    required this.id,
    required this.caseId,
    required this.durusmaTarihi,
    this.salon,
    this.gundem,
    required this.bildirimTetiklendi,
    this.takvimEventId,
    required this.sonSenkronTarihi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    map['durusma_tarihi'] = Variable<DateTime>(durusmaTarihi);
    if (!nullToAbsent || salon != null) {
      map['salon'] = Variable<String>(salon);
    }
    if (!nullToAbsent || gundem != null) {
      map['gundem'] = Variable<String>(gundem);
    }
    map['bildirim_tetiklendi'] = Variable<bool>(bildirimTetiklendi);
    if (!nullToAbsent || takvimEventId != null) {
      map['takvim_event_id'] = Variable<String>(takvimEventId);
    }
    map['son_senkron_tarihi'] = Variable<DateTime>(sonSenkronTarihi);
    return map;
  }

  HearingsCompanion toCompanion(bool nullToAbsent) {
    return HearingsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      durusmaTarihi: Value(durusmaTarihi),
      salon: salon == null && nullToAbsent
          ? const Value.absent()
          : Value(salon),
      gundem: gundem == null && nullToAbsent
          ? const Value.absent()
          : Value(gundem),
      bildirimTetiklendi: Value(bildirimTetiklendi),
      takvimEventId: takvimEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(takvimEventId),
      sonSenkronTarihi: Value(sonSenkronTarihi),
    );
  }

  factory Hearing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hearing(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      durusmaTarihi: serializer.fromJson<DateTime>(json['durusmaTarihi']),
      salon: serializer.fromJson<String?>(json['salon']),
      gundem: serializer.fromJson<String?>(json['gundem']),
      bildirimTetiklendi: serializer.fromJson<bool>(json['bildirimTetiklendi']),
      takvimEventId: serializer.fromJson<String?>(json['takvimEventId']),
      sonSenkronTarihi: serializer.fromJson<DateTime>(json['sonSenkronTarihi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'durusmaTarihi': serializer.toJson<DateTime>(durusmaTarihi),
      'salon': serializer.toJson<String?>(salon),
      'gundem': serializer.toJson<String?>(gundem),
      'bildirimTetiklendi': serializer.toJson<bool>(bildirimTetiklendi),
      'takvimEventId': serializer.toJson<String?>(takvimEventId),
      'sonSenkronTarihi': serializer.toJson<DateTime>(sonSenkronTarihi),
    };
  }

  Hearing copyWith({
    int? id,
    int? caseId,
    DateTime? durusmaTarihi,
    Value<String?> salon = const Value.absent(),
    Value<String?> gundem = const Value.absent(),
    bool? bildirimTetiklendi,
    Value<String?> takvimEventId = const Value.absent(),
    DateTime? sonSenkronTarihi,
  }) => Hearing(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    durusmaTarihi: durusmaTarihi ?? this.durusmaTarihi,
    salon: salon.present ? salon.value : this.salon,
    gundem: gundem.present ? gundem.value : this.gundem,
    bildirimTetiklendi: bildirimTetiklendi ?? this.bildirimTetiklendi,
    takvimEventId: takvimEventId.present
        ? takvimEventId.value
        : this.takvimEventId,
    sonSenkronTarihi: sonSenkronTarihi ?? this.sonSenkronTarihi,
  );
  Hearing copyWithCompanion(HearingsCompanion data) {
    return Hearing(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      durusmaTarihi: data.durusmaTarihi.present
          ? data.durusmaTarihi.value
          : this.durusmaTarihi,
      salon: data.salon.present ? data.salon.value : this.salon,
      gundem: data.gundem.present ? data.gundem.value : this.gundem,
      bildirimTetiklendi: data.bildirimTetiklendi.present
          ? data.bildirimTetiklendi.value
          : this.bildirimTetiklendi,
      takvimEventId: data.takvimEventId.present
          ? data.takvimEventId.value
          : this.takvimEventId,
      sonSenkronTarihi: data.sonSenkronTarihi.present
          ? data.sonSenkronTarihi.value
          : this.sonSenkronTarihi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hearing(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('durusmaTarihi: $durusmaTarihi, ')
          ..write('salon: $salon, ')
          ..write('gundem: $gundem, ')
          ..write('bildirimTetiklendi: $bildirimTetiklendi, ')
          ..write('takvimEventId: $takvimEventId, ')
          ..write('sonSenkronTarihi: $sonSenkronTarihi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    caseId,
    durusmaTarihi,
    salon,
    gundem,
    bildirimTetiklendi,
    takvimEventId,
    sonSenkronTarihi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hearing &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.durusmaTarihi == this.durusmaTarihi &&
          other.salon == this.salon &&
          other.gundem == this.gundem &&
          other.bildirimTetiklendi == this.bildirimTetiklendi &&
          other.takvimEventId == this.takvimEventId &&
          other.sonSenkronTarihi == this.sonSenkronTarihi);
}

class HearingsCompanion extends UpdateCompanion<Hearing> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<DateTime> durusmaTarihi;
  final Value<String?> salon;
  final Value<String?> gundem;
  final Value<bool> bildirimTetiklendi;
  final Value<String?> takvimEventId;
  final Value<DateTime> sonSenkronTarihi;
  const HearingsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.durusmaTarihi = const Value.absent(),
    this.salon = const Value.absent(),
    this.gundem = const Value.absent(),
    this.bildirimTetiklendi = const Value.absent(),
    this.takvimEventId = const Value.absent(),
    this.sonSenkronTarihi = const Value.absent(),
  });
  HearingsCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    required DateTime durusmaTarihi,
    this.salon = const Value.absent(),
    this.gundem = const Value.absent(),
    this.bildirimTetiklendi = const Value.absent(),
    this.takvimEventId = const Value.absent(),
    required DateTime sonSenkronTarihi,
  }) : caseId = Value(caseId),
       durusmaTarihi = Value(durusmaTarihi),
       sonSenkronTarihi = Value(sonSenkronTarihi);
  static Insertable<Hearing> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<DateTime>? durusmaTarihi,
    Expression<String>? salon,
    Expression<String>? gundem,
    Expression<bool>? bildirimTetiklendi,
    Expression<String>? takvimEventId,
    Expression<DateTime>? sonSenkronTarihi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (durusmaTarihi != null) 'durusma_tarihi': durusmaTarihi,
      if (salon != null) 'salon': salon,
      if (gundem != null) 'gundem': gundem,
      if (bildirimTetiklendi != null) 'bildirim_tetiklendi': bildirimTetiklendi,
      if (takvimEventId != null) 'takvim_event_id': takvimEventId,
      if (sonSenkronTarihi != null) 'son_senkron_tarihi': sonSenkronTarihi,
    });
  }

  HearingsCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<DateTime>? durusmaTarihi,
    Value<String?>? salon,
    Value<String?>? gundem,
    Value<bool>? bildirimTetiklendi,
    Value<String?>? takvimEventId,
    Value<DateTime>? sonSenkronTarihi,
  }) {
    return HearingsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      durusmaTarihi: durusmaTarihi ?? this.durusmaTarihi,
      salon: salon ?? this.salon,
      gundem: gundem ?? this.gundem,
      bildirimTetiklendi: bildirimTetiklendi ?? this.bildirimTetiklendi,
      takvimEventId: takvimEventId ?? this.takvimEventId,
      sonSenkronTarihi: sonSenkronTarihi ?? this.sonSenkronTarihi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (durusmaTarihi.present) {
      map['durusma_tarihi'] = Variable<DateTime>(durusmaTarihi.value);
    }
    if (salon.present) {
      map['salon'] = Variable<String>(salon.value);
    }
    if (gundem.present) {
      map['gundem'] = Variable<String>(gundem.value);
    }
    if (bildirimTetiklendi.present) {
      map['bildirim_tetiklendi'] = Variable<bool>(bildirimTetiklendi.value);
    }
    if (takvimEventId.present) {
      map['takvim_event_id'] = Variable<String>(takvimEventId.value);
    }
    if (sonSenkronTarihi.present) {
      map['son_senkron_tarihi'] = Variable<DateTime>(sonSenkronTarihi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HearingsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('durusmaTarihi: $durusmaTarihi, ')
          ..write('salon: $salon, ')
          ..write('gundem: $gundem, ')
          ..write('bildirimTetiklendi: $bildirimTetiklendi, ')
          ..write('takvimEventId: $takvimEventId, ')
          ..write('sonSenkronTarihi: $sonSenkronTarihi')
          ..write(')'))
        .toString();
  }
}

class $SyncLogsTable extends SyncLogs with TableInfo<$SyncLogsTable, SyncLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _baslangicZamaniMeta = const VerificationMeta(
    'baslangicZamani',
  );
  @override
  late final GeneratedColumn<DateTime> baslangicZamani =
      GeneratedColumn<DateTime>(
        'baslangic_zamani',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _bitisZamaniMeta = const VerificationMeta(
    'bitisZamani',
  );
  @override
  late final GeneratedColumn<DateTime> bitisZamani = GeneratedColumn<DateTime>(
    'bitis_zamani',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _basariliMeta = const VerificationMeta(
    'basarili',
  );
  @override
  late final GeneratedColumn<bool> basarili = GeneratedColumn<bool>(
    'basarili',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("basarili" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _eklenenSayiMeta = const VerificationMeta(
    'eklenenSayi',
  );
  @override
  late final GeneratedColumn<int> eklenenSayi = GeneratedColumn<int>(
    'eklenen_sayi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _guncellenenSayiMeta = const VerificationMeta(
    'guncellenenSayi',
  );
  @override
  late final GeneratedColumn<int> guncellenenSayi = GeneratedColumn<int>(
    'guncellenen_sayi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hataMesajiMeta = const VerificationMeta(
    'hataMesaji',
  );
  @override
  late final GeneratedColumn<String> hataMesaji = GeneratedColumn<String>(
    'hata_mesaji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baslangicZamani,
    bitisZamani,
    basarili,
    eklenenSayi,
    guncellenenSayi,
    hataMesaji,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baslangic_zamani')) {
      context.handle(
        _baslangicZamaniMeta,
        baslangicZamani.isAcceptableOrUnknown(
          data['baslangic_zamani']!,
          _baslangicZamaniMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baslangicZamaniMeta);
    }
    if (data.containsKey('bitis_zamani')) {
      context.handle(
        _bitisZamaniMeta,
        bitisZamani.isAcceptableOrUnknown(
          data['bitis_zamani']!,
          _bitisZamaniMeta,
        ),
      );
    }
    if (data.containsKey('basarili')) {
      context.handle(
        _basariliMeta,
        basarili.isAcceptableOrUnknown(data['basarili']!, _basariliMeta),
      );
    }
    if (data.containsKey('eklenen_sayi')) {
      context.handle(
        _eklenenSayiMeta,
        eklenenSayi.isAcceptableOrUnknown(
          data['eklenen_sayi']!,
          _eklenenSayiMeta,
        ),
      );
    }
    if (data.containsKey('guncellenen_sayi')) {
      context.handle(
        _guncellenenSayiMeta,
        guncellenenSayi.isAcceptableOrUnknown(
          data['guncellenen_sayi']!,
          _guncellenenSayiMeta,
        ),
      );
    }
    if (data.containsKey('hata_mesaji')) {
      context.handle(
        _hataMesajiMeta,
        hataMesaji.isAcceptableOrUnknown(data['hata_mesaji']!, _hataMesajiMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      baslangicZamani: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}baslangic_zamani'],
      )!,
      bitisZamani: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}bitis_zamani'],
      ),
      basarili: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}basarili'],
      )!,
      eklenenSayi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eklenen_sayi'],
      )!,
      guncellenenSayi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}guncellenen_sayi'],
      )!,
      hataMesaji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hata_mesaji'],
      ),
    );
  }

  @override
  $SyncLogsTable createAlias(String alias) {
    return $SyncLogsTable(attachedDatabase, alias);
  }
}

class SyncLog extends DataClass implements Insertable<SyncLog> {
  final int id;

  /// Senkronizasyonun başladığı zaman.
  final DateTime baslangicZamani;

  /// Senkronizasyonun tamamlandığı zaman. Henüz bitmemişse null.
  final DateTime? bitisZamani;

  /// Senkronizasyon başarılı mı tamamlandı?
  final bool basarili;

  /// Bu senkronizasyonda eklenen kayıt sayısı.
  final int eklenenSayi;

  /// Bu senkronizasyonda güncellenen kayıt sayısı.
  final int guncellenenSayi;

  /// Hata oluşmuşsa hata mesajı.
  final String? hataMesaji;
  const SyncLog({
    required this.id,
    required this.baslangicZamani,
    this.bitisZamani,
    required this.basarili,
    required this.eklenenSayi,
    required this.guncellenenSayi,
    this.hataMesaji,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baslangic_zamani'] = Variable<DateTime>(baslangicZamani);
    if (!nullToAbsent || bitisZamani != null) {
      map['bitis_zamani'] = Variable<DateTime>(bitisZamani);
    }
    map['basarili'] = Variable<bool>(basarili);
    map['eklenen_sayi'] = Variable<int>(eklenenSayi);
    map['guncellenen_sayi'] = Variable<int>(guncellenenSayi);
    if (!nullToAbsent || hataMesaji != null) {
      map['hata_mesaji'] = Variable<String>(hataMesaji);
    }
    return map;
  }

  SyncLogsCompanion toCompanion(bool nullToAbsent) {
    return SyncLogsCompanion(
      id: Value(id),
      baslangicZamani: Value(baslangicZamani),
      bitisZamani: bitisZamani == null && nullToAbsent
          ? const Value.absent()
          : Value(bitisZamani),
      basarili: Value(basarili),
      eklenenSayi: Value(eklenenSayi),
      guncellenenSayi: Value(guncellenenSayi),
      hataMesaji: hataMesaji == null && nullToAbsent
          ? const Value.absent()
          : Value(hataMesaji),
    );
  }

  factory SyncLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLog(
      id: serializer.fromJson<int>(json['id']),
      baslangicZamani: serializer.fromJson<DateTime>(json['baslangicZamani']),
      bitisZamani: serializer.fromJson<DateTime?>(json['bitisZamani']),
      basarili: serializer.fromJson<bool>(json['basarili']),
      eklenenSayi: serializer.fromJson<int>(json['eklenenSayi']),
      guncellenenSayi: serializer.fromJson<int>(json['guncellenenSayi']),
      hataMesaji: serializer.fromJson<String?>(json['hataMesaji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baslangicZamani': serializer.toJson<DateTime>(baslangicZamani),
      'bitisZamani': serializer.toJson<DateTime?>(bitisZamani),
      'basarili': serializer.toJson<bool>(basarili),
      'eklenenSayi': serializer.toJson<int>(eklenenSayi),
      'guncellenenSayi': serializer.toJson<int>(guncellenenSayi),
      'hataMesaji': serializer.toJson<String?>(hataMesaji),
    };
  }

  SyncLog copyWith({
    int? id,
    DateTime? baslangicZamani,
    Value<DateTime?> bitisZamani = const Value.absent(),
    bool? basarili,
    int? eklenenSayi,
    int? guncellenenSayi,
    Value<String?> hataMesaji = const Value.absent(),
  }) => SyncLog(
    id: id ?? this.id,
    baslangicZamani: baslangicZamani ?? this.baslangicZamani,
    bitisZamani: bitisZamani.present ? bitisZamani.value : this.bitisZamani,
    basarili: basarili ?? this.basarili,
    eklenenSayi: eklenenSayi ?? this.eklenenSayi,
    guncellenenSayi: guncellenenSayi ?? this.guncellenenSayi,
    hataMesaji: hataMesaji.present ? hataMesaji.value : this.hataMesaji,
  );
  SyncLog copyWithCompanion(SyncLogsCompanion data) {
    return SyncLog(
      id: data.id.present ? data.id.value : this.id,
      baslangicZamani: data.baslangicZamani.present
          ? data.baslangicZamani.value
          : this.baslangicZamani,
      bitisZamani: data.bitisZamani.present
          ? data.bitisZamani.value
          : this.bitisZamani,
      basarili: data.basarili.present ? data.basarili.value : this.basarili,
      eklenenSayi: data.eklenenSayi.present
          ? data.eklenenSayi.value
          : this.eklenenSayi,
      guncellenenSayi: data.guncellenenSayi.present
          ? data.guncellenenSayi.value
          : this.guncellenenSayi,
      hataMesaji: data.hataMesaji.present
          ? data.hataMesaji.value
          : this.hataMesaji,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLog(')
          ..write('id: $id, ')
          ..write('baslangicZamani: $baslangicZamani, ')
          ..write('bitisZamani: $bitisZamani, ')
          ..write('basarili: $basarili, ')
          ..write('eklenenSayi: $eklenenSayi, ')
          ..write('guncellenenSayi: $guncellenenSayi, ')
          ..write('hataMesaji: $hataMesaji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baslangicZamani,
    bitisZamani,
    basarili,
    eklenenSayi,
    guncellenenSayi,
    hataMesaji,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLog &&
          other.id == this.id &&
          other.baslangicZamani == this.baslangicZamani &&
          other.bitisZamani == this.bitisZamani &&
          other.basarili == this.basarili &&
          other.eklenenSayi == this.eklenenSayi &&
          other.guncellenenSayi == this.guncellenenSayi &&
          other.hataMesaji == this.hataMesaji);
}

class SyncLogsCompanion extends UpdateCompanion<SyncLog> {
  final Value<int> id;
  final Value<DateTime> baslangicZamani;
  final Value<DateTime?> bitisZamani;
  final Value<bool> basarili;
  final Value<int> eklenenSayi;
  final Value<int> guncellenenSayi;
  final Value<String?> hataMesaji;
  const SyncLogsCompanion({
    this.id = const Value.absent(),
    this.baslangicZamani = const Value.absent(),
    this.bitisZamani = const Value.absent(),
    this.basarili = const Value.absent(),
    this.eklenenSayi = const Value.absent(),
    this.guncellenenSayi = const Value.absent(),
    this.hataMesaji = const Value.absent(),
  });
  SyncLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime baslangicZamani,
    this.bitisZamani = const Value.absent(),
    this.basarili = const Value.absent(),
    this.eklenenSayi = const Value.absent(),
    this.guncellenenSayi = const Value.absent(),
    this.hataMesaji = const Value.absent(),
  }) : baslangicZamani = Value(baslangicZamani);
  static Insertable<SyncLog> custom({
    Expression<int>? id,
    Expression<DateTime>? baslangicZamani,
    Expression<DateTime>? bitisZamani,
    Expression<bool>? basarili,
    Expression<int>? eklenenSayi,
    Expression<int>? guncellenenSayi,
    Expression<String>? hataMesaji,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baslangicZamani != null) 'baslangic_zamani': baslangicZamani,
      if (bitisZamani != null) 'bitis_zamani': bitisZamani,
      if (basarili != null) 'basarili': basarili,
      if (eklenenSayi != null) 'eklenen_sayi': eklenenSayi,
      if (guncellenenSayi != null) 'guncellenen_sayi': guncellenenSayi,
      if (hataMesaji != null) 'hata_mesaji': hataMesaji,
    });
  }

  SyncLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? baslangicZamani,
    Value<DateTime?>? bitisZamani,
    Value<bool>? basarili,
    Value<int>? eklenenSayi,
    Value<int>? guncellenenSayi,
    Value<String?>? hataMesaji,
  }) {
    return SyncLogsCompanion(
      id: id ?? this.id,
      baslangicZamani: baslangicZamani ?? this.baslangicZamani,
      bitisZamani: bitisZamani ?? this.bitisZamani,
      basarili: basarili ?? this.basarili,
      eklenenSayi: eklenenSayi ?? this.eklenenSayi,
      guncellenenSayi: guncellenenSayi ?? this.guncellenenSayi,
      hataMesaji: hataMesaji ?? this.hataMesaji,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baslangicZamani.present) {
      map['baslangic_zamani'] = Variable<DateTime>(baslangicZamani.value);
    }
    if (bitisZamani.present) {
      map['bitis_zamani'] = Variable<DateTime>(bitisZamani.value);
    }
    if (basarili.present) {
      map['basarili'] = Variable<bool>(basarili.value);
    }
    if (eklenenSayi.present) {
      map['eklenen_sayi'] = Variable<int>(eklenenSayi.value);
    }
    if (guncellenenSayi.present) {
      map['guncellenen_sayi'] = Variable<int>(guncellenenSayi.value);
    }
    if (hataMesaji.present) {
      map['hata_mesaji'] = Variable<String>(hataMesaji.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogsCompanion(')
          ..write('id: $id, ')
          ..write('baslangicZamani: $baslangicZamani, ')
          ..write('bitisZamani: $bitisZamani, ')
          ..write('basarili: $basarili, ')
          ..write('eklenenSayi: $eklenenSayi, ')
          ..write('guncellenenSayi: $guncellenenSayi, ')
          ..write('hataMesaji: $hataMesaji')
          ..write(')'))
        .toString();
  }
}

class $UserNotesTable extends UserNotes
    with TableInfo<$UserNotesTable, UserNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hearingIdMeta = const VerificationMeta(
    'hearingId',
  );
  @override
  late final GeneratedColumn<int> hearingId = GeneratedColumn<int>(
    'hearing_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hearings (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _notMetniMeta = const VerificationMeta(
    'notMetni',
  );
  @override
  late final GeneratedColumn<String> notMetni = GeneratedColumn<String>(
    'not_metni',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _olusturmaTarihiMeta = const VerificationMeta(
    'olusturmaTarihi',
  );
  @override
  late final GeneratedColumn<DateTime> olusturmaTarihi =
      GeneratedColumn<DateTime>(
        'olusturma_tarihi',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hearingId,
    notMetni,
    olusturmaTarihi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hearing_id')) {
      context.handle(
        _hearingIdMeta,
        hearingId.isAcceptableOrUnknown(data['hearing_id']!, _hearingIdMeta),
      );
    }
    if (data.containsKey('not_metni')) {
      context.handle(
        _notMetniMeta,
        notMetni.isAcceptableOrUnknown(data['not_metni']!, _notMetniMeta),
      );
    } else if (isInserting) {
      context.missing(_notMetniMeta);
    }
    if (data.containsKey('olusturma_tarihi')) {
      context.handle(
        _olusturmaTarihiMeta,
        olusturmaTarihi.isAcceptableOrUnknown(
          data['olusturma_tarihi']!,
          _olusturmaTarihiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_olusturmaTarihiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hearingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hearing_id'],
      ),
      notMetni: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}not_metni'],
      )!,
      olusturmaTarihi: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}olusturma_tarihi'],
      )!,
    );
  }

  @override
  $UserNotesTable createAlias(String alias) {
    return $UserNotesTable(attachedDatabase, alias);
  }
}

class UserNote extends DataClass implements Insertable<UserNote> {
  final int id;

  /// Bağlı duruşma kimliği. Duruşma silindiğinde null olur.
  final int? hearingId;

  /// Notun içeriği.
  final String notMetni;

  /// Notun oluşturulma tarihi.
  final DateTime olusturmaTarihi;
  const UserNote({
    required this.id,
    this.hearingId,
    required this.notMetni,
    required this.olusturmaTarihi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || hearingId != null) {
      map['hearing_id'] = Variable<int>(hearingId);
    }
    map['not_metni'] = Variable<String>(notMetni);
    map['olusturma_tarihi'] = Variable<DateTime>(olusturmaTarihi);
    return map;
  }

  UserNotesCompanion toCompanion(bool nullToAbsent) {
    return UserNotesCompanion(
      id: Value(id),
      hearingId: hearingId == null && nullToAbsent
          ? const Value.absent()
          : Value(hearingId),
      notMetni: Value(notMetni),
      olusturmaTarihi: Value(olusturmaTarihi),
    );
  }

  factory UserNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserNote(
      id: serializer.fromJson<int>(json['id']),
      hearingId: serializer.fromJson<int?>(json['hearingId']),
      notMetni: serializer.fromJson<String>(json['notMetni']),
      olusturmaTarihi: serializer.fromJson<DateTime>(json['olusturmaTarihi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hearingId': serializer.toJson<int?>(hearingId),
      'notMetni': serializer.toJson<String>(notMetni),
      'olusturmaTarihi': serializer.toJson<DateTime>(olusturmaTarihi),
    };
  }

  UserNote copyWith({
    int? id,
    Value<int?> hearingId = const Value.absent(),
    String? notMetni,
    DateTime? olusturmaTarihi,
  }) => UserNote(
    id: id ?? this.id,
    hearingId: hearingId.present ? hearingId.value : this.hearingId,
    notMetni: notMetni ?? this.notMetni,
    olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
  );
  UserNote copyWithCompanion(UserNotesCompanion data) {
    return UserNote(
      id: data.id.present ? data.id.value : this.id,
      hearingId: data.hearingId.present ? data.hearingId.value : this.hearingId,
      notMetni: data.notMetni.present ? data.notMetni.value : this.notMetni,
      olusturmaTarihi: data.olusturmaTarihi.present
          ? data.olusturmaTarihi.value
          : this.olusturmaTarihi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserNote(')
          ..write('id: $id, ')
          ..write('hearingId: $hearingId, ')
          ..write('notMetni: $notMetni, ')
          ..write('olusturmaTarihi: $olusturmaTarihi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hearingId, notMetni, olusturmaTarihi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserNote &&
          other.id == this.id &&
          other.hearingId == this.hearingId &&
          other.notMetni == this.notMetni &&
          other.olusturmaTarihi == this.olusturmaTarihi);
}

class UserNotesCompanion extends UpdateCompanion<UserNote> {
  final Value<int> id;
  final Value<int?> hearingId;
  final Value<String> notMetni;
  final Value<DateTime> olusturmaTarihi;
  const UserNotesCompanion({
    this.id = const Value.absent(),
    this.hearingId = const Value.absent(),
    this.notMetni = const Value.absent(),
    this.olusturmaTarihi = const Value.absent(),
  });
  UserNotesCompanion.insert({
    this.id = const Value.absent(),
    this.hearingId = const Value.absent(),
    required String notMetni,
    required DateTime olusturmaTarihi,
  }) : notMetni = Value(notMetni),
       olusturmaTarihi = Value(olusturmaTarihi);
  static Insertable<UserNote> custom({
    Expression<int>? id,
    Expression<int>? hearingId,
    Expression<String>? notMetni,
    Expression<DateTime>? olusturmaTarihi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hearingId != null) 'hearing_id': hearingId,
      if (notMetni != null) 'not_metni': notMetni,
      if (olusturmaTarihi != null) 'olusturma_tarihi': olusturmaTarihi,
    });
  }

  UserNotesCompanion copyWith({
    Value<int>? id,
    Value<int?>? hearingId,
    Value<String>? notMetni,
    Value<DateTime>? olusturmaTarihi,
  }) {
    return UserNotesCompanion(
      id: id ?? this.id,
      hearingId: hearingId ?? this.hearingId,
      notMetni: notMetni ?? this.notMetni,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hearingId.present) {
      map['hearing_id'] = Variable<int>(hearingId.value);
    }
    if (notMetni.present) {
      map['not_metni'] = Variable<String>(notMetni.value);
    }
    if (olusturmaTarihi.present) {
      map['olusturma_tarihi'] = Variable<DateTime>(olusturmaTarihi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserNotesCompanion(')
          ..write('id: $id, ')
          ..write('hearingId: $hearingId, ')
          ..write('notMetni: $notMetni, ')
          ..write('olusturmaTarihi: $olusturmaTarihi')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CasesTable cases = $CasesTable(this);
  late final $HearingsTable hearings = $HearingsTable(this);
  late final $SyncLogsTable syncLogs = $SyncLogsTable(this);
  late final $UserNotesTable userNotes = $UserNotesTable(this);
  late final Index idxHearingsTarih = Index(
    'idx_hearings_tarih',
    'CREATE INDEX idx_hearings_tarih ON hearings (durusma_tarihi)',
  );
  late final CasesDao casesDao = CasesDao(this as AppDatabase);
  late final HearingsDao hearingsDao = HearingsDao(this as AppDatabase);
  late final SyncLogsDao syncLogsDao = SyncLogsDao(this as AppDatabase);
  late final UserNotesDao userNotesDao = UserNotesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cases,
    hearings,
    syncLogs,
    userNotes,
    idxHearingsTarih,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('hearings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'hearings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('user_notes', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$CasesTableCreateCompanionBuilder =
    CasesCompanion Function({
      Value<int> id,
      required String dosyaNo,
      required String mahkemeAdi,
      Value<String?> mahkemeTuru,
      Value<String?> dosyaTuru,
      Value<List<Party>> taraflarJson,
      Value<String?> durum,
      Value<DateTime?> sonIslemTarihi,
      required DateTime sonSenkronTarihi,
    });
typedef $$CasesTableUpdateCompanionBuilder =
    CasesCompanion Function({
      Value<int> id,
      Value<String> dosyaNo,
      Value<String> mahkemeAdi,
      Value<String?> mahkemeTuru,
      Value<String?> dosyaTuru,
      Value<List<Party>> taraflarJson,
      Value<String?> durum,
      Value<DateTime?> sonIslemTarihi,
      Value<DateTime> sonSenkronTarihi,
    });

final class $$CasesTableReferences
    extends BaseReferences<_$AppDatabase, $CasesTable, Case> {
  $$CasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HearingsTable, List<Hearing>> _hearingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.hearings,
    aliasName: $_aliasNameGenerator(db.cases.id, db.hearings.caseId),
  );

  $$HearingsTableProcessedTableManager get hearingsRefs {
    final manager = $$HearingsTableTableManager(
      $_db,
      $_db.hearings,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hearingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CasesTableFilterComposer extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosyaNo => $composableBuilder(
    column: $table.dosyaNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mahkemeAdi => $composableBuilder(
    column: $table.mahkemeAdi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mahkemeTuru => $composableBuilder(
    column: $table.mahkemeTuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosyaTuru => $composableBuilder(
    column: $table.dosyaTuru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Party>, List<Party>, String>
  get taraflarJson => $composableBuilder(
    column: $table.taraflarJson,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sonIslemTarihi => $composableBuilder(
    column: $table.sonIslemTarihi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sonSenkronTarihi => $composableBuilder(
    column: $table.sonSenkronTarihi,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> hearingsRefs(
    Expression<bool> Function($$HearingsTableFilterComposer f) f,
  ) {
    final $$HearingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableFilterComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosyaNo => $composableBuilder(
    column: $table.dosyaNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mahkemeAdi => $composableBuilder(
    column: $table.mahkemeAdi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mahkemeTuru => $composableBuilder(
    column: $table.mahkemeTuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosyaTuru => $composableBuilder(
    column: $table.dosyaTuru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taraflarJson => $composableBuilder(
    column: $table.taraflarJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durum => $composableBuilder(
    column: $table.durum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sonIslemTarihi => $composableBuilder(
    column: $table.sonIslemTarihi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sonSenkronTarihi => $composableBuilder(
    column: $table.sonSenkronTarihi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dosyaNo =>
      $composableBuilder(column: $table.dosyaNo, builder: (column) => column);

  GeneratedColumn<String> get mahkemeAdi => $composableBuilder(
    column: $table.mahkemeAdi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mahkemeTuru => $composableBuilder(
    column: $table.mahkemeTuru,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosyaTuru =>
      $composableBuilder(column: $table.dosyaTuru, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Party>, String> get taraflarJson =>
      $composableBuilder(
        column: $table.taraflarJson,
        builder: (column) => column,
      );

  GeneratedColumn<String> get durum =>
      $composableBuilder(column: $table.durum, builder: (column) => column);

  GeneratedColumn<DateTime> get sonIslemTarihi => $composableBuilder(
    column: $table.sonIslemTarihi,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sonSenkronTarihi => $composableBuilder(
    column: $table.sonSenkronTarihi,
    builder: (column) => column,
  );

  Expression<T> hearingsRefs<T extends Object>(
    Expression<T> Function($$HearingsTableAnnotationComposer a) f,
  ) {
    final $$HearingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableAnnotationComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CasesTable,
          Case,
          $$CasesTableFilterComposer,
          $$CasesTableOrderingComposer,
          $$CasesTableAnnotationComposer,
          $$CasesTableCreateCompanionBuilder,
          $$CasesTableUpdateCompanionBuilder,
          (Case, $$CasesTableReferences),
          Case,
          PrefetchHooks Function({bool hearingsRefs})
        > {
  $$CasesTableTableManager(_$AppDatabase db, $CasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dosyaNo = const Value.absent(),
                Value<String> mahkemeAdi = const Value.absent(),
                Value<String?> mahkemeTuru = const Value.absent(),
                Value<String?> dosyaTuru = const Value.absent(),
                Value<List<Party>> taraflarJson = const Value.absent(),
                Value<String?> durum = const Value.absent(),
                Value<DateTime?> sonIslemTarihi = const Value.absent(),
                Value<DateTime> sonSenkronTarihi = const Value.absent(),
              }) => CasesCompanion(
                id: id,
                dosyaNo: dosyaNo,
                mahkemeAdi: mahkemeAdi,
                mahkemeTuru: mahkemeTuru,
                dosyaTuru: dosyaTuru,
                taraflarJson: taraflarJson,
                durum: durum,
                sonIslemTarihi: sonIslemTarihi,
                sonSenkronTarihi: sonSenkronTarihi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dosyaNo,
                required String mahkemeAdi,
                Value<String?> mahkemeTuru = const Value.absent(),
                Value<String?> dosyaTuru = const Value.absent(),
                Value<List<Party>> taraflarJson = const Value.absent(),
                Value<String?> durum = const Value.absent(),
                Value<DateTime?> sonIslemTarihi = const Value.absent(),
                required DateTime sonSenkronTarihi,
              }) => CasesCompanion.insert(
                id: id,
                dosyaNo: dosyaNo,
                mahkemeAdi: mahkemeAdi,
                mahkemeTuru: mahkemeTuru,
                dosyaTuru: dosyaTuru,
                taraflarJson: taraflarJson,
                durum: durum,
                sonIslemTarihi: sonIslemTarihi,
                sonSenkronTarihi: sonSenkronTarihi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CasesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({hearingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (hearingsRefs) db.hearings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (hearingsRefs)
                    await $_getPrefetchedData<Case, $CasesTable, Hearing>(
                      currentTable: table,
                      referencedTable: $$CasesTableReferences
                          ._hearingsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CasesTableReferences(db, table, p0).hearingsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.caseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CasesTable,
      Case,
      $$CasesTableFilterComposer,
      $$CasesTableOrderingComposer,
      $$CasesTableAnnotationComposer,
      $$CasesTableCreateCompanionBuilder,
      $$CasesTableUpdateCompanionBuilder,
      (Case, $$CasesTableReferences),
      Case,
      PrefetchHooks Function({bool hearingsRefs})
    >;
typedef $$HearingsTableCreateCompanionBuilder =
    HearingsCompanion Function({
      Value<int> id,
      required int caseId,
      required DateTime durusmaTarihi,
      Value<String?> salon,
      Value<String?> gundem,
      Value<bool> bildirimTetiklendi,
      Value<String?> takvimEventId,
      required DateTime sonSenkronTarihi,
    });
typedef $$HearingsTableUpdateCompanionBuilder =
    HearingsCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<DateTime> durusmaTarihi,
      Value<String?> salon,
      Value<String?> gundem,
      Value<bool> bildirimTetiklendi,
      Value<String?> takvimEventId,
      Value<DateTime> sonSenkronTarihi,
    });

final class $$HearingsTableReferences
    extends BaseReferences<_$AppDatabase, $HearingsTable, Hearing> {
  $$HearingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CasesTable _caseIdTable(_$AppDatabase db) => db.cases.createAlias(
    $_aliasNameGenerator(db.hearings.caseId, db.cases.id),
  );

  $$CasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$UserNotesTable, List<UserNote>>
  _userNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userNotes,
    aliasName: $_aliasNameGenerator(db.hearings.id, db.userNotes.hearingId),
  );

  $$UserNotesTableProcessedTableManager get userNotesRefs {
    final manager = $$UserNotesTableTableManager(
      $_db,
      $_db.userNotes,
    ).filter((f) => f.hearingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HearingsTableFilterComposer
    extends Composer<_$AppDatabase, $HearingsTable> {
  $$HearingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get durusmaTarihi => $composableBuilder(
    column: $table.durusmaTarihi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salon => $composableBuilder(
    column: $table.salon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gundem => $composableBuilder(
    column: $table.gundem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bildirimTetiklendi => $composableBuilder(
    column: $table.bildirimTetiklendi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get takvimEventId => $composableBuilder(
    column: $table.takvimEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sonSenkronTarihi => $composableBuilder(
    column: $table.sonSenkronTarihi,
    builder: (column) => ColumnFilters(column),
  );

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> userNotesRefs(
    Expression<bool> Function($$UserNotesTableFilterComposer f) f,
  ) {
    final $$UserNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userNotes,
      getReferencedColumn: (t) => t.hearingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserNotesTableFilterComposer(
            $db: $db,
            $table: $db.userNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HearingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HearingsTable> {
  $$HearingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get durusmaTarihi => $composableBuilder(
    column: $table.durusmaTarihi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salon => $composableBuilder(
    column: $table.salon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gundem => $composableBuilder(
    column: $table.gundem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bildirimTetiklendi => $composableBuilder(
    column: $table.bildirimTetiklendi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get takvimEventId => $composableBuilder(
    column: $table.takvimEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sonSenkronTarihi => $composableBuilder(
    column: $table.sonSenkronTarihi,
    builder: (column) => ColumnOrderings(column),
  );

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableOrderingComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HearingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HearingsTable> {
  $$HearingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get durusmaTarihi => $composableBuilder(
    column: $table.durusmaTarihi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salon =>
      $composableBuilder(column: $table.salon, builder: (column) => column);

  GeneratedColumn<String> get gundem =>
      $composableBuilder(column: $table.gundem, builder: (column) => column);

  GeneratedColumn<bool> get bildirimTetiklendi => $composableBuilder(
    column: $table.bildirimTetiklendi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get takvimEventId => $composableBuilder(
    column: $table.takvimEventId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sonSenkronTarihi => $composableBuilder(
    column: $table.sonSenkronTarihi,
    builder: (column) => column,
  );

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> userNotesRefs<T extends Object>(
    Expression<T> Function($$UserNotesTableAnnotationComposer a) f,
  ) {
    final $$UserNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userNotes,
      getReferencedColumn: (t) => t.hearingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.userNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HearingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HearingsTable,
          Hearing,
          $$HearingsTableFilterComposer,
          $$HearingsTableOrderingComposer,
          $$HearingsTableAnnotationComposer,
          $$HearingsTableCreateCompanionBuilder,
          $$HearingsTableUpdateCompanionBuilder,
          (Hearing, $$HearingsTableReferences),
          Hearing,
          PrefetchHooks Function({bool caseId, bool userNotesRefs})
        > {
  $$HearingsTableTableManager(_$AppDatabase db, $HearingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HearingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HearingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HearingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<DateTime> durusmaTarihi = const Value.absent(),
                Value<String?> salon = const Value.absent(),
                Value<String?> gundem = const Value.absent(),
                Value<bool> bildirimTetiklendi = const Value.absent(),
                Value<String?> takvimEventId = const Value.absent(),
                Value<DateTime> sonSenkronTarihi = const Value.absent(),
              }) => HearingsCompanion(
                id: id,
                caseId: caseId,
                durusmaTarihi: durusmaTarihi,
                salon: salon,
                gundem: gundem,
                bildirimTetiklendi: bildirimTetiklendi,
                takvimEventId: takvimEventId,
                sonSenkronTarihi: sonSenkronTarihi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                required DateTime durusmaTarihi,
                Value<String?> salon = const Value.absent(),
                Value<String?> gundem = const Value.absent(),
                Value<bool> bildirimTetiklendi = const Value.absent(),
                Value<String?> takvimEventId = const Value.absent(),
                required DateTime sonSenkronTarihi,
              }) => HearingsCompanion.insert(
                id: id,
                caseId: caseId,
                durusmaTarihi: durusmaTarihi,
                salon: salon,
                gundem: gundem,
                bildirimTetiklendi: bildirimTetiklendi,
                takvimEventId: takvimEventId,
                sonSenkronTarihi: sonSenkronTarihi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HearingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false, userNotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userNotesRefs) db.userNotes],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$HearingsTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$HearingsTableReferences
                                    ._caseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userNotesRefs)
                    await $_getPrefetchedData<
                      Hearing,
                      $HearingsTable,
                      UserNote
                    >(
                      currentTable: table,
                      referencedTable: $$HearingsTableReferences
                          ._userNotesRefsTable(db),
                      managerFromTypedResult: (p0) => $$HearingsTableReferences(
                        db,
                        table,
                        p0,
                      ).userNotesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.hearingId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HearingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HearingsTable,
      Hearing,
      $$HearingsTableFilterComposer,
      $$HearingsTableOrderingComposer,
      $$HearingsTableAnnotationComposer,
      $$HearingsTableCreateCompanionBuilder,
      $$HearingsTableUpdateCompanionBuilder,
      (Hearing, $$HearingsTableReferences),
      Hearing,
      PrefetchHooks Function({bool caseId, bool userNotesRefs})
    >;
typedef $$SyncLogsTableCreateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<int> id,
      required DateTime baslangicZamani,
      Value<DateTime?> bitisZamani,
      Value<bool> basarili,
      Value<int> eklenenSayi,
      Value<int> guncellenenSayi,
      Value<String?> hataMesaji,
    });
typedef $$SyncLogsTableUpdateCompanionBuilder =
    SyncLogsCompanion Function({
      Value<int> id,
      Value<DateTime> baslangicZamani,
      Value<DateTime?> bitisZamani,
      Value<bool> basarili,
      Value<int> eklenenSayi,
      Value<int> guncellenenSayi,
      Value<String?> hataMesaji,
    });

class $$SyncLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get baslangicZamani => $composableBuilder(
    column: $table.baslangicZamani,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bitisZamani => $composableBuilder(
    column: $table.bitisZamani,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get basarili => $composableBuilder(
    column: $table.basarili,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eklenenSayi => $composableBuilder(
    column: $table.eklenenSayi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get guncellenenSayi => $composableBuilder(
    column: $table.guncellenenSayi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hataMesaji => $composableBuilder(
    column: $table.hataMesaji,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get baslangicZamani => $composableBuilder(
    column: $table.baslangicZamani,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bitisZamani => $composableBuilder(
    column: $table.bitisZamani,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get basarili => $composableBuilder(
    column: $table.basarili,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eklenenSayi => $composableBuilder(
    column: $table.eklenenSayi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get guncellenenSayi => $composableBuilder(
    column: $table.guncellenenSayi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hataMesaji => $composableBuilder(
    column: $table.hataMesaji,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogsTable> {
  $$SyncLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get baslangicZamani => $composableBuilder(
    column: $table.baslangicZamani,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get bitisZamani => $composableBuilder(
    column: $table.bitisZamani,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get basarili =>
      $composableBuilder(column: $table.basarili, builder: (column) => column);

  GeneratedColumn<int> get eklenenSayi => $composableBuilder(
    column: $table.eklenenSayi,
    builder: (column) => column,
  );

  GeneratedColumn<int> get guncellenenSayi => $composableBuilder(
    column: $table.guncellenenSayi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hataMesaji => $composableBuilder(
    column: $table.hataMesaji,
    builder: (column) => column,
  );
}

class $$SyncLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLogsTable,
          SyncLog,
          $$SyncLogsTableFilterComposer,
          $$SyncLogsTableOrderingComposer,
          $$SyncLogsTableAnnotationComposer,
          $$SyncLogsTableCreateCompanionBuilder,
          $$SyncLogsTableUpdateCompanionBuilder,
          (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
          SyncLog,
          PrefetchHooks Function()
        > {
  $$SyncLogsTableTableManager(_$AppDatabase db, $SyncLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> baslangicZamani = const Value.absent(),
                Value<DateTime?> bitisZamani = const Value.absent(),
                Value<bool> basarili = const Value.absent(),
                Value<int> eklenenSayi = const Value.absent(),
                Value<int> guncellenenSayi = const Value.absent(),
                Value<String?> hataMesaji = const Value.absent(),
              }) => SyncLogsCompanion(
                id: id,
                baslangicZamani: baslangicZamani,
                bitisZamani: bitisZamani,
                basarili: basarili,
                eklenenSayi: eklenenSayi,
                guncellenenSayi: guncellenenSayi,
                hataMesaji: hataMesaji,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime baslangicZamani,
                Value<DateTime?> bitisZamani = const Value.absent(),
                Value<bool> basarili = const Value.absent(),
                Value<int> eklenenSayi = const Value.absent(),
                Value<int> guncellenenSayi = const Value.absent(),
                Value<String?> hataMesaji = const Value.absent(),
              }) => SyncLogsCompanion.insert(
                id: id,
                baslangicZamani: baslangicZamani,
                bitisZamani: bitisZamani,
                basarili: basarili,
                eklenenSayi: eklenenSayi,
                guncellenenSayi: guncellenenSayi,
                hataMesaji: hataMesaji,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLogsTable,
      SyncLog,
      $$SyncLogsTableFilterComposer,
      $$SyncLogsTableOrderingComposer,
      $$SyncLogsTableAnnotationComposer,
      $$SyncLogsTableCreateCompanionBuilder,
      $$SyncLogsTableUpdateCompanionBuilder,
      (SyncLog, BaseReferences<_$AppDatabase, $SyncLogsTable, SyncLog>),
      SyncLog,
      PrefetchHooks Function()
    >;
typedef $$UserNotesTableCreateCompanionBuilder =
    UserNotesCompanion Function({
      Value<int> id,
      Value<int?> hearingId,
      required String notMetni,
      required DateTime olusturmaTarihi,
    });
typedef $$UserNotesTableUpdateCompanionBuilder =
    UserNotesCompanion Function({
      Value<int> id,
      Value<int?> hearingId,
      Value<String> notMetni,
      Value<DateTime> olusturmaTarihi,
    });

final class $$UserNotesTableReferences
    extends BaseReferences<_$AppDatabase, $UserNotesTable, UserNote> {
  $$UserNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HearingsTable _hearingIdTable(_$AppDatabase db) =>
      db.hearings.createAlias(
        $_aliasNameGenerator(db.userNotes.hearingId, db.hearings.id),
      );

  $$HearingsTableProcessedTableManager? get hearingId {
    final $_column = $_itemColumn<int>('hearing_id');
    if ($_column == null) return null;
    final manager = $$HearingsTableTableManager(
      $_db,
      $_db.hearings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hearingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserNotesTableFilterComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notMetni => $composableBuilder(
    column: $table.notMetni,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get olusturmaTarihi => $composableBuilder(
    column: $table.olusturmaTarihi,
    builder: (column) => ColumnFilters(column),
  );

  $$HearingsTableFilterComposer get hearingId {
    final $$HearingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hearingId,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableFilterComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notMetni => $composableBuilder(
    column: $table.notMetni,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get olusturmaTarihi => $composableBuilder(
    column: $table.olusturmaTarihi,
    builder: (column) => ColumnOrderings(column),
  );

  $$HearingsTableOrderingComposer get hearingId {
    final $$HearingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hearingId,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableOrderingComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notMetni =>
      $composableBuilder(column: $table.notMetni, builder: (column) => column);

  GeneratedColumn<DateTime> get olusturmaTarihi => $composableBuilder(
    column: $table.olusturmaTarihi,
    builder: (column) => column,
  );

  $$HearingsTableAnnotationComposer get hearingId {
    final $$HearingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hearingId,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableAnnotationComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserNotesTable,
          UserNote,
          $$UserNotesTableFilterComposer,
          $$UserNotesTableOrderingComposer,
          $$UserNotesTableAnnotationComposer,
          $$UserNotesTableCreateCompanionBuilder,
          $$UserNotesTableUpdateCompanionBuilder,
          (UserNote, $$UserNotesTableReferences),
          UserNote,
          PrefetchHooks Function({bool hearingId})
        > {
  $$UserNotesTableTableManager(_$AppDatabase db, $UserNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> hearingId = const Value.absent(),
                Value<String> notMetni = const Value.absent(),
                Value<DateTime> olusturmaTarihi = const Value.absent(),
              }) => UserNotesCompanion(
                id: id,
                hearingId: hearingId,
                notMetni: notMetni,
                olusturmaTarihi: olusturmaTarihi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> hearingId = const Value.absent(),
                required String notMetni,
                required DateTime olusturmaTarihi,
              }) => UserNotesCompanion.insert(
                id: id,
                hearingId: hearingId,
                notMetni: notMetni,
                olusturmaTarihi: olusturmaTarihi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hearingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (hearingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.hearingId,
                                referencedTable: $$UserNotesTableReferences
                                    ._hearingIdTable(db),
                                referencedColumn: $$UserNotesTableReferences
                                    ._hearingIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserNotesTable,
      UserNote,
      $$UserNotesTableFilterComposer,
      $$UserNotesTableOrderingComposer,
      $$UserNotesTableAnnotationComposer,
      $$UserNotesTableCreateCompanionBuilder,
      $$UserNotesTableUpdateCompanionBuilder,
      (UserNote, $$UserNotesTableReferences),
      UserNote,
      PrefetchHooks Function({bool hearingId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db, _db.cases);
  $$HearingsTableTableManager get hearings =>
      $$HearingsTableTableManager(_db, _db.hearings);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db, _db.syncLogs);
  $$UserNotesTableTableManager get userNotes =>
      $$UserNotesTableTableManager(_db, _db.userNotes);
}
