// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pluMeta = const VerificationMeta('plu');
  @override
  late final GeneratedColumn<String> plu = GeneratedColumn<String>(
    'plu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precoMeta = const VerificationMeta('preco');
  @override
  late final GeneratedColumn<double> preco = GeneratedColumn<double>(
    'preco',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadeMeta = const VerificationMeta(
    'unidade',
  );
  @override
  late final GeneratedColumn<String> unidade = GeneratedColumn<String>(
    'unidade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validadeDiasMeta = const VerificationMeta(
    'validadeDias',
  );
  @override
  late final GeneratedColumn<int> validadeDias = GeneratedColumn<int>(
    'validade_dias',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoBarrasMeta = const VerificationMeta(
    'codigoBarras',
  );
  @override
  late final GeneratedColumn<String> codigoBarras = GeneratedColumn<String>(
    'codigo_barras',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departamentoMeta = const VerificationMeta(
    'departamento',
  );
  @override
  late final GeneratedColumn<String> departamento = GeneratedColumn<String>(
    'departamento',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    plu,
    descricao,
    preco,
    unidade,
    validadeDias,
    codigoBarras,
    departamento,
    ativo,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('plu')) {
      context.handle(
        _pluMeta,
        plu.isAcceptableOrUnknown(data['plu']!, _pluMeta),
      );
    } else if (isInserting) {
      context.missing(_pluMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('preco')) {
      context.handle(
        _precoMeta,
        preco.isAcceptableOrUnknown(data['preco']!, _precoMeta),
      );
    } else if (isInserting) {
      context.missing(_precoMeta);
    }
    if (data.containsKey('unidade')) {
      context.handle(
        _unidadeMeta,
        unidade.isAcceptableOrUnknown(data['unidade']!, _unidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadeMeta);
    }
    if (data.containsKey('validade_dias')) {
      context.handle(
        _validadeDiasMeta,
        validadeDias.isAcceptableOrUnknown(
          data['validade_dias']!,
          _validadeDiasMeta,
        ),
      );
    }
    if (data.containsKey('codigo_barras')) {
      context.handle(
        _codigoBarrasMeta,
        codigoBarras.isAcceptableOrUnknown(
          data['codigo_barras']!,
          _codigoBarrasMeta,
        ),
      );
    }
    if (data.containsKey('departamento')) {
      context.handle(
        _departamentoMeta,
        departamento.isAcceptableOrUnknown(
          data['departamento']!,
          _departamentoMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {codigo},
  ];
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      plu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plu'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      preco: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}preco'],
      )!,
      unidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidade'],
      )!,
      validadeDias: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}validade_dias'],
      ),
      codigoBarras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_barras'],
      ),
      departamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departamento'],
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String codigo;
  final String plu;
  final String descricao;
  final double preco;
  final String unidade;
  final int? validadeDias;
  final String? codigoBarras;
  final String? departamento;
  final bool ativo;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  const Product({
    required this.id,
    required this.codigo,
    required this.plu,
    required this.descricao,
    required this.preco,
    required this.unidade,
    this.validadeDias,
    this.codigoBarras,
    this.departamento,
    required this.ativo,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['codigo'] = Variable<String>(codigo);
    map['plu'] = Variable<String>(plu);
    map['descricao'] = Variable<String>(descricao);
    map['preco'] = Variable<double>(preco);
    map['unidade'] = Variable<String>(unidade);
    if (!nullToAbsent || validadeDias != null) {
      map['validade_dias'] = Variable<int>(validadeDias);
    }
    if (!nullToAbsent || codigoBarras != null) {
      map['codigo_barras'] = Variable<String>(codigoBarras);
    }
    if (!nullToAbsent || departamento != null) {
      map['departamento'] = Variable<String>(departamento);
    }
    map['ativo'] = Variable<bool>(ativo);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      codigo: Value(codigo),
      plu: Value(plu),
      descricao: Value(descricao),
      preco: Value(preco),
      unidade: Value(unidade),
      validadeDias: validadeDias == null && nullToAbsent
          ? const Value.absent()
          : Value(validadeDias),
      codigoBarras: codigoBarras == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoBarras),
      departamento: departamento == null && nullToAbsent
          ? const Value.absent()
          : Value(departamento),
      ativo: Value(ativo),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      plu: serializer.fromJson<String>(json['plu']),
      descricao: serializer.fromJson<String>(json['descricao']),
      preco: serializer.fromJson<double>(json['preco']),
      unidade: serializer.fromJson<String>(json['unidade']),
      validadeDias: serializer.fromJson<int?>(json['validadeDias']),
      codigoBarras: serializer.fromJson<String?>(json['codigoBarras']),
      departamento: serializer.fromJson<String?>(json['departamento']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String>(codigo),
      'plu': serializer.toJson<String>(plu),
      'descricao': serializer.toJson<String>(descricao),
      'preco': serializer.toJson<double>(preco),
      'unidade': serializer.toJson<String>(unidade),
      'validadeDias': serializer.toJson<int?>(validadeDias),
      'codigoBarras': serializer.toJson<String?>(codigoBarras),
      'departamento': serializer.toJson<String?>(departamento),
      'ativo': serializer.toJson<bool>(ativo),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Product copyWith({
    int? id,
    String? codigo,
    String? plu,
    String? descricao,
    double? preco,
    String? unidade,
    Value<int?> validadeDias = const Value.absent(),
    Value<String?> codigoBarras = const Value.absent(),
    Value<String?> departamento = const Value.absent(),
    bool? ativo,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Product(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    plu: plu ?? this.plu,
    descricao: descricao ?? this.descricao,
    preco: preco ?? this.preco,
    unidade: unidade ?? this.unidade,
    validadeDias: validadeDias.present ? validadeDias.value : this.validadeDias,
    codigoBarras: codigoBarras.present ? codigoBarras.value : this.codigoBarras,
    departamento: departamento.present ? departamento.value : this.departamento,
    ativo: ativo ?? this.ativo,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      plu: data.plu.present ? data.plu.value : this.plu,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      preco: data.preco.present ? data.preco.value : this.preco,
      unidade: data.unidade.present ? data.unidade.value : this.unidade,
      validadeDias: data.validadeDias.present
          ? data.validadeDias.value
          : this.validadeDias,
      codigoBarras: data.codigoBarras.present
          ? data.codigoBarras.value
          : this.codigoBarras,
      departamento: data.departamento.present
          ? data.departamento.value
          : this.departamento,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('plu: $plu, ')
          ..write('descricao: $descricao, ')
          ..write('preco: $preco, ')
          ..write('unidade: $unidade, ')
          ..write('validadeDias: $validadeDias, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('departamento: $departamento, ')
          ..write('ativo: $ativo, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    plu,
    descricao,
    preco,
    unidade,
    validadeDias,
    codigoBarras,
    departamento,
    ativo,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.plu == this.plu &&
          other.descricao == this.descricao &&
          other.preco == this.preco &&
          other.unidade == this.unidade &&
          other.validadeDias == this.validadeDias &&
          other.codigoBarras == this.codigoBarras &&
          other.departamento == this.departamento &&
          other.ativo == this.ativo &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> codigo;
  final Value<String> plu;
  final Value<String> descricao;
  final Value<double> preco;
  final Value<String> unidade;
  final Value<int?> validadeDias;
  final Value<String?> codigoBarras;
  final Value<String?> departamento;
  final Value<bool> ativo;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.plu = const Value.absent(),
    this.descricao = const Value.absent(),
    this.preco = const Value.absent(),
    this.unidade = const Value.absent(),
    this.validadeDias = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.departamento = const Value.absent(),
    this.ativo = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String codigo,
    required String plu,
    required String descricao,
    required double preco,
    required String unidade,
    this.validadeDias = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.departamento = const Value.absent(),
    this.ativo = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : codigo = Value(codigo),
       plu = Value(plu),
       descricao = Value(descricao),
       preco = Value(preco),
       unidade = Value(unidade),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? plu,
    Expression<String>? descricao,
    Expression<double>? preco,
    Expression<String>? unidade,
    Expression<int>? validadeDias,
    Expression<String>? codigoBarras,
    Expression<String>? departamento,
    Expression<bool>? ativo,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (plu != null) 'plu': plu,
      if (descricao != null) 'descricao': descricao,
      if (preco != null) 'preco': preco,
      if (unidade != null) 'unidade': unidade,
      if (validadeDias != null) 'validade_dias': validadeDias,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (departamento != null) 'departamento': departamento,
      if (ativo != null) 'ativo': ativo,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? codigo,
    Value<String>? plu,
    Value<String>? descricao,
    Value<double>? preco,
    Value<String>? unidade,
    Value<int?>? validadeDias,
    Value<String?>? codigoBarras,
    Value<String?>? departamento,
    Value<bool>? ativo,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      plu: plu ?? this.plu,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      unidade: unidade ?? this.unidade,
      validadeDias: validadeDias ?? this.validadeDias,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      departamento: departamento ?? this.departamento,
      ativo: ativo ?? this.ativo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (plu.present) {
      map['plu'] = Variable<String>(plu.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (preco.present) {
      map['preco'] = Variable<double>(preco.value);
    }
    if (unidade.present) {
      map['unidade'] = Variable<String>(unidade.value);
    }
    if (validadeDias.present) {
      map['validade_dias'] = Variable<int>(validadeDias.value);
    }
    if (codigoBarras.present) {
      map['codigo_barras'] = Variable<String>(codigoBarras.value);
    }
    if (departamento.present) {
      map['departamento'] = Variable<String>(departamento.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('plu: $plu, ')
          ..write('descricao: $descricao, ')
          ..write('preco: $preco, ')
          ..write('unidade: $unidade, ')
          ..write('validadeDias: $validadeDias, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('departamento: $departamento, ')
          ..write('ativo: $ativo, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $WeighingHistoryTable extends WeighingHistory
    with TableInfo<$WeighingHistoryTable, WeighingHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeighingHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtoIdMeta = const VerificationMeta(
    'produtoId',
  );
  @override
  late final GeneratedColumn<int> produtoId = GeneratedColumn<int>(
    'produto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesoMeta = const VerificationMeta('peso');
  @override
  late final GeneratedColumn<double> peso = GeneratedColumn<double>(
    'peso',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precoKgMeta = const VerificationMeta(
    'precoKg',
  );
  @override
  late final GeneratedColumn<double> precoKg = GeneratedColumn<double>(
    'preco_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorTotalMeta = const VerificationMeta(
    'valorTotal',
  );
  @override
  late final GeneratedColumn<double> valorTotal = GeneratedColumn<double>(
    'valor_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoBarrasMeta = const VerificationMeta(
    'codigoBarras',
  );
  @override
  late final GeneratedColumn<String> codigoBarras = GeneratedColumn<String>(
    'codigo_barras',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _layoutEtiquetaMeta = const VerificationMeta(
    'layoutEtiqueta',
  );
  @override
  late final GeneratedColumn<String> layoutEtiqueta = GeneratedColumn<String>(
    'layout_etiqueta',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _impressoraMeta = const VerificationMeta(
    'impressora',
  );
  @override
  late final GeneratedColumn<String> impressora = GeneratedColumn<String>(
    'impressora',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _comandaNumeroMeta = const VerificationMeta(
    'comandaNumero',
  );
  @override
  late final GeneratedColumn<String> comandaNumero = GeneratedColumn<String>(
    'comanda_numero',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusImpressaoMeta = const VerificationMeta(
    'statusImpressao',
  );
  @override
  late final GeneratedColumn<String> statusImpressao = GeneratedColumn<String>(
    'status_impressao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendente'),
  );
  static const VerificationMeta _quantidadeImpressoesMeta =
      const VerificationMeta('quantidadeImpressoes');
  @override
  late final GeneratedColumn<int> quantidadeImpressoes = GeneratedColumn<int>(
    'quantidade_impressoes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    dataHora,
    produtoId,
    codigo,
    descricao,
    peso,
    precoKg,
    valorTotal,
    codigoBarras,
    layoutEtiqueta,
    impressora,
    comandaNumero,
    statusImpressao,
    quantidadeImpressoes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weighing_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeighingHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('produto_id')) {
      context.handle(
        _produtoIdMeta,
        produtoId.isAcceptableOrUnknown(data['produto_id']!, _produtoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoIdMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('peso')) {
      context.handle(
        _pesoMeta,
        peso.isAcceptableOrUnknown(data['peso']!, _pesoMeta),
      );
    } else if (isInserting) {
      context.missing(_pesoMeta);
    }
    if (data.containsKey('preco_kg')) {
      context.handle(
        _precoKgMeta,
        precoKg.isAcceptableOrUnknown(data['preco_kg']!, _precoKgMeta),
      );
    } else if (isInserting) {
      context.missing(_precoKgMeta);
    }
    if (data.containsKey('valor_total')) {
      context.handle(
        _valorTotalMeta,
        valorTotal.isAcceptableOrUnknown(data['valor_total']!, _valorTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_valorTotalMeta);
    }
    if (data.containsKey('codigo_barras')) {
      context.handle(
        _codigoBarrasMeta,
        codigoBarras.isAcceptableOrUnknown(
          data['codigo_barras']!,
          _codigoBarrasMeta,
        ),
      );
    }
    if (data.containsKey('layout_etiqueta')) {
      context.handle(
        _layoutEtiquetaMeta,
        layoutEtiqueta.isAcceptableOrUnknown(
          data['layout_etiqueta']!,
          _layoutEtiquetaMeta,
        ),
      );
    }
    if (data.containsKey('impressora')) {
      context.handle(
        _impressoraMeta,
        impressora.isAcceptableOrUnknown(data['impressora']!, _impressoraMeta),
      );
    }
    if (data.containsKey('comanda_numero')) {
      context.handle(
        _comandaNumeroMeta,
        comandaNumero.isAcceptableOrUnknown(
          data['comanda_numero']!,
          _comandaNumeroMeta,
        ),
      );
    }
    if (data.containsKey('status_impressao')) {
      context.handle(
        _statusImpressaoMeta,
        statusImpressao.isAcceptableOrUnknown(
          data['status_impressao']!,
          _statusImpressaoMeta,
        ),
      );
    }
    if (data.containsKey('quantidade_impressoes')) {
      context.handle(
        _quantidadeImpressoesMeta,
        quantidadeImpressoes.isAcceptableOrUnknown(
          data['quantidade_impressoes']!,
          _quantidadeImpressoesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeighingHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeighingHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      produtoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produto_id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      peso: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}peso'],
      )!,
      precoKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}preco_kg'],
      )!,
      valorTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_total'],
      )!,
      codigoBarras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_barras'],
      ),
      layoutEtiqueta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layout_etiqueta'],
      ),
      impressora: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}impressora'],
      ),
      comandaNumero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comanda_numero'],
      ),
      statusImpressao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_impressao'],
      )!,
      quantidadeImpressoes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_impressoes'],
      )!,
    );
  }

  @override
  $WeighingHistoryTable createAlias(String alias) {
    return $WeighingHistoryTable(attachedDatabase, alias);
  }
}

class WeighingHistoryData extends DataClass
    implements Insertable<WeighingHistoryData> {
  final int id;
  final String uuid;
  final DateTime dataHora;
  final int produtoId;
  final String codigo;
  final String descricao;
  final double peso;
  final double precoKg;
  final double valorTotal;
  final String? codigoBarras;
  final String? layoutEtiqueta;
  final String? impressora;

  /// Número da comanda, quando a venda não foi impressa e sim
  /// registrada para um cliente que trabalha com comandas — nulo nas
  /// vendas com impressão de etiqueta (ver `SalesMode`).
  final String? comandaNumero;

  /// Nome do enum `PrintStatus` (ver `data/models/weighing_model.dart`).
  final String statusImpressao;
  final int quantidadeImpressoes;
  const WeighingHistoryData({
    required this.id,
    required this.uuid,
    required this.dataHora,
    required this.produtoId,
    required this.codigo,
    required this.descricao,
    required this.peso,
    required this.precoKg,
    required this.valorTotal,
    this.codigoBarras,
    this.layoutEtiqueta,
    this.impressora,
    this.comandaNumero,
    required this.statusImpressao,
    required this.quantidadeImpressoes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['produto_id'] = Variable<int>(produtoId);
    map['codigo'] = Variable<String>(codigo);
    map['descricao'] = Variable<String>(descricao);
    map['peso'] = Variable<double>(peso);
    map['preco_kg'] = Variable<double>(precoKg);
    map['valor_total'] = Variable<double>(valorTotal);
    if (!nullToAbsent || codigoBarras != null) {
      map['codigo_barras'] = Variable<String>(codigoBarras);
    }
    if (!nullToAbsent || layoutEtiqueta != null) {
      map['layout_etiqueta'] = Variable<String>(layoutEtiqueta);
    }
    if (!nullToAbsent || impressora != null) {
      map['impressora'] = Variable<String>(impressora);
    }
    if (!nullToAbsent || comandaNumero != null) {
      map['comanda_numero'] = Variable<String>(comandaNumero);
    }
    map['status_impressao'] = Variable<String>(statusImpressao);
    map['quantidade_impressoes'] = Variable<int>(quantidadeImpressoes);
    return map;
  }

  WeighingHistoryCompanion toCompanion(bool nullToAbsent) {
    return WeighingHistoryCompanion(
      id: Value(id),
      uuid: Value(uuid),
      dataHora: Value(dataHora),
      produtoId: Value(produtoId),
      codigo: Value(codigo),
      descricao: Value(descricao),
      peso: Value(peso),
      precoKg: Value(precoKg),
      valorTotal: Value(valorTotal),
      codigoBarras: codigoBarras == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoBarras),
      layoutEtiqueta: layoutEtiqueta == null && nullToAbsent
          ? const Value.absent()
          : Value(layoutEtiqueta),
      impressora: impressora == null && nullToAbsent
          ? const Value.absent()
          : Value(impressora),
      comandaNumero: comandaNumero == null && nullToAbsent
          ? const Value.absent()
          : Value(comandaNumero),
      statusImpressao: Value(statusImpressao),
      quantidadeImpressoes: Value(quantidadeImpressoes),
    );
  }

  factory WeighingHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeighingHistoryData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      produtoId: serializer.fromJson<int>(json['produtoId']),
      codigo: serializer.fromJson<String>(json['codigo']),
      descricao: serializer.fromJson<String>(json['descricao']),
      peso: serializer.fromJson<double>(json['peso']),
      precoKg: serializer.fromJson<double>(json['precoKg']),
      valorTotal: serializer.fromJson<double>(json['valorTotal']),
      codigoBarras: serializer.fromJson<String?>(json['codigoBarras']),
      layoutEtiqueta: serializer.fromJson<String?>(json['layoutEtiqueta']),
      impressora: serializer.fromJson<String?>(json['impressora']),
      comandaNumero: serializer.fromJson<String?>(json['comandaNumero']),
      statusImpressao: serializer.fromJson<String>(json['statusImpressao']),
      quantidadeImpressoes: serializer.fromJson<int>(
        json['quantidadeImpressoes'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'produtoId': serializer.toJson<int>(produtoId),
      'codigo': serializer.toJson<String>(codigo),
      'descricao': serializer.toJson<String>(descricao),
      'peso': serializer.toJson<double>(peso),
      'precoKg': serializer.toJson<double>(precoKg),
      'valorTotal': serializer.toJson<double>(valorTotal),
      'codigoBarras': serializer.toJson<String?>(codigoBarras),
      'layoutEtiqueta': serializer.toJson<String?>(layoutEtiqueta),
      'impressora': serializer.toJson<String?>(impressora),
      'comandaNumero': serializer.toJson<String?>(comandaNumero),
      'statusImpressao': serializer.toJson<String>(statusImpressao),
      'quantidadeImpressoes': serializer.toJson<int>(quantidadeImpressoes),
    };
  }

  WeighingHistoryData copyWith({
    int? id,
    String? uuid,
    DateTime? dataHora,
    int? produtoId,
    String? codigo,
    String? descricao,
    double? peso,
    double? precoKg,
    double? valorTotal,
    Value<String?> codigoBarras = const Value.absent(),
    Value<String?> layoutEtiqueta = const Value.absent(),
    Value<String?> impressora = const Value.absent(),
    Value<String?> comandaNumero = const Value.absent(),
    String? statusImpressao,
    int? quantidadeImpressoes,
  }) => WeighingHistoryData(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    dataHora: dataHora ?? this.dataHora,
    produtoId: produtoId ?? this.produtoId,
    codigo: codigo ?? this.codigo,
    descricao: descricao ?? this.descricao,
    peso: peso ?? this.peso,
    precoKg: precoKg ?? this.precoKg,
    valorTotal: valorTotal ?? this.valorTotal,
    codigoBarras: codigoBarras.present ? codigoBarras.value : this.codigoBarras,
    layoutEtiqueta: layoutEtiqueta.present
        ? layoutEtiqueta.value
        : this.layoutEtiqueta,
    impressora: impressora.present ? impressora.value : this.impressora,
    comandaNumero: comandaNumero.present
        ? comandaNumero.value
        : this.comandaNumero,
    statusImpressao: statusImpressao ?? this.statusImpressao,
    quantidadeImpressoes: quantidadeImpressoes ?? this.quantidadeImpressoes,
  );
  WeighingHistoryData copyWithCompanion(WeighingHistoryCompanion data) {
    return WeighingHistoryData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      produtoId: data.produtoId.present ? data.produtoId.value : this.produtoId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      peso: data.peso.present ? data.peso.value : this.peso,
      precoKg: data.precoKg.present ? data.precoKg.value : this.precoKg,
      valorTotal: data.valorTotal.present
          ? data.valorTotal.value
          : this.valorTotal,
      codigoBarras: data.codigoBarras.present
          ? data.codigoBarras.value
          : this.codigoBarras,
      layoutEtiqueta: data.layoutEtiqueta.present
          ? data.layoutEtiqueta.value
          : this.layoutEtiqueta,
      impressora: data.impressora.present
          ? data.impressora.value
          : this.impressora,
      comandaNumero: data.comandaNumero.present
          ? data.comandaNumero.value
          : this.comandaNumero,
      statusImpressao: data.statusImpressao.present
          ? data.statusImpressao.value
          : this.statusImpressao,
      quantidadeImpressoes: data.quantidadeImpressoes.present
          ? data.quantidadeImpressoes.value
          : this.quantidadeImpressoes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeighingHistoryData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('dataHora: $dataHora, ')
          ..write('produtoId: $produtoId, ')
          ..write('codigo: $codigo, ')
          ..write('descricao: $descricao, ')
          ..write('peso: $peso, ')
          ..write('precoKg: $precoKg, ')
          ..write('valorTotal: $valorTotal, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('layoutEtiqueta: $layoutEtiqueta, ')
          ..write('impressora: $impressora, ')
          ..write('comandaNumero: $comandaNumero, ')
          ..write('statusImpressao: $statusImpressao, ')
          ..write('quantidadeImpressoes: $quantidadeImpressoes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    dataHora,
    produtoId,
    codigo,
    descricao,
    peso,
    precoKg,
    valorTotal,
    codigoBarras,
    layoutEtiqueta,
    impressora,
    comandaNumero,
    statusImpressao,
    quantidadeImpressoes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeighingHistoryData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.dataHora == this.dataHora &&
          other.produtoId == this.produtoId &&
          other.codigo == this.codigo &&
          other.descricao == this.descricao &&
          other.peso == this.peso &&
          other.precoKg == this.precoKg &&
          other.valorTotal == this.valorTotal &&
          other.codigoBarras == this.codigoBarras &&
          other.layoutEtiqueta == this.layoutEtiqueta &&
          other.impressora == this.impressora &&
          other.comandaNumero == this.comandaNumero &&
          other.statusImpressao == this.statusImpressao &&
          other.quantidadeImpressoes == this.quantidadeImpressoes);
}

class WeighingHistoryCompanion extends UpdateCompanion<WeighingHistoryData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<DateTime> dataHora;
  final Value<int> produtoId;
  final Value<String> codigo;
  final Value<String> descricao;
  final Value<double> peso;
  final Value<double> precoKg;
  final Value<double> valorTotal;
  final Value<String?> codigoBarras;
  final Value<String?> layoutEtiqueta;
  final Value<String?> impressora;
  final Value<String?> comandaNumero;
  final Value<String> statusImpressao;
  final Value<int> quantidadeImpressoes;
  const WeighingHistoryCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.produtoId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.peso = const Value.absent(),
    this.precoKg = const Value.absent(),
    this.valorTotal = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.layoutEtiqueta = const Value.absent(),
    this.impressora = const Value.absent(),
    this.comandaNumero = const Value.absent(),
    this.statusImpressao = const Value.absent(),
    this.quantidadeImpressoes = const Value.absent(),
  });
  WeighingHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required DateTime dataHora,
    required int produtoId,
    required String codigo,
    required String descricao,
    required double peso,
    required double precoKg,
    required double valorTotal,
    this.codigoBarras = const Value.absent(),
    this.layoutEtiqueta = const Value.absent(),
    this.impressora = const Value.absent(),
    this.comandaNumero = const Value.absent(),
    this.statusImpressao = const Value.absent(),
    this.quantidadeImpressoes = const Value.absent(),
  }) : uuid = Value(uuid),
       dataHora = Value(dataHora),
       produtoId = Value(produtoId),
       codigo = Value(codigo),
       descricao = Value(descricao),
       peso = Value(peso),
       precoKg = Value(precoKg),
       valorTotal = Value(valorTotal);
  static Insertable<WeighingHistoryData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<DateTime>? dataHora,
    Expression<int>? produtoId,
    Expression<String>? codigo,
    Expression<String>? descricao,
    Expression<double>? peso,
    Expression<double>? precoKg,
    Expression<double>? valorTotal,
    Expression<String>? codigoBarras,
    Expression<String>? layoutEtiqueta,
    Expression<String>? impressora,
    Expression<String>? comandaNumero,
    Expression<String>? statusImpressao,
    Expression<int>? quantidadeImpressoes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (dataHora != null) 'data_hora': dataHora,
      if (produtoId != null) 'produto_id': produtoId,
      if (codigo != null) 'codigo': codigo,
      if (descricao != null) 'descricao': descricao,
      if (peso != null) 'peso': peso,
      if (precoKg != null) 'preco_kg': precoKg,
      if (valorTotal != null) 'valor_total': valorTotal,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (layoutEtiqueta != null) 'layout_etiqueta': layoutEtiqueta,
      if (impressora != null) 'impressora': impressora,
      if (comandaNumero != null) 'comanda_numero': comandaNumero,
      if (statusImpressao != null) 'status_impressao': statusImpressao,
      if (quantidadeImpressoes != null)
        'quantidade_impressoes': quantidadeImpressoes,
    });
  }

  WeighingHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<DateTime>? dataHora,
    Value<int>? produtoId,
    Value<String>? codigo,
    Value<String>? descricao,
    Value<double>? peso,
    Value<double>? precoKg,
    Value<double>? valorTotal,
    Value<String?>? codigoBarras,
    Value<String?>? layoutEtiqueta,
    Value<String?>? impressora,
    Value<String?>? comandaNumero,
    Value<String>? statusImpressao,
    Value<int>? quantidadeImpressoes,
  }) {
    return WeighingHistoryCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      dataHora: dataHora ?? this.dataHora,
      produtoId: produtoId ?? this.produtoId,
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
      peso: peso ?? this.peso,
      precoKg: precoKg ?? this.precoKg,
      valorTotal: valorTotal ?? this.valorTotal,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      layoutEtiqueta: layoutEtiqueta ?? this.layoutEtiqueta,
      impressora: impressora ?? this.impressora,
      comandaNumero: comandaNumero ?? this.comandaNumero,
      statusImpressao: statusImpressao ?? this.statusImpressao,
      quantidadeImpressoes: quantidadeImpressoes ?? this.quantidadeImpressoes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (produtoId.present) {
      map['produto_id'] = Variable<int>(produtoId.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (peso.present) {
      map['peso'] = Variable<double>(peso.value);
    }
    if (precoKg.present) {
      map['preco_kg'] = Variable<double>(precoKg.value);
    }
    if (valorTotal.present) {
      map['valor_total'] = Variable<double>(valorTotal.value);
    }
    if (codigoBarras.present) {
      map['codigo_barras'] = Variable<String>(codigoBarras.value);
    }
    if (layoutEtiqueta.present) {
      map['layout_etiqueta'] = Variable<String>(layoutEtiqueta.value);
    }
    if (impressora.present) {
      map['impressora'] = Variable<String>(impressora.value);
    }
    if (comandaNumero.present) {
      map['comanda_numero'] = Variable<String>(comandaNumero.value);
    }
    if (statusImpressao.present) {
      map['status_impressao'] = Variable<String>(statusImpressao.value);
    }
    if (quantidadeImpressoes.present) {
      map['quantidade_impressoes'] = Variable<int>(quantidadeImpressoes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeighingHistoryCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('dataHora: $dataHora, ')
          ..write('produtoId: $produtoId, ')
          ..write('codigo: $codigo, ')
          ..write('descricao: $descricao, ')
          ..write('peso: $peso, ')
          ..write('precoKg: $precoKg, ')
          ..write('valorTotal: $valorTotal, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('layoutEtiqueta: $layoutEtiqueta, ')
          ..write('impressora: $impressora, ')
          ..write('comandaNumero: $comandaNumero, ')
          ..write('statusImpressao: $statusImpressao, ')
          ..write('quantidadeImpressoes: $quantidadeImpressoes')
          ..write(')'))
        .toString();
  }
}

class $ImportHistoryTable extends ImportHistory
    with TableInfo<$ImportHistoryTable, ImportHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _arquivoMeta = const VerificationMeta(
    'arquivo',
  );
  @override
  late final GeneratedColumn<String> arquivo = GeneratedColumn<String>(
    'arquivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tamanhoMeta = const VerificationMeta(
    'tamanho',
  );
  @override
  late final GeneratedColumn<int> tamanho = GeneratedColumn<int>(
    'tamanho',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
    'hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataModificacaoMeta = const VerificationMeta(
    'dataModificacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataModificacao =
      GeneratedColumn<DateTime>(
        'data_modificacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataImportacaoMeta = const VerificationMeta(
    'dataImportacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataImportacao =
      GeneratedColumn<DateTime>(
        'data_importacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _quantidadeLinhasMeta = const VerificationMeta(
    'quantidadeLinhas',
  );
  @override
  late final GeneratedColumn<int> quantidadeLinhas = GeneratedColumn<int>(
    'quantidade_linhas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtosNovosMeta = const VerificationMeta(
    'produtosNovos',
  );
  @override
  late final GeneratedColumn<int> produtosNovos = GeneratedColumn<int>(
    'produtos_novos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtosAtualizadosMeta =
      const VerificationMeta('produtosAtualizados');
  @override
  late final GeneratedColumn<int> produtosAtualizados = GeneratedColumn<int>(
    'produtos_atualizados',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtosComErroMeta = const VerificationMeta(
    'produtosComErro',
  );
  @override
  late final GeneratedColumn<int> produtosComErro = GeneratedColumn<int>(
    'produtos_com_erro',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mensagemMeta = const VerificationMeta(
    'mensagem',
  );
  @override
  late final GeneratedColumn<String> mensagem = GeneratedColumn<String>(
    'mensagem',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errosMeta = const VerificationMeta('erros');
  @override
  late final GeneratedColumn<String> erros = GeneratedColumn<String>(
    'erros',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    arquivo,
    tamanho,
    hash,
    dataModificacao,
    dataImportacao,
    quantidadeLinhas,
    produtosNovos,
    produtosAtualizados,
    produtosComErro,
    status,
    mensagem,
    erros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arquivo')) {
      context.handle(
        _arquivoMeta,
        arquivo.isAcceptableOrUnknown(data['arquivo']!, _arquivoMeta),
      );
    } else if (isInserting) {
      context.missing(_arquivoMeta);
    }
    if (data.containsKey('tamanho')) {
      context.handle(
        _tamanhoMeta,
        tamanho.isAcceptableOrUnknown(data['tamanho']!, _tamanhoMeta),
      );
    } else if (isInserting) {
      context.missing(_tamanhoMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
        _hashMeta,
        hash.isAcceptableOrUnknown(data['hash']!, _hashMeta),
      );
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('data_modificacao')) {
      context.handle(
        _dataModificacaoMeta,
        dataModificacao.isAcceptableOrUnknown(
          data['data_modificacao']!,
          _dataModificacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataModificacaoMeta);
    }
    if (data.containsKey('data_importacao')) {
      context.handle(
        _dataImportacaoMeta,
        dataImportacao.isAcceptableOrUnknown(
          data['data_importacao']!,
          _dataImportacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataImportacaoMeta);
    }
    if (data.containsKey('quantidade_linhas')) {
      context.handle(
        _quantidadeLinhasMeta,
        quantidadeLinhas.isAcceptableOrUnknown(
          data['quantidade_linhas']!,
          _quantidadeLinhasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantidadeLinhasMeta);
    }
    if (data.containsKey('produtos_novos')) {
      context.handle(
        _produtosNovosMeta,
        produtosNovos.isAcceptableOrUnknown(
          data['produtos_novos']!,
          _produtosNovosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_produtosNovosMeta);
    }
    if (data.containsKey('produtos_atualizados')) {
      context.handle(
        _produtosAtualizadosMeta,
        produtosAtualizados.isAcceptableOrUnknown(
          data['produtos_atualizados']!,
          _produtosAtualizadosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_produtosAtualizadosMeta);
    }
    if (data.containsKey('produtos_com_erro')) {
      context.handle(
        _produtosComErroMeta,
        produtosComErro.isAcceptableOrUnknown(
          data['produtos_com_erro']!,
          _produtosComErroMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_produtosComErroMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('mensagem')) {
      context.handle(
        _mensagemMeta,
        mensagem.isAcceptableOrUnknown(data['mensagem']!, _mensagemMeta),
      );
    }
    if (data.containsKey('erros')) {
      context.handle(
        _errosMeta,
        erros.isAcceptableOrUnknown(data['erros']!, _errosMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      arquivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arquivo'],
      )!,
      tamanho: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tamanho'],
      )!,
      hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hash'],
      )!,
      dataModificacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_modificacao'],
      )!,
      dataImportacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_importacao'],
      )!,
      quantidadeLinhas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantidade_linhas'],
      )!,
      produtosNovos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produtos_novos'],
      )!,
      produtosAtualizados: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produtos_atualizados'],
      )!,
      produtosComErro: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produtos_com_erro'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      mensagem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mensagem'],
      ),
      erros: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}erros'],
      ),
    );
  }

  @override
  $ImportHistoryTable createAlias(String alias) {
    return $ImportHistoryTable(attachedDatabase, alias);
  }
}

class ImportHistoryData extends DataClass
    implements Insertable<ImportHistoryData> {
  final int id;
  final String arquivo;
  final int tamanho;
  final String hash;
  final DateTime dataModificacao;
  final DateTime dataImportacao;
  final int quantidadeLinhas;
  final int produtosNovos;
  final int produtosAtualizados;
  final int produtosComErro;

  /// Nome do enum `ImportStatus`.
  final String status;
  final String? mensagem;
  final String? erros;
  const ImportHistoryData({
    required this.id,
    required this.arquivo,
    required this.tamanho,
    required this.hash,
    required this.dataModificacao,
    required this.dataImportacao,
    required this.quantidadeLinhas,
    required this.produtosNovos,
    required this.produtosAtualizados,
    required this.produtosComErro,
    required this.status,
    this.mensagem,
    this.erros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arquivo'] = Variable<String>(arquivo);
    map['tamanho'] = Variable<int>(tamanho);
    map['hash'] = Variable<String>(hash);
    map['data_modificacao'] = Variable<DateTime>(dataModificacao);
    map['data_importacao'] = Variable<DateTime>(dataImportacao);
    map['quantidade_linhas'] = Variable<int>(quantidadeLinhas);
    map['produtos_novos'] = Variable<int>(produtosNovos);
    map['produtos_atualizados'] = Variable<int>(produtosAtualizados);
    map['produtos_com_erro'] = Variable<int>(produtosComErro);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || mensagem != null) {
      map['mensagem'] = Variable<String>(mensagem);
    }
    if (!nullToAbsent || erros != null) {
      map['erros'] = Variable<String>(erros);
    }
    return map;
  }

  ImportHistoryCompanion toCompanion(bool nullToAbsent) {
    return ImportHistoryCompanion(
      id: Value(id),
      arquivo: Value(arquivo),
      tamanho: Value(tamanho),
      hash: Value(hash),
      dataModificacao: Value(dataModificacao),
      dataImportacao: Value(dataImportacao),
      quantidadeLinhas: Value(quantidadeLinhas),
      produtosNovos: Value(produtosNovos),
      produtosAtualizados: Value(produtosAtualizados),
      produtosComErro: Value(produtosComErro),
      status: Value(status),
      mensagem: mensagem == null && nullToAbsent
          ? const Value.absent()
          : Value(mensagem),
      erros: erros == null && nullToAbsent
          ? const Value.absent()
          : Value(erros),
    );
  }

  factory ImportHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportHistoryData(
      id: serializer.fromJson<int>(json['id']),
      arquivo: serializer.fromJson<String>(json['arquivo']),
      tamanho: serializer.fromJson<int>(json['tamanho']),
      hash: serializer.fromJson<String>(json['hash']),
      dataModificacao: serializer.fromJson<DateTime>(json['dataModificacao']),
      dataImportacao: serializer.fromJson<DateTime>(json['dataImportacao']),
      quantidadeLinhas: serializer.fromJson<int>(json['quantidadeLinhas']),
      produtosNovos: serializer.fromJson<int>(json['produtosNovos']),
      produtosAtualizados: serializer.fromJson<int>(
        json['produtosAtualizados'],
      ),
      produtosComErro: serializer.fromJson<int>(json['produtosComErro']),
      status: serializer.fromJson<String>(json['status']),
      mensagem: serializer.fromJson<String?>(json['mensagem']),
      erros: serializer.fromJson<String?>(json['erros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arquivo': serializer.toJson<String>(arquivo),
      'tamanho': serializer.toJson<int>(tamanho),
      'hash': serializer.toJson<String>(hash),
      'dataModificacao': serializer.toJson<DateTime>(dataModificacao),
      'dataImportacao': serializer.toJson<DateTime>(dataImportacao),
      'quantidadeLinhas': serializer.toJson<int>(quantidadeLinhas),
      'produtosNovos': serializer.toJson<int>(produtosNovos),
      'produtosAtualizados': serializer.toJson<int>(produtosAtualizados),
      'produtosComErro': serializer.toJson<int>(produtosComErro),
      'status': serializer.toJson<String>(status),
      'mensagem': serializer.toJson<String?>(mensagem),
      'erros': serializer.toJson<String?>(erros),
    };
  }

  ImportHistoryData copyWith({
    int? id,
    String? arquivo,
    int? tamanho,
    String? hash,
    DateTime? dataModificacao,
    DateTime? dataImportacao,
    int? quantidadeLinhas,
    int? produtosNovos,
    int? produtosAtualizados,
    int? produtosComErro,
    String? status,
    Value<String?> mensagem = const Value.absent(),
    Value<String?> erros = const Value.absent(),
  }) => ImportHistoryData(
    id: id ?? this.id,
    arquivo: arquivo ?? this.arquivo,
    tamanho: tamanho ?? this.tamanho,
    hash: hash ?? this.hash,
    dataModificacao: dataModificacao ?? this.dataModificacao,
    dataImportacao: dataImportacao ?? this.dataImportacao,
    quantidadeLinhas: quantidadeLinhas ?? this.quantidadeLinhas,
    produtosNovos: produtosNovos ?? this.produtosNovos,
    produtosAtualizados: produtosAtualizados ?? this.produtosAtualizados,
    produtosComErro: produtosComErro ?? this.produtosComErro,
    status: status ?? this.status,
    mensagem: mensagem.present ? mensagem.value : this.mensagem,
    erros: erros.present ? erros.value : this.erros,
  );
  ImportHistoryData copyWithCompanion(ImportHistoryCompanion data) {
    return ImportHistoryData(
      id: data.id.present ? data.id.value : this.id,
      arquivo: data.arquivo.present ? data.arquivo.value : this.arquivo,
      tamanho: data.tamanho.present ? data.tamanho.value : this.tamanho,
      hash: data.hash.present ? data.hash.value : this.hash,
      dataModificacao: data.dataModificacao.present
          ? data.dataModificacao.value
          : this.dataModificacao,
      dataImportacao: data.dataImportacao.present
          ? data.dataImportacao.value
          : this.dataImportacao,
      quantidadeLinhas: data.quantidadeLinhas.present
          ? data.quantidadeLinhas.value
          : this.quantidadeLinhas,
      produtosNovos: data.produtosNovos.present
          ? data.produtosNovos.value
          : this.produtosNovos,
      produtosAtualizados: data.produtosAtualizados.present
          ? data.produtosAtualizados.value
          : this.produtosAtualizados,
      produtosComErro: data.produtosComErro.present
          ? data.produtosComErro.value
          : this.produtosComErro,
      status: data.status.present ? data.status.value : this.status,
      mensagem: data.mensagem.present ? data.mensagem.value : this.mensagem,
      erros: data.erros.present ? data.erros.value : this.erros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportHistoryData(')
          ..write('id: $id, ')
          ..write('arquivo: $arquivo, ')
          ..write('tamanho: $tamanho, ')
          ..write('hash: $hash, ')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('dataImportacao: $dataImportacao, ')
          ..write('quantidadeLinhas: $quantidadeLinhas, ')
          ..write('produtosNovos: $produtosNovos, ')
          ..write('produtosAtualizados: $produtosAtualizados, ')
          ..write('produtosComErro: $produtosComErro, ')
          ..write('status: $status, ')
          ..write('mensagem: $mensagem, ')
          ..write('erros: $erros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    arquivo,
    tamanho,
    hash,
    dataModificacao,
    dataImportacao,
    quantidadeLinhas,
    produtosNovos,
    produtosAtualizados,
    produtosComErro,
    status,
    mensagem,
    erros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportHistoryData &&
          other.id == this.id &&
          other.arquivo == this.arquivo &&
          other.tamanho == this.tamanho &&
          other.hash == this.hash &&
          other.dataModificacao == this.dataModificacao &&
          other.dataImportacao == this.dataImportacao &&
          other.quantidadeLinhas == this.quantidadeLinhas &&
          other.produtosNovos == this.produtosNovos &&
          other.produtosAtualizados == this.produtosAtualizados &&
          other.produtosComErro == this.produtosComErro &&
          other.status == this.status &&
          other.mensagem == this.mensagem &&
          other.erros == this.erros);
}

class ImportHistoryCompanion extends UpdateCompanion<ImportHistoryData> {
  final Value<int> id;
  final Value<String> arquivo;
  final Value<int> tamanho;
  final Value<String> hash;
  final Value<DateTime> dataModificacao;
  final Value<DateTime> dataImportacao;
  final Value<int> quantidadeLinhas;
  final Value<int> produtosNovos;
  final Value<int> produtosAtualizados;
  final Value<int> produtosComErro;
  final Value<String> status;
  final Value<String?> mensagem;
  final Value<String?> erros;
  const ImportHistoryCompanion({
    this.id = const Value.absent(),
    this.arquivo = const Value.absent(),
    this.tamanho = const Value.absent(),
    this.hash = const Value.absent(),
    this.dataModificacao = const Value.absent(),
    this.dataImportacao = const Value.absent(),
    this.quantidadeLinhas = const Value.absent(),
    this.produtosNovos = const Value.absent(),
    this.produtosAtualizados = const Value.absent(),
    this.produtosComErro = const Value.absent(),
    this.status = const Value.absent(),
    this.mensagem = const Value.absent(),
    this.erros = const Value.absent(),
  });
  ImportHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String arquivo,
    required int tamanho,
    required String hash,
    required DateTime dataModificacao,
    required DateTime dataImportacao,
    required int quantidadeLinhas,
    required int produtosNovos,
    required int produtosAtualizados,
    required int produtosComErro,
    required String status,
    this.mensagem = const Value.absent(),
    this.erros = const Value.absent(),
  }) : arquivo = Value(arquivo),
       tamanho = Value(tamanho),
       hash = Value(hash),
       dataModificacao = Value(dataModificacao),
       dataImportacao = Value(dataImportacao),
       quantidadeLinhas = Value(quantidadeLinhas),
       produtosNovos = Value(produtosNovos),
       produtosAtualizados = Value(produtosAtualizados),
       produtosComErro = Value(produtosComErro),
       status = Value(status);
  static Insertable<ImportHistoryData> custom({
    Expression<int>? id,
    Expression<String>? arquivo,
    Expression<int>? tamanho,
    Expression<String>? hash,
    Expression<DateTime>? dataModificacao,
    Expression<DateTime>? dataImportacao,
    Expression<int>? quantidadeLinhas,
    Expression<int>? produtosNovos,
    Expression<int>? produtosAtualizados,
    Expression<int>? produtosComErro,
    Expression<String>? status,
    Expression<String>? mensagem,
    Expression<String>? erros,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arquivo != null) 'arquivo': arquivo,
      if (tamanho != null) 'tamanho': tamanho,
      if (hash != null) 'hash': hash,
      if (dataModificacao != null) 'data_modificacao': dataModificacao,
      if (dataImportacao != null) 'data_importacao': dataImportacao,
      if (quantidadeLinhas != null) 'quantidade_linhas': quantidadeLinhas,
      if (produtosNovos != null) 'produtos_novos': produtosNovos,
      if (produtosAtualizados != null)
        'produtos_atualizados': produtosAtualizados,
      if (produtosComErro != null) 'produtos_com_erro': produtosComErro,
      if (status != null) 'status': status,
      if (mensagem != null) 'mensagem': mensagem,
      if (erros != null) 'erros': erros,
    });
  }

  ImportHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? arquivo,
    Value<int>? tamanho,
    Value<String>? hash,
    Value<DateTime>? dataModificacao,
    Value<DateTime>? dataImportacao,
    Value<int>? quantidadeLinhas,
    Value<int>? produtosNovos,
    Value<int>? produtosAtualizados,
    Value<int>? produtosComErro,
    Value<String>? status,
    Value<String?>? mensagem,
    Value<String?>? erros,
  }) {
    return ImportHistoryCompanion(
      id: id ?? this.id,
      arquivo: arquivo ?? this.arquivo,
      tamanho: tamanho ?? this.tamanho,
      hash: hash ?? this.hash,
      dataModificacao: dataModificacao ?? this.dataModificacao,
      dataImportacao: dataImportacao ?? this.dataImportacao,
      quantidadeLinhas: quantidadeLinhas ?? this.quantidadeLinhas,
      produtosNovos: produtosNovos ?? this.produtosNovos,
      produtosAtualizados: produtosAtualizados ?? this.produtosAtualizados,
      produtosComErro: produtosComErro ?? this.produtosComErro,
      status: status ?? this.status,
      mensagem: mensagem ?? this.mensagem,
      erros: erros ?? this.erros,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arquivo.present) {
      map['arquivo'] = Variable<String>(arquivo.value);
    }
    if (tamanho.present) {
      map['tamanho'] = Variable<int>(tamanho.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (dataModificacao.present) {
      map['data_modificacao'] = Variable<DateTime>(dataModificacao.value);
    }
    if (dataImportacao.present) {
      map['data_importacao'] = Variable<DateTime>(dataImportacao.value);
    }
    if (quantidadeLinhas.present) {
      map['quantidade_linhas'] = Variable<int>(quantidadeLinhas.value);
    }
    if (produtosNovos.present) {
      map['produtos_novos'] = Variable<int>(produtosNovos.value);
    }
    if (produtosAtualizados.present) {
      map['produtos_atualizados'] = Variable<int>(produtosAtualizados.value);
    }
    if (produtosComErro.present) {
      map['produtos_com_erro'] = Variable<int>(produtosComErro.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (mensagem.present) {
      map['mensagem'] = Variable<String>(mensagem.value);
    }
    if (erros.present) {
      map['erros'] = Variable<String>(erros.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportHistoryCompanion(')
          ..write('id: $id, ')
          ..write('arquivo: $arquivo, ')
          ..write('tamanho: $tamanho, ')
          ..write('hash: $hash, ')
          ..write('dataModificacao: $dataModificacao, ')
          ..write('dataImportacao: $dataImportacao, ')
          ..write('quantidadeLinhas: $quantidadeLinhas, ')
          ..write('produtosNovos: $produtosNovos, ')
          ..write('produtosAtualizados: $produtosAtualizados, ')
          ..write('produtosComErro: $produtosComErro, ')
          ..write('status: $status, ')
          ..write('mensagem: $mensagem, ')
          ..write('erros: $erros')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, Label> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _larguraMmMeta = const VerificationMeta(
    'larguraMm',
  );
  @override
  late final GeneratedColumn<double> larguraMm = GeneratedColumn<double>(
    'largura_mm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alturaMmMeta = const VerificationMeta(
    'alturaMm',
  );
  @override
  late final GeneratedColumn<double> alturaMm = GeneratedColumn<double>(
    'altura_mm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _padraoMeta = const VerificationMeta('padrao');
  @override
  late final GeneratedColumn<bool> padrao = GeneratedColumn<bool>(
    'padrao',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("padrao" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataAtualizacaoMeta = const VerificationMeta(
    'dataAtualizacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataAtualizacao =
      GeneratedColumn<DateTime>(
        'data_atualizacao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    larguraMm,
    alturaMm,
    padrao,
    dataCriacao,
    dataAtualizacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Label> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('largura_mm')) {
      context.handle(
        _larguraMmMeta,
        larguraMm.isAcceptableOrUnknown(data['largura_mm']!, _larguraMmMeta),
      );
    } else if (isInserting) {
      context.missing(_larguraMmMeta);
    }
    if (data.containsKey('altura_mm')) {
      context.handle(
        _alturaMmMeta,
        alturaMm.isAcceptableOrUnknown(data['altura_mm']!, _alturaMmMeta),
      );
    } else if (isInserting) {
      context.missing(_alturaMmMeta);
    }
    if (data.containsKey('padrao')) {
      context.handle(
        _padraoMeta,
        padrao.isAcceptableOrUnknown(data['padrao']!, _padraoMeta),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('data_atualizacao')) {
      context.handle(
        _dataAtualizacaoMeta,
        dataAtualizacao.isAcceptableOrUnknown(
          data['data_atualizacao']!,
          _dataAtualizacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataAtualizacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Label map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Label(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      larguraMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}largura_mm'],
      )!,
      alturaMm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altura_mm'],
      )!,
      padrao: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}padrao'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      dataAtualizacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_atualizacao'],
      )!,
    );
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(attachedDatabase, alias);
  }
}

class Label extends DataClass implements Insertable<Label> {
  final int id;
  final String nome;
  final double larguraMm;
  final double alturaMm;
  final bool padrao;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;
  const Label({
    required this.id,
    required this.nome,
    required this.larguraMm,
    required this.alturaMm,
    required this.padrao,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['largura_mm'] = Variable<double>(larguraMm);
    map['altura_mm'] = Variable<double>(alturaMm);
    map['padrao'] = Variable<bool>(padrao);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao);
    return map;
  }

  LabelsCompanion toCompanion(bool nullToAbsent) {
    return LabelsCompanion(
      id: Value(id),
      nome: Value(nome),
      larguraMm: Value(larguraMm),
      alturaMm: Value(alturaMm),
      padrao: Value(padrao),
      dataCriacao: Value(dataCriacao),
      dataAtualizacao: Value(dataAtualizacao),
    );
  }

  factory Label.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Label(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      larguraMm: serializer.fromJson<double>(json['larguraMm']),
      alturaMm: serializer.fromJson<double>(json['alturaMm']),
      padrao: serializer.fromJson<bool>(json['padrao']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      dataAtualizacao: serializer.fromJson<DateTime>(json['dataAtualizacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'larguraMm': serializer.toJson<double>(larguraMm),
      'alturaMm': serializer.toJson<double>(alturaMm),
      'padrao': serializer.toJson<bool>(padrao),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'dataAtualizacao': serializer.toJson<DateTime>(dataAtualizacao),
    };
  }

  Label copyWith({
    int? id,
    String? nome,
    double? larguraMm,
    double? alturaMm,
    bool? padrao,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) => Label(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    larguraMm: larguraMm ?? this.larguraMm,
    alturaMm: alturaMm ?? this.alturaMm,
    padrao: padrao ?? this.padrao,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
  );
  Label copyWithCompanion(LabelsCompanion data) {
    return Label(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      larguraMm: data.larguraMm.present ? data.larguraMm.value : this.larguraMm,
      alturaMm: data.alturaMm.present ? data.alturaMm.value : this.alturaMm,
      padrao: data.padrao.present ? data.padrao.value : this.padrao,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      dataAtualizacao: data.dataAtualizacao.present
          ? data.dataAtualizacao.value
          : this.dataAtualizacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Label(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('larguraMm: $larguraMm, ')
          ..write('alturaMm: $alturaMm, ')
          ..write('padrao: $padrao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    larguraMm,
    alturaMm,
    padrao,
    dataCriacao,
    dataAtualizacao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Label &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.larguraMm == this.larguraMm &&
          other.alturaMm == this.alturaMm &&
          other.padrao == this.padrao &&
          other.dataCriacao == this.dataCriacao &&
          other.dataAtualizacao == this.dataAtualizacao);
}

class LabelsCompanion extends UpdateCompanion<Label> {
  final Value<int> id;
  final Value<String> nome;
  final Value<double> larguraMm;
  final Value<double> alturaMm;
  final Value<bool> padrao;
  final Value<DateTime> dataCriacao;
  final Value<DateTime> dataAtualizacao;
  const LabelsCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.larguraMm = const Value.absent(),
    this.alturaMm = const Value.absent(),
    this.padrao = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.dataAtualizacao = const Value.absent(),
  });
  LabelsCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required double larguraMm,
    required double alturaMm,
    this.padrao = const Value.absent(),
    required DateTime dataCriacao,
    required DateTime dataAtualizacao,
  }) : nome = Value(nome),
       larguraMm = Value(larguraMm),
       alturaMm = Value(alturaMm),
       dataCriacao = Value(dataCriacao),
       dataAtualizacao = Value(dataAtualizacao);
  static Insertable<Label> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<double>? larguraMm,
    Expression<double>? alturaMm,
    Expression<bool>? padrao,
    Expression<DateTime>? dataCriacao,
    Expression<DateTime>? dataAtualizacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (larguraMm != null) 'largura_mm': larguraMm,
      if (alturaMm != null) 'altura_mm': alturaMm,
      if (padrao != null) 'padrao': padrao,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (dataAtualizacao != null) 'data_atualizacao': dataAtualizacao,
    });
  }

  LabelsCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<double>? larguraMm,
    Value<double>? alturaMm,
    Value<bool>? padrao,
    Value<DateTime>? dataCriacao,
    Value<DateTime>? dataAtualizacao,
  }) {
    return LabelsCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      larguraMm: larguraMm ?? this.larguraMm,
      alturaMm: alturaMm ?? this.alturaMm,
      padrao: padrao ?? this.padrao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (larguraMm.present) {
      map['largura_mm'] = Variable<double>(larguraMm.value);
    }
    if (alturaMm.present) {
      map['altura_mm'] = Variable<double>(alturaMm.value);
    }
    if (padrao.present) {
      map['padrao'] = Variable<bool>(padrao.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (dataAtualizacao.present) {
      map['data_atualizacao'] = Variable<DateTime>(dataAtualizacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('larguraMm: $larguraMm, ')
          ..write('alturaMm: $alturaMm, ')
          ..write('padrao: $padrao, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('dataAtualizacao: $dataAtualizacao')
          ..write(')'))
        .toString();
  }
}

class $LabelElementsTable extends LabelElements
    with TableInfo<$LabelElementsTable, LabelElement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelElementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelIdMeta = const VerificationMeta(
    'labelId',
  );
  @override
  late final GeneratedColumn<int> labelId = GeneratedColumn<int>(
    'label_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES labels (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _larguraMeta = const VerificationMeta(
    'largura',
  );
  @override
  late final GeneratedColumn<double> largura = GeneratedColumn<double>(
    'largura',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alturaMeta = const VerificationMeta('altura');
  @override
  late final GeneratedColumn<double> altura = GeneratedColumn<double>(
    'altura',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotacaoMeta = const VerificationMeta(
    'rotacao',
  );
  @override
  late final GeneratedColumn<double> rotacao = GeneratedColumn<double>(
    'rotacao',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fonteFamiliaMeta = const VerificationMeta(
    'fonteFamilia',
  );
  @override
  late final GeneratedColumn<String> fonteFamilia = GeneratedColumn<String>(
    'fonte_familia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Roboto'),
  );
  static const VerificationMeta _fonteTamanhoMeta = const VerificationMeta(
    'fonteTamanho',
  );
  @override
  late final GeneratedColumn<double> fonteTamanho = GeneratedColumn<double>(
    'fonte_tamanho',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _negritoMeta = const VerificationMeta(
    'negrito',
  );
  @override
  late final GeneratedColumn<bool> negrito = GeneratedColumn<bool>(
    'negrito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("negrito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alinhamentoMeta = const VerificationMeta(
    'alinhamento',
  );
  @override
  late final GeneratedColumn<String> alinhamento = GeneratedColumn<String>(
    'alinhamento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('left'),
  );
  static const VerificationMeta _conteudoLivreMeta = const VerificationMeta(
    'conteudoLivre',
  );
  @override
  late final GeneratedColumn<String> conteudoLivre = GeneratedColumn<String>(
    'conteudo_livre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    labelId,
    tipo,
    x,
    y,
    largura,
    altura,
    rotacao,
    fonteFamilia,
    fonteTamanho,
    negrito,
    alinhamento,
    conteudoLivre,
    ordem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'label_elements';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabelElement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label_id')) {
      context.handle(
        _labelIdMeta,
        labelId.isAcceptableOrUnknown(data['label_id']!, _labelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_labelIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('largura')) {
      context.handle(
        _larguraMeta,
        largura.isAcceptableOrUnknown(data['largura']!, _larguraMeta),
      );
    } else if (isInserting) {
      context.missing(_larguraMeta);
    }
    if (data.containsKey('altura')) {
      context.handle(
        _alturaMeta,
        altura.isAcceptableOrUnknown(data['altura']!, _alturaMeta),
      );
    } else if (isInserting) {
      context.missing(_alturaMeta);
    }
    if (data.containsKey('rotacao')) {
      context.handle(
        _rotacaoMeta,
        rotacao.isAcceptableOrUnknown(data['rotacao']!, _rotacaoMeta),
      );
    }
    if (data.containsKey('fonte_familia')) {
      context.handle(
        _fonteFamiliaMeta,
        fonteFamilia.isAcceptableOrUnknown(
          data['fonte_familia']!,
          _fonteFamiliaMeta,
        ),
      );
    }
    if (data.containsKey('fonte_tamanho')) {
      context.handle(
        _fonteTamanhoMeta,
        fonteTamanho.isAcceptableOrUnknown(
          data['fonte_tamanho']!,
          _fonteTamanhoMeta,
        ),
      );
    }
    if (data.containsKey('negrito')) {
      context.handle(
        _negritoMeta,
        negrito.isAcceptableOrUnknown(data['negrito']!, _negritoMeta),
      );
    }
    if (data.containsKey('alinhamento')) {
      context.handle(
        _alinhamentoMeta,
        alinhamento.isAcceptableOrUnknown(
          data['alinhamento']!,
          _alinhamentoMeta,
        ),
      );
    }
    if (data.containsKey('conteudo_livre')) {
      context.handle(
        _conteudoLivreMeta,
        conteudoLivre.isAcceptableOrUnknown(
          data['conteudo_livre']!,
          _conteudoLivreMeta,
        ),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabelElement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabelElement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      labelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}label_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      largura: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}largura'],
      )!,
      altura: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altura'],
      )!,
      rotacao: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rotacao'],
      )!,
      fonteFamilia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fonte_familia'],
      )!,
      fonteTamanho: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fonte_tamanho'],
      )!,
      negrito: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}negrito'],
      )!,
      alinhamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alinhamento'],
      )!,
      conteudoLivre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conteudo_livre'],
      ),
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $LabelElementsTable createAlias(String alias) {
    return $LabelElementsTable(attachedDatabase, alias);
  }
}

class LabelElement extends DataClass implements Insertable<LabelElement> {
  final int id;
  final int labelId;

  /// Nome do enum `LabelElementType`.
  final String tipo;
  final double x;
  final double y;
  final double largura;
  final double altura;
  final double rotacao;
  final String fonteFamilia;
  final double fonteTamanho;
  final bool negrito;

  /// Nome do enum `LabelTextAlign`.
  final String alinhamento;
  final String? conteudoLivre;
  final int ordem;
  const LabelElement({
    required this.id,
    required this.labelId,
    required this.tipo,
    required this.x,
    required this.y,
    required this.largura,
    required this.altura,
    required this.rotacao,
    required this.fonteFamilia,
    required this.fonteTamanho,
    required this.negrito,
    required this.alinhamento,
    this.conteudoLivre,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label_id'] = Variable<int>(labelId);
    map['tipo'] = Variable<String>(tipo);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['largura'] = Variable<double>(largura);
    map['altura'] = Variable<double>(altura);
    map['rotacao'] = Variable<double>(rotacao);
    map['fonte_familia'] = Variable<String>(fonteFamilia);
    map['fonte_tamanho'] = Variable<double>(fonteTamanho);
    map['negrito'] = Variable<bool>(negrito);
    map['alinhamento'] = Variable<String>(alinhamento);
    if (!nullToAbsent || conteudoLivre != null) {
      map['conteudo_livre'] = Variable<String>(conteudoLivre);
    }
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  LabelElementsCompanion toCompanion(bool nullToAbsent) {
    return LabelElementsCompanion(
      id: Value(id),
      labelId: Value(labelId),
      tipo: Value(tipo),
      x: Value(x),
      y: Value(y),
      largura: Value(largura),
      altura: Value(altura),
      rotacao: Value(rotacao),
      fonteFamilia: Value(fonteFamilia),
      fonteTamanho: Value(fonteTamanho),
      negrito: Value(negrito),
      alinhamento: Value(alinhamento),
      conteudoLivre: conteudoLivre == null && nullToAbsent
          ? const Value.absent()
          : Value(conteudoLivre),
      ordem: Value(ordem),
    );
  }

  factory LabelElement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabelElement(
      id: serializer.fromJson<int>(json['id']),
      labelId: serializer.fromJson<int>(json['labelId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      largura: serializer.fromJson<double>(json['largura']),
      altura: serializer.fromJson<double>(json['altura']),
      rotacao: serializer.fromJson<double>(json['rotacao']),
      fonteFamilia: serializer.fromJson<String>(json['fonteFamilia']),
      fonteTamanho: serializer.fromJson<double>(json['fonteTamanho']),
      negrito: serializer.fromJson<bool>(json['negrito']),
      alinhamento: serializer.fromJson<String>(json['alinhamento']),
      conteudoLivre: serializer.fromJson<String?>(json['conteudoLivre']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'labelId': serializer.toJson<int>(labelId),
      'tipo': serializer.toJson<String>(tipo),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'largura': serializer.toJson<double>(largura),
      'altura': serializer.toJson<double>(altura),
      'rotacao': serializer.toJson<double>(rotacao),
      'fonteFamilia': serializer.toJson<String>(fonteFamilia),
      'fonteTamanho': serializer.toJson<double>(fonteTamanho),
      'negrito': serializer.toJson<bool>(negrito),
      'alinhamento': serializer.toJson<String>(alinhamento),
      'conteudoLivre': serializer.toJson<String?>(conteudoLivre),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  LabelElement copyWith({
    int? id,
    int? labelId,
    String? tipo,
    double? x,
    double? y,
    double? largura,
    double? altura,
    double? rotacao,
    String? fonteFamilia,
    double? fonteTamanho,
    bool? negrito,
    String? alinhamento,
    Value<String?> conteudoLivre = const Value.absent(),
    int? ordem,
  }) => LabelElement(
    id: id ?? this.id,
    labelId: labelId ?? this.labelId,
    tipo: tipo ?? this.tipo,
    x: x ?? this.x,
    y: y ?? this.y,
    largura: largura ?? this.largura,
    altura: altura ?? this.altura,
    rotacao: rotacao ?? this.rotacao,
    fonteFamilia: fonteFamilia ?? this.fonteFamilia,
    fonteTamanho: fonteTamanho ?? this.fonteTamanho,
    negrito: negrito ?? this.negrito,
    alinhamento: alinhamento ?? this.alinhamento,
    conteudoLivre: conteudoLivre.present
        ? conteudoLivre.value
        : this.conteudoLivre,
    ordem: ordem ?? this.ordem,
  );
  LabelElement copyWithCompanion(LabelElementsCompanion data) {
    return LabelElement(
      id: data.id.present ? data.id.value : this.id,
      labelId: data.labelId.present ? data.labelId.value : this.labelId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      largura: data.largura.present ? data.largura.value : this.largura,
      altura: data.altura.present ? data.altura.value : this.altura,
      rotacao: data.rotacao.present ? data.rotacao.value : this.rotacao,
      fonteFamilia: data.fonteFamilia.present
          ? data.fonteFamilia.value
          : this.fonteFamilia,
      fonteTamanho: data.fonteTamanho.present
          ? data.fonteTamanho.value
          : this.fonteTamanho,
      negrito: data.negrito.present ? data.negrito.value : this.negrito,
      alinhamento: data.alinhamento.present
          ? data.alinhamento.value
          : this.alinhamento,
      conteudoLivre: data.conteudoLivre.present
          ? data.conteudoLivre.value
          : this.conteudoLivre,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabelElement(')
          ..write('id: $id, ')
          ..write('labelId: $labelId, ')
          ..write('tipo: $tipo, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('largura: $largura, ')
          ..write('altura: $altura, ')
          ..write('rotacao: $rotacao, ')
          ..write('fonteFamilia: $fonteFamilia, ')
          ..write('fonteTamanho: $fonteTamanho, ')
          ..write('negrito: $negrito, ')
          ..write('alinhamento: $alinhamento, ')
          ..write('conteudoLivre: $conteudoLivre, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    labelId,
    tipo,
    x,
    y,
    largura,
    altura,
    rotacao,
    fonteFamilia,
    fonteTamanho,
    negrito,
    alinhamento,
    conteudoLivre,
    ordem,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabelElement &&
          other.id == this.id &&
          other.labelId == this.labelId &&
          other.tipo == this.tipo &&
          other.x == this.x &&
          other.y == this.y &&
          other.largura == this.largura &&
          other.altura == this.altura &&
          other.rotacao == this.rotacao &&
          other.fonteFamilia == this.fonteFamilia &&
          other.fonteTamanho == this.fonteTamanho &&
          other.negrito == this.negrito &&
          other.alinhamento == this.alinhamento &&
          other.conteudoLivre == this.conteudoLivre &&
          other.ordem == this.ordem);
}

class LabelElementsCompanion extends UpdateCompanion<LabelElement> {
  final Value<int> id;
  final Value<int> labelId;
  final Value<String> tipo;
  final Value<double> x;
  final Value<double> y;
  final Value<double> largura;
  final Value<double> altura;
  final Value<double> rotacao;
  final Value<String> fonteFamilia;
  final Value<double> fonteTamanho;
  final Value<bool> negrito;
  final Value<String> alinhamento;
  final Value<String?> conteudoLivre;
  final Value<int> ordem;
  const LabelElementsCompanion({
    this.id = const Value.absent(),
    this.labelId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.largura = const Value.absent(),
    this.altura = const Value.absent(),
    this.rotacao = const Value.absent(),
    this.fonteFamilia = const Value.absent(),
    this.fonteTamanho = const Value.absent(),
    this.negrito = const Value.absent(),
    this.alinhamento = const Value.absent(),
    this.conteudoLivre = const Value.absent(),
    this.ordem = const Value.absent(),
  });
  LabelElementsCompanion.insert({
    this.id = const Value.absent(),
    required int labelId,
    required String tipo,
    required double x,
    required double y,
    required double largura,
    required double altura,
    this.rotacao = const Value.absent(),
    this.fonteFamilia = const Value.absent(),
    this.fonteTamanho = const Value.absent(),
    this.negrito = const Value.absent(),
    this.alinhamento = const Value.absent(),
    this.conteudoLivre = const Value.absent(),
    this.ordem = const Value.absent(),
  }) : labelId = Value(labelId),
       tipo = Value(tipo),
       x = Value(x),
       y = Value(y),
       largura = Value(largura),
       altura = Value(altura);
  static Insertable<LabelElement> custom({
    Expression<int>? id,
    Expression<int>? labelId,
    Expression<String>? tipo,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? largura,
    Expression<double>? altura,
    Expression<double>? rotacao,
    Expression<String>? fonteFamilia,
    Expression<double>? fonteTamanho,
    Expression<bool>? negrito,
    Expression<String>? alinhamento,
    Expression<String>? conteudoLivre,
    Expression<int>? ordem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (labelId != null) 'label_id': labelId,
      if (tipo != null) 'tipo': tipo,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (largura != null) 'largura': largura,
      if (altura != null) 'altura': altura,
      if (rotacao != null) 'rotacao': rotacao,
      if (fonteFamilia != null) 'fonte_familia': fonteFamilia,
      if (fonteTamanho != null) 'fonte_tamanho': fonteTamanho,
      if (negrito != null) 'negrito': negrito,
      if (alinhamento != null) 'alinhamento': alinhamento,
      if (conteudoLivre != null) 'conteudo_livre': conteudoLivre,
      if (ordem != null) 'ordem': ordem,
    });
  }

  LabelElementsCompanion copyWith({
    Value<int>? id,
    Value<int>? labelId,
    Value<String>? tipo,
    Value<double>? x,
    Value<double>? y,
    Value<double>? largura,
    Value<double>? altura,
    Value<double>? rotacao,
    Value<String>? fonteFamilia,
    Value<double>? fonteTamanho,
    Value<bool>? negrito,
    Value<String>? alinhamento,
    Value<String?>? conteudoLivre,
    Value<int>? ordem,
  }) {
    return LabelElementsCompanion(
      id: id ?? this.id,
      labelId: labelId ?? this.labelId,
      tipo: tipo ?? this.tipo,
      x: x ?? this.x,
      y: y ?? this.y,
      largura: largura ?? this.largura,
      altura: altura ?? this.altura,
      rotacao: rotacao ?? this.rotacao,
      fonteFamilia: fonteFamilia ?? this.fonteFamilia,
      fonteTamanho: fonteTamanho ?? this.fonteTamanho,
      negrito: negrito ?? this.negrito,
      alinhamento: alinhamento ?? this.alinhamento,
      conteudoLivre: conteudoLivre ?? this.conteudoLivre,
      ordem: ordem ?? this.ordem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (labelId.present) {
      map['label_id'] = Variable<int>(labelId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (largura.present) {
      map['largura'] = Variable<double>(largura.value);
    }
    if (altura.present) {
      map['altura'] = Variable<double>(altura.value);
    }
    if (rotacao.present) {
      map['rotacao'] = Variable<double>(rotacao.value);
    }
    if (fonteFamilia.present) {
      map['fonte_familia'] = Variable<String>(fonteFamilia.value);
    }
    if (fonteTamanho.present) {
      map['fonte_tamanho'] = Variable<double>(fonteTamanho.value);
    }
    if (negrito.present) {
      map['negrito'] = Variable<bool>(negrito.value);
    }
    if (alinhamento.present) {
      map['alinhamento'] = Variable<String>(alinhamento.value);
    }
    if (conteudoLivre.present) {
      map['conteudo_livre'] = Variable<String>(conteudoLivre.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelElementsCompanion(')
          ..write('id: $id, ')
          ..write('labelId: $labelId, ')
          ..write('tipo: $tipo, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('largura: $largura, ')
          ..write('altura: $altura, ')
          ..write('rotacao: $rotacao, ')
          ..write('fonteFamilia: $fonteFamilia, ')
          ..write('fonteTamanho: $fonteTamanho, ')
          ..write('negrito: $negrito, ')
          ..write('alinhamento: $alinhamento, ')
          ..write('conteudoLivre: $conteudoLivre, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }
}

class $PrintersTable extends Printers with TableInfo<$PrintersTable, Printer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrintersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enderecoMeta = const VerificationMeta(
    'endereco',
  );
  @override
  late final GeneratedColumn<String> endereco = GeneratedColumn<String>(
    'endereco',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tipoConexaoMeta = const VerificationMeta(
    'tipoConexao',
  );
  @override
  late final GeneratedColumn<String> tipoConexao = GeneratedColumn<String>(
    'tipo_conexao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocoloMeta = const VerificationMeta(
    'protocolo',
  );
  @override
  late final GeneratedColumn<String> protocolo = GeneratedColumn<String>(
    'protocolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _padraoMeta = const VerificationMeta('padrao');
  @override
  late final GeneratedColumn<bool> padrao = GeneratedColumn<bool>(
    'padrao',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("padrao" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ultimaConexaoMeta = const VerificationMeta(
    'ultimaConexao',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaConexao =
      GeneratedColumn<DateTime>(
        'ultima_conexao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    endereco,
    tipoConexao,
    protocolo,
    padrao,
    ultimaConexao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Printer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('endereco')) {
      context.handle(
        _enderecoMeta,
        endereco.isAcceptableOrUnknown(data['endereco']!, _enderecoMeta),
      );
    } else if (isInserting) {
      context.missing(_enderecoMeta);
    }
    if (data.containsKey('tipo_conexao')) {
      context.handle(
        _tipoConexaoMeta,
        tipoConexao.isAcceptableOrUnknown(
          data['tipo_conexao']!,
          _tipoConexaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoConexaoMeta);
    }
    if (data.containsKey('protocolo')) {
      context.handle(
        _protocoloMeta,
        protocolo.isAcceptableOrUnknown(data['protocolo']!, _protocoloMeta),
      );
    } else if (isInserting) {
      context.missing(_protocoloMeta);
    }
    if (data.containsKey('padrao')) {
      context.handle(
        _padraoMeta,
        padrao.isAcceptableOrUnknown(data['padrao']!, _padraoMeta),
      );
    }
    if (data.containsKey('ultima_conexao')) {
      context.handle(
        _ultimaConexaoMeta,
        ultimaConexao.isAcceptableOrUnknown(
          data['ultima_conexao']!,
          _ultimaConexaoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Printer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Printer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      endereco: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endereco'],
      )!,
      tipoConexao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_conexao'],
      )!,
      protocolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocolo'],
      )!,
      padrao: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}padrao'],
      )!,
      ultimaConexao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_conexao'],
      ),
    );
  }

  @override
  $PrintersTable createAlias(String alias) {
    return $PrintersTable(attachedDatabase, alias);
  }
}

class Printer extends DataClass implements Insertable<Printer> {
  final int id;
  final String nome;

  /// Endereço MAC (Bluetooth) ou host:porta (TCP).
  final String endereco;

  /// Nome do enum `PrinterTransportType`.
  final String tipoConexao;

  /// Nome do enum `PrinterProtocolType`.
  final String protocolo;
  final bool padrao;
  final DateTime? ultimaConexao;
  const Printer({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.tipoConexao,
    required this.protocolo,
    required this.padrao,
    this.ultimaConexao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['endereco'] = Variable<String>(endereco);
    map['tipo_conexao'] = Variable<String>(tipoConexao);
    map['protocolo'] = Variable<String>(protocolo);
    map['padrao'] = Variable<bool>(padrao);
    if (!nullToAbsent || ultimaConexao != null) {
      map['ultima_conexao'] = Variable<DateTime>(ultimaConexao);
    }
    return map;
  }

  PrintersCompanion toCompanion(bool nullToAbsent) {
    return PrintersCompanion(
      id: Value(id),
      nome: Value(nome),
      endereco: Value(endereco),
      tipoConexao: Value(tipoConexao),
      protocolo: Value(protocolo),
      padrao: Value(padrao),
      ultimaConexao: ultimaConexao == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaConexao),
    );
  }

  factory Printer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Printer(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      endereco: serializer.fromJson<String>(json['endereco']),
      tipoConexao: serializer.fromJson<String>(json['tipoConexao']),
      protocolo: serializer.fromJson<String>(json['protocolo']),
      padrao: serializer.fromJson<bool>(json['padrao']),
      ultimaConexao: serializer.fromJson<DateTime?>(json['ultimaConexao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'endereco': serializer.toJson<String>(endereco),
      'tipoConexao': serializer.toJson<String>(tipoConexao),
      'protocolo': serializer.toJson<String>(protocolo),
      'padrao': serializer.toJson<bool>(padrao),
      'ultimaConexao': serializer.toJson<DateTime?>(ultimaConexao),
    };
  }

  Printer copyWith({
    int? id,
    String? nome,
    String? endereco,
    String? tipoConexao,
    String? protocolo,
    bool? padrao,
    Value<DateTime?> ultimaConexao = const Value.absent(),
  }) => Printer(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    endereco: endereco ?? this.endereco,
    tipoConexao: tipoConexao ?? this.tipoConexao,
    protocolo: protocolo ?? this.protocolo,
    padrao: padrao ?? this.padrao,
    ultimaConexao: ultimaConexao.present
        ? ultimaConexao.value
        : this.ultimaConexao,
  );
  Printer copyWithCompanion(PrintersCompanion data) {
    return Printer(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      endereco: data.endereco.present ? data.endereco.value : this.endereco,
      tipoConexao: data.tipoConexao.present
          ? data.tipoConexao.value
          : this.tipoConexao,
      protocolo: data.protocolo.present ? data.protocolo.value : this.protocolo,
      padrao: data.padrao.present ? data.padrao.value : this.padrao,
      ultimaConexao: data.ultimaConexao.present
          ? data.ultimaConexao.value
          : this.ultimaConexao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Printer(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco, ')
          ..write('tipoConexao: $tipoConexao, ')
          ..write('protocolo: $protocolo, ')
          ..write('padrao: $padrao, ')
          ..write('ultimaConexao: $ultimaConexao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    endereco,
    tipoConexao,
    protocolo,
    padrao,
    ultimaConexao,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Printer &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.endereco == this.endereco &&
          other.tipoConexao == this.tipoConexao &&
          other.protocolo == this.protocolo &&
          other.padrao == this.padrao &&
          other.ultimaConexao == this.ultimaConexao);
}

class PrintersCompanion extends UpdateCompanion<Printer> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> endereco;
  final Value<String> tipoConexao;
  final Value<String> protocolo;
  final Value<bool> padrao;
  final Value<DateTime?> ultimaConexao;
  const PrintersCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.endereco = const Value.absent(),
    this.tipoConexao = const Value.absent(),
    this.protocolo = const Value.absent(),
    this.padrao = const Value.absent(),
    this.ultimaConexao = const Value.absent(),
  });
  PrintersCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String endereco,
    required String tipoConexao,
    required String protocolo,
    this.padrao = const Value.absent(),
    this.ultimaConexao = const Value.absent(),
  }) : nome = Value(nome),
       endereco = Value(endereco),
       tipoConexao = Value(tipoConexao),
       protocolo = Value(protocolo);
  static Insertable<Printer> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? endereco,
    Expression<String>? tipoConexao,
    Expression<String>? protocolo,
    Expression<bool>? padrao,
    Expression<DateTime>? ultimaConexao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (endereco != null) 'endereco': endereco,
      if (tipoConexao != null) 'tipo_conexao': tipoConexao,
      if (protocolo != null) 'protocolo': protocolo,
      if (padrao != null) 'padrao': padrao,
      if (ultimaConexao != null) 'ultima_conexao': ultimaConexao,
    });
  }

  PrintersCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? endereco,
    Value<String>? tipoConexao,
    Value<String>? protocolo,
    Value<bool>? padrao,
    Value<DateTime?>? ultimaConexao,
  }) {
    return PrintersCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
      tipoConexao: tipoConexao ?? this.tipoConexao,
      protocolo: protocolo ?? this.protocolo,
      padrao: padrao ?? this.padrao,
      ultimaConexao: ultimaConexao ?? this.ultimaConexao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (endereco.present) {
      map['endereco'] = Variable<String>(endereco.value);
    }
    if (tipoConexao.present) {
      map['tipo_conexao'] = Variable<String>(tipoConexao.value);
    }
    if (protocolo.present) {
      map['protocolo'] = Variable<String>(protocolo.value);
    }
    if (padrao.present) {
      map['padrao'] = Variable<bool>(padrao.value);
    }
    if (ultimaConexao.present) {
      map['ultima_conexao'] = Variable<DateTime>(ultimaConexao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrintersCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco, ')
          ..write('tipoConexao: $tipoConexao, ')
          ..write('protocolo: $protocolo, ')
          ..write('padrao: $padrao, ')
          ..write('ultimaConexao: $ultimaConexao')
          ..write(')'))
        .toString();
  }
}

class $ScalesTable extends Scales with TableInfo<$ScalesTable, Scale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScalesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enderecoMeta = const VerificationMeta(
    'endereco',
  );
  @override
  late final GeneratedColumn<String> endereco = GeneratedColumn<String>(
    'endereco',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tipoConexaoMeta = const VerificationMeta(
    'tipoConexao',
  );
  @override
  late final GeneratedColumn<String> tipoConexao = GeneratedColumn<String>(
    'tipo_conexao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocoloMeta = const VerificationMeta(
    'protocolo',
  );
  @override
  late final GeneratedColumn<String> protocolo = GeneratedColumn<String>(
    'protocolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _padraoMeta = const VerificationMeta('padrao');
  @override
  late final GeneratedColumn<bool> padrao = GeneratedColumn<bool>(
    'padrao',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("padrao" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    endereco,
    tipoConexao,
    protocolo,
    padrao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Scale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('endereco')) {
      context.handle(
        _enderecoMeta,
        endereco.isAcceptableOrUnknown(data['endereco']!, _enderecoMeta),
      );
    } else if (isInserting) {
      context.missing(_enderecoMeta);
    }
    if (data.containsKey('tipo_conexao')) {
      context.handle(
        _tipoConexaoMeta,
        tipoConexao.isAcceptableOrUnknown(
          data['tipo_conexao']!,
          _tipoConexaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoConexaoMeta);
    }
    if (data.containsKey('protocolo')) {
      context.handle(
        _protocoloMeta,
        protocolo.isAcceptableOrUnknown(data['protocolo']!, _protocoloMeta),
      );
    } else if (isInserting) {
      context.missing(_protocoloMeta);
    }
    if (data.containsKey('padrao')) {
      context.handle(
        _padraoMeta,
        padrao.isAcceptableOrUnknown(data['padrao']!, _padraoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Scale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Scale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      endereco: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endereco'],
      )!,
      tipoConexao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_conexao'],
      )!,
      protocolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}protocolo'],
      )!,
      padrao: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}padrao'],
      )!,
    );
  }

  @override
  $ScalesTable createAlias(String alias) {
    return $ScalesTable(attachedDatabase, alias);
  }
}

class Scale extends DataClass implements Insertable<Scale> {
  final int id;
  final String nome;
  final String endereco;

  /// Nome do enum `ScaleTransportType`.
  final String tipoConexao;

  /// Identifica qual `ScaleParser` interpreta os bytes recebidos.
  final String protocolo;
  final bool padrao;
  const Scale({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.tipoConexao,
    required this.protocolo,
    required this.padrao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['endereco'] = Variable<String>(endereco);
    map['tipo_conexao'] = Variable<String>(tipoConexao);
    map['protocolo'] = Variable<String>(protocolo);
    map['padrao'] = Variable<bool>(padrao);
    return map;
  }

  ScalesCompanion toCompanion(bool nullToAbsent) {
    return ScalesCompanion(
      id: Value(id),
      nome: Value(nome),
      endereco: Value(endereco),
      tipoConexao: Value(tipoConexao),
      protocolo: Value(protocolo),
      padrao: Value(padrao),
    );
  }

  factory Scale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Scale(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      endereco: serializer.fromJson<String>(json['endereco']),
      tipoConexao: serializer.fromJson<String>(json['tipoConexao']),
      protocolo: serializer.fromJson<String>(json['protocolo']),
      padrao: serializer.fromJson<bool>(json['padrao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'endereco': serializer.toJson<String>(endereco),
      'tipoConexao': serializer.toJson<String>(tipoConexao),
      'protocolo': serializer.toJson<String>(protocolo),
      'padrao': serializer.toJson<bool>(padrao),
    };
  }

  Scale copyWith({
    int? id,
    String? nome,
    String? endereco,
    String? tipoConexao,
    String? protocolo,
    bool? padrao,
  }) => Scale(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    endereco: endereco ?? this.endereco,
    tipoConexao: tipoConexao ?? this.tipoConexao,
    protocolo: protocolo ?? this.protocolo,
    padrao: padrao ?? this.padrao,
  );
  Scale copyWithCompanion(ScalesCompanion data) {
    return Scale(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      endereco: data.endereco.present ? data.endereco.value : this.endereco,
      tipoConexao: data.tipoConexao.present
          ? data.tipoConexao.value
          : this.tipoConexao,
      protocolo: data.protocolo.present ? data.protocolo.value : this.protocolo,
      padrao: data.padrao.present ? data.padrao.value : this.padrao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Scale(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco, ')
          ..write('tipoConexao: $tipoConexao, ')
          ..write('protocolo: $protocolo, ')
          ..write('padrao: $padrao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, endereco, tipoConexao, protocolo, padrao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Scale &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.endereco == this.endereco &&
          other.tipoConexao == this.tipoConexao &&
          other.protocolo == this.protocolo &&
          other.padrao == this.padrao);
}

class ScalesCompanion extends UpdateCompanion<Scale> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> endereco;
  final Value<String> tipoConexao;
  final Value<String> protocolo;
  final Value<bool> padrao;
  const ScalesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.endereco = const Value.absent(),
    this.tipoConexao = const Value.absent(),
    this.protocolo = const Value.absent(),
    this.padrao = const Value.absent(),
  });
  ScalesCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String endereco,
    required String tipoConexao,
    required String protocolo,
    this.padrao = const Value.absent(),
  }) : nome = Value(nome),
       endereco = Value(endereco),
       tipoConexao = Value(tipoConexao),
       protocolo = Value(protocolo);
  static Insertable<Scale> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? endereco,
    Expression<String>? tipoConexao,
    Expression<String>? protocolo,
    Expression<bool>? padrao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (endereco != null) 'endereco': endereco,
      if (tipoConexao != null) 'tipo_conexao': tipoConexao,
      if (protocolo != null) 'protocolo': protocolo,
      if (padrao != null) 'padrao': padrao,
    });
  }

  ScalesCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? endereco,
    Value<String>? tipoConexao,
    Value<String>? protocolo,
    Value<bool>? padrao,
  }) {
    return ScalesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
      tipoConexao: tipoConexao ?? this.tipoConexao,
      protocolo: protocolo ?? this.protocolo,
      padrao: padrao ?? this.padrao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (endereco.present) {
      map['endereco'] = Variable<String>(endereco.value);
    }
    if (tipoConexao.present) {
      map['tipo_conexao'] = Variable<String>(tipoConexao.value);
    }
    if (protocolo.present) {
      map['protocolo'] = Variable<String>(protocolo.value);
    }
    if (padrao.present) {
      map['padrao'] = Variable<bool>(padrao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScalesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('endereco: $endereco, ')
          ..write('tipoConexao: $tipoConexao, ')
          ..write('protocolo: $protocolo, ')
          ..write('padrao: $padrao')
          ..write(')'))
        .toString();
  }
}

class $ProductPriceHistoryTable extends ProductPriceHistory
    with TableInfo<$ProductPriceHistoryTable, ProductPriceHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPriceHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _produtoIdMeta = const VerificationMeta(
    'produtoId',
  );
  @override
  late final GeneratedColumn<int> produtoId = GeneratedColumn<int>(
    'produto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _precoAnteriorMeta = const VerificationMeta(
    'precoAnterior',
  );
  @override
  late final GeneratedColumn<double> precoAnterior = GeneratedColumn<double>(
    'preco_anterior',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precoNovoMeta = const VerificationMeta(
    'precoNovo',
  );
  @override
  late final GeneratedColumn<double> precoNovo = GeneratedColumn<double>(
    'preco_novo',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _origemMeta = const VerificationMeta('origem');
  @override
  late final GeneratedColumn<String> origem = GeneratedColumn<String>(
    'origem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    produtoId,
    precoAnterior,
    precoNovo,
    data,
    origem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_price_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductPriceHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('produto_id')) {
      context.handle(
        _produtoIdMeta,
        produtoId.isAcceptableOrUnknown(data['produto_id']!, _produtoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoIdMeta);
    }
    if (data.containsKey('preco_anterior')) {
      context.handle(
        _precoAnteriorMeta,
        precoAnterior.isAcceptableOrUnknown(
          data['preco_anterior']!,
          _precoAnteriorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precoAnteriorMeta);
    }
    if (data.containsKey('preco_novo')) {
      context.handle(
        _precoNovoMeta,
        precoNovo.isAcceptableOrUnknown(data['preco_novo']!, _precoNovoMeta),
      );
    } else if (isInserting) {
      context.missing(_precoNovoMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('origem')) {
      context.handle(
        _origemMeta,
        origem.isAcceptableOrUnknown(data['origem']!, _origemMeta),
      );
    } else if (isInserting) {
      context.missing(_origemMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPriceHistoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPriceHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      produtoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produto_id'],
      )!,
      precoAnterior: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}preco_anterior'],
      )!,
      precoNovo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}preco_novo'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      )!,
      origem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origem'],
      )!,
    );
  }

  @override
  $ProductPriceHistoryTable createAlias(String alias) {
    return $ProductPriceHistoryTable(attachedDatabase, alias);
  }
}

class ProductPriceHistoryData extends DataClass
    implements Insertable<ProductPriceHistoryData> {
  final int id;
  final int produtoId;
  final double precoAnterior;
  final double precoNovo;
  final DateTime data;

  /// Origem da alteração (ex.: "importacao", "manual").
  final String origem;
  const ProductPriceHistoryData({
    required this.id,
    required this.produtoId,
    required this.precoAnterior,
    required this.precoNovo,
    required this.data,
    required this.origem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['produto_id'] = Variable<int>(produtoId);
    map['preco_anterior'] = Variable<double>(precoAnterior);
    map['preco_novo'] = Variable<double>(precoNovo);
    map['data'] = Variable<DateTime>(data);
    map['origem'] = Variable<String>(origem);
    return map;
  }

  ProductPriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return ProductPriceHistoryCompanion(
      id: Value(id),
      produtoId: Value(produtoId),
      precoAnterior: Value(precoAnterior),
      precoNovo: Value(precoNovo),
      data: Value(data),
      origem: Value(origem),
    );
  }

  factory ProductPriceHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPriceHistoryData(
      id: serializer.fromJson<int>(json['id']),
      produtoId: serializer.fromJson<int>(json['produtoId']),
      precoAnterior: serializer.fromJson<double>(json['precoAnterior']),
      precoNovo: serializer.fromJson<double>(json['precoNovo']),
      data: serializer.fromJson<DateTime>(json['data']),
      origem: serializer.fromJson<String>(json['origem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'produtoId': serializer.toJson<int>(produtoId),
      'precoAnterior': serializer.toJson<double>(precoAnterior),
      'precoNovo': serializer.toJson<double>(precoNovo),
      'data': serializer.toJson<DateTime>(data),
      'origem': serializer.toJson<String>(origem),
    };
  }

  ProductPriceHistoryData copyWith({
    int? id,
    int? produtoId,
    double? precoAnterior,
    double? precoNovo,
    DateTime? data,
    String? origem,
  }) => ProductPriceHistoryData(
    id: id ?? this.id,
    produtoId: produtoId ?? this.produtoId,
    precoAnterior: precoAnterior ?? this.precoAnterior,
    precoNovo: precoNovo ?? this.precoNovo,
    data: data ?? this.data,
    origem: origem ?? this.origem,
  );
  ProductPriceHistoryData copyWithCompanion(ProductPriceHistoryCompanion data) {
    return ProductPriceHistoryData(
      id: data.id.present ? data.id.value : this.id,
      produtoId: data.produtoId.present ? data.produtoId.value : this.produtoId,
      precoAnterior: data.precoAnterior.present
          ? data.precoAnterior.value
          : this.precoAnterior,
      precoNovo: data.precoNovo.present ? data.precoNovo.value : this.precoNovo,
      data: data.data.present ? data.data.value : this.data,
      origem: data.origem.present ? data.origem.value : this.origem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPriceHistoryData(')
          ..write('id: $id, ')
          ..write('produtoId: $produtoId, ')
          ..write('precoAnterior: $precoAnterior, ')
          ..write('precoNovo: $precoNovo, ')
          ..write('data: $data, ')
          ..write('origem: $origem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, produtoId, precoAnterior, precoNovo, data, origem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPriceHistoryData &&
          other.id == this.id &&
          other.produtoId == this.produtoId &&
          other.precoAnterior == this.precoAnterior &&
          other.precoNovo == this.precoNovo &&
          other.data == this.data &&
          other.origem == this.origem);
}

class ProductPriceHistoryCompanion
    extends UpdateCompanion<ProductPriceHistoryData> {
  final Value<int> id;
  final Value<int> produtoId;
  final Value<double> precoAnterior;
  final Value<double> precoNovo;
  final Value<DateTime> data;
  final Value<String> origem;
  const ProductPriceHistoryCompanion({
    this.id = const Value.absent(),
    this.produtoId = const Value.absent(),
    this.precoAnterior = const Value.absent(),
    this.precoNovo = const Value.absent(),
    this.data = const Value.absent(),
    this.origem = const Value.absent(),
  });
  ProductPriceHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int produtoId,
    required double precoAnterior,
    required double precoNovo,
    required DateTime data,
    required String origem,
  }) : produtoId = Value(produtoId),
       precoAnterior = Value(precoAnterior),
       precoNovo = Value(precoNovo),
       data = Value(data),
       origem = Value(origem);
  static Insertable<ProductPriceHistoryData> custom({
    Expression<int>? id,
    Expression<int>? produtoId,
    Expression<double>? precoAnterior,
    Expression<double>? precoNovo,
    Expression<DateTime>? data,
    Expression<String>? origem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produtoId != null) 'produto_id': produtoId,
      if (precoAnterior != null) 'preco_anterior': precoAnterior,
      if (precoNovo != null) 'preco_novo': precoNovo,
      if (data != null) 'data': data,
      if (origem != null) 'origem': origem,
    });
  }

  ProductPriceHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? produtoId,
    Value<double>? precoAnterior,
    Value<double>? precoNovo,
    Value<DateTime>? data,
    Value<String>? origem,
  }) {
    return ProductPriceHistoryCompanion(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      precoAnterior: precoAnterior ?? this.precoAnterior,
      precoNovo: precoNovo ?? this.precoNovo,
      data: data ?? this.data,
      origem: origem ?? this.origem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (produtoId.present) {
      map['produto_id'] = Variable<int>(produtoId.value);
    }
    if (precoAnterior.present) {
      map['preco_anterior'] = Variable<double>(precoAnterior.value);
    }
    if (precoNovo.present) {
      map['preco_novo'] = Variable<double>(precoNovo.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (origem.present) {
      map['origem'] = Variable<String>(origem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('produtoId: $produtoId, ')
          ..write('precoAnterior: $precoAnterior, ')
          ..write('precoNovo: $precoNovo, ')
          ..write('data: $data, ')
          ..write('origem: $origem')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  const AppSetting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSetting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppSetting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dataHoraMeta = const VerificationMeta(
    'dataHora',
  );
  @override
  late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>(
    'data_hora',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detalhesMeta = const VerificationMeta(
    'detalhes',
  );
  @override
  late final GeneratedColumn<String> detalhes = GeneratedColumn<String>(
    'detalhes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dataHora,
    tipo,
    descricao,
    detalhes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data_hora')) {
      context.handle(
        _dataHoraMeta,
        dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta),
      );
    } else if (isInserting) {
      context.missing(_dataHoraMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('detalhes')) {
      context.handle(
        _detalhesMeta,
        detalhes.isAcceptableOrUnknown(data['detalhes']!, _detalhesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dataHora: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_hora'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      detalhes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detalhes'],
      ),
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final int id;
  final DateTime dataHora;

  /// Nome do enum `AuditEventType`.
  final String tipo;
  final String descricao;

  /// Detalhes adicionais em texto livre (ex.: nome do arquivo, mac
  /// address da impressora, mensagem de erro) — opcional.
  final String? detalhes;
  const AuditLogData({
    required this.id,
    required this.dataHora,
    required this.tipo,
    required this.descricao,
    this.detalhes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data_hora'] = Variable<DateTime>(dataHora);
    map['tipo'] = Variable<String>(tipo);
    map['descricao'] = Variable<String>(descricao);
    if (!nullToAbsent || detalhes != null) {
      map['detalhes'] = Variable<String>(detalhes);
    }
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      dataHora: Value(dataHora),
      tipo: Value(tipo),
      descricao: Value(descricao),
      detalhes: detalhes == null && nullToAbsent
          ? const Value.absent()
          : Value(detalhes),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<int>(json['id']),
      dataHora: serializer.fromJson<DateTime>(json['dataHora']),
      tipo: serializer.fromJson<String>(json['tipo']),
      descricao: serializer.fromJson<String>(json['descricao']),
      detalhes: serializer.fromJson<String?>(json['detalhes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dataHora': serializer.toJson<DateTime>(dataHora),
      'tipo': serializer.toJson<String>(tipo),
      'descricao': serializer.toJson<String>(descricao),
      'detalhes': serializer.toJson<String?>(detalhes),
    };
  }

  AuditLogData copyWith({
    int? id,
    DateTime? dataHora,
    String? tipo,
    String? descricao,
    Value<String?> detalhes = const Value.absent(),
  }) => AuditLogData(
    id: id ?? this.id,
    dataHora: dataHora ?? this.dataHora,
    tipo: tipo ?? this.tipo,
    descricao: descricao ?? this.descricao,
    detalhes: detalhes.present ? detalhes.value : this.detalhes,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      detalhes: data.detalhes.present ? data.detalhes.value : this.detalhes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('dataHora: $dataHora, ')
          ..write('tipo: $tipo, ')
          ..write('descricao: $descricao, ')
          ..write('detalhes: $detalhes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dataHora, tipo, descricao, detalhes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.dataHora == this.dataHora &&
          other.tipo == this.tipo &&
          other.descricao == this.descricao &&
          other.detalhes == this.detalhes);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<int> id;
  final Value<DateTime> dataHora;
  final Value<String> tipo;
  final Value<String> descricao;
  final Value<String?> detalhes;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.dataHora = const Value.absent(),
    this.tipo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.detalhes = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    required DateTime dataHora,
    required String tipo,
    required String descricao,
    this.detalhes = const Value.absent(),
  }) : dataHora = Value(dataHora),
       tipo = Value(tipo),
       descricao = Value(descricao);
  static Insertable<AuditLogData> custom({
    Expression<int>? id,
    Expression<DateTime>? dataHora,
    Expression<String>? tipo,
    Expression<String>? descricao,
    Expression<String>? detalhes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dataHora != null) 'data_hora': dataHora,
      if (tipo != null) 'tipo': tipo,
      if (descricao != null) 'descricao': descricao,
      if (detalhes != null) 'detalhes': detalhes,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? dataHora,
    Value<String>? tipo,
    Value<String>? descricao,
    Value<String?>? detalhes,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      dataHora: dataHora ?? this.dataHora,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
      detalhes: detalhes ?? this.detalhes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dataHora.present) {
      map['data_hora'] = Variable<DateTime>(dataHora.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (detalhes.present) {
      map['detalhes'] = Variable<String>(detalhes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('dataHora: $dataHora, ')
          ..write('tipo: $tipo, ')
          ..write('descricao: $descricao, ')
          ..write('detalhes: $detalhes')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentualComissaoMeta =
      const VerificationMeta('percentualComissao');
  @override
  late final GeneratedColumn<double> percentualComissao =
      GeneratedColumn<double>(
        'percentual_comissao',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    percentualComissao,
    ativo,
    dataCriacao,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('percentual_comissao')) {
      context.handle(
        _percentualComissaoMeta,
        percentualComissao.isAcceptableOrUnknown(
          data['percentual_comissao']!,
          _percentualComissaoMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      percentualComissao: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentual_comissao'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String nome;
  final double percentualComissao;
  final bool ativo;
  final DateTime dataCriacao;
  const Employee({
    required this.id,
    required this.nome,
    required this.percentualComissao,
    required this.ativo,
    required this.dataCriacao,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['percentual_comissao'] = Variable<double>(percentualComissao);
    map['ativo'] = Variable<bool>(ativo);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      nome: Value(nome),
      percentualComissao: Value(percentualComissao),
      ativo: Value(ativo),
      dataCriacao: Value(dataCriacao),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      percentualComissao: serializer.fromJson<double>(
        json['percentualComissao'],
      ),
      ativo: serializer.fromJson<bool>(json['ativo']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'percentualComissao': serializer.toJson<double>(percentualComissao),
      'ativo': serializer.toJson<bool>(ativo),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
    };
  }

  Employee copyWith({
    int? id,
    String? nome,
    double? percentualComissao,
    bool? ativo,
    DateTime? dataCriacao,
  }) => Employee(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    percentualComissao: percentualComissao ?? this.percentualComissao,
    ativo: ativo ?? this.ativo,
    dataCriacao: dataCriacao ?? this.dataCriacao,
  );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      percentualComissao: data.percentualComissao.present
          ? data.percentualComissao.value
          : this.percentualComissao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('percentualComissao: $percentualComissao, ')
          ..write('ativo: $ativo, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, percentualComissao, ativo, dataCriacao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.percentualComissao == this.percentualComissao &&
          other.ativo == this.ativo &&
          other.dataCriacao == this.dataCriacao);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> nome;
  final Value<double> percentualComissao;
  final Value<bool> ativo;
  final Value<DateTime> dataCriacao;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.percentualComissao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.dataCriacao = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.percentualComissao = const Value.absent(),
    this.ativo = const Value.absent(),
    required DateTime dataCriacao,
  }) : nome = Value(nome),
       dataCriacao = Value(dataCriacao);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<double>? percentualComissao,
    Expression<bool>? ativo,
    Expression<DateTime>? dataCriacao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (percentualComissao != null) 'percentual_comissao': percentualComissao,
      if (ativo != null) 'ativo': ativo,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<double>? percentualComissao,
    Value<bool>? ativo,
    Value<DateTime>? dataCriacao,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      percentualComissao: percentualComissao ?? this.percentualComissao,
      ativo: ativo ?? this.ativo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (percentualComissao.present) {
      map['percentual_comissao'] = Variable<double>(percentualComissao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('percentualComissao: $percentualComissao, ')
          ..write('ativo: $ativo, ')
          ..write('dataCriacao: $dataCriacao')
          ..write(')'))
        .toString();
  }
}

class $WeighingEmployeesTable extends WeighingEmployees
    with TableInfo<$WeighingEmployeesTable, WeighingEmployee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeighingEmployeesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _weighingIdMeta = const VerificationMeta(
    'weighingId',
  );
  @override
  late final GeneratedColumn<int> weighingId = GeneratedColumn<int>(
    'weighing_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES weighing_history (id)',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, weighingId, employeeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weighing_employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeighingEmployee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weighing_id')) {
      context.handle(
        _weighingIdMeta,
        weighingId.isAcceptableOrUnknown(data['weighing_id']!, _weighingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weighingIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeighingEmployee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeighingEmployee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weighingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weighing_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
    );
  }

  @override
  $WeighingEmployeesTable createAlias(String alias) {
    return $WeighingEmployeesTable(attachedDatabase, alias);
  }
}

class WeighingEmployee extends DataClass
    implements Insertable<WeighingEmployee> {
  final int id;
  final int weighingId;
  final int employeeId;
  const WeighingEmployee({
    required this.id,
    required this.weighingId,
    required this.employeeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weighing_id'] = Variable<int>(weighingId);
    map['employee_id'] = Variable<int>(employeeId);
    return map;
  }

  WeighingEmployeesCompanion toCompanion(bool nullToAbsent) {
    return WeighingEmployeesCompanion(
      id: Value(id),
      weighingId: Value(weighingId),
      employeeId: Value(employeeId),
    );
  }

  factory WeighingEmployee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeighingEmployee(
      id: serializer.fromJson<int>(json['id']),
      weighingId: serializer.fromJson<int>(json['weighingId']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weighingId': serializer.toJson<int>(weighingId),
      'employeeId': serializer.toJson<int>(employeeId),
    };
  }

  WeighingEmployee copyWith({int? id, int? weighingId, int? employeeId}) =>
      WeighingEmployee(
        id: id ?? this.id,
        weighingId: weighingId ?? this.weighingId,
        employeeId: employeeId ?? this.employeeId,
      );
  WeighingEmployee copyWithCompanion(WeighingEmployeesCompanion data) {
    return WeighingEmployee(
      id: data.id.present ? data.id.value : this.id,
      weighingId: data.weighingId.present
          ? data.weighingId.value
          : this.weighingId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeighingEmployee(')
          ..write('id: $id, ')
          ..write('weighingId: $weighingId, ')
          ..write('employeeId: $employeeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weighingId, employeeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeighingEmployee &&
          other.id == this.id &&
          other.weighingId == this.weighingId &&
          other.employeeId == this.employeeId);
}

class WeighingEmployeesCompanion extends UpdateCompanion<WeighingEmployee> {
  final Value<int> id;
  final Value<int> weighingId;
  final Value<int> employeeId;
  const WeighingEmployeesCompanion({
    this.id = const Value.absent(),
    this.weighingId = const Value.absent(),
    this.employeeId = const Value.absent(),
  });
  WeighingEmployeesCompanion.insert({
    this.id = const Value.absent(),
    required int weighingId,
    required int employeeId,
  }) : weighingId = Value(weighingId),
       employeeId = Value(employeeId);
  static Insertable<WeighingEmployee> custom({
    Expression<int>? id,
    Expression<int>? weighingId,
    Expression<int>? employeeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weighingId != null) 'weighing_id': weighingId,
      if (employeeId != null) 'employee_id': employeeId,
    });
  }

  WeighingEmployeesCompanion copyWith({
    Value<int>? id,
    Value<int>? weighingId,
    Value<int>? employeeId,
  }) {
    return WeighingEmployeesCompanion(
      id: id ?? this.id,
      weighingId: weighingId ?? this.weighingId,
      employeeId: employeeId ?? this.employeeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weighingId.present) {
      map['weighing_id'] = Variable<int>(weighingId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeighingEmployeesCompanion(')
          ..write('id: $id, ')
          ..write('weighingId: $weighingId, ')
          ..write('employeeId: $employeeId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $WeighingHistoryTable weighingHistory = $WeighingHistoryTable(
    this,
  );
  late final $ImportHistoryTable importHistory = $ImportHistoryTable(this);
  late final $LabelsTable labels = $LabelsTable(this);
  late final $LabelElementsTable labelElements = $LabelElementsTable(this);
  late final $PrintersTable printers = $PrintersTable(this);
  late final $ScalesTable scales = $ScalesTable(this);
  late final $ProductPriceHistoryTable productPriceHistory =
      $ProductPriceHistoryTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $WeighingEmployeesTable weighingEmployees =
      $WeighingEmployeesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    weighingHistory,
    importHistory,
    labels,
    labelElements,
    printers,
    scales,
    productPriceHistory,
    appSettings,
    auditLog,
    employees,
    weighingEmployees,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'labels',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('label_elements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('product_price_history', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String codigo,
      required String plu,
      required String descricao,
      required double preco,
      required String unidade,
      Value<int?> validadeDias,
      Value<String?> codigoBarras,
      Value<String?> departamento,
      Value<bool> ativo,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> codigo,
      Value<String> plu,
      Value<String> descricao,
      Value<double> preco,
      Value<String> unidade,
      Value<int?> validadeDias,
      Value<String?> codigoBarras,
      Value<String?> departamento,
      Value<bool> ativo,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WeighingHistoryTable, List<WeighingHistoryData>>
  _weighingHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weighingHistory,
    aliasName: 'products__id__weighing_history__produto_id',
  );

  $$WeighingHistoryTableProcessedTableManager get weighingHistoryRefs {
    final manager = $$WeighingHistoryTableTableManager(
      $_db,
      $_db.weighingHistory,
    ).filter((f) => f.produtoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weighingHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProductPriceHistoryTable,
    List<ProductPriceHistoryData>
  >
  _productPriceHistoryRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.productPriceHistory,
        aliasName: 'products__id__product_price_history__produto_id',
      );

  $$ProductPriceHistoryTableProcessedTableManager get productPriceHistoryRefs {
    final manager = $$ProductPriceHistoryTableTableManager(
      $_db,
      $_db.productPriceHistory,
    ).filter((f) => f.produtoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productPriceHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plu => $composableBuilder(
    column: $table.plu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get preco => $composableBuilder(
    column: $table.preco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get validadeDias => $composableBuilder(
    column: $table.validadeDias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weighingHistoryRefs(
    Expression<bool> Function($$WeighingHistoryTableFilterComposer f) f,
  ) {
    final $$WeighingHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weighingHistory,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingHistoryTableFilterComposer(
            $db: $db,
            $table: $db.weighingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productPriceHistoryRefs(
    Expression<bool> Function($$ProductPriceHistoryTableFilterComposer f) f,
  ) {
    final $$ProductPriceHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productPriceHistory,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductPriceHistoryTableFilterComposer(
            $db: $db,
            $table: $db.productPriceHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plu => $composableBuilder(
    column: $table.plu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get preco => $composableBuilder(
    column: $table.preco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get validadeDias => $composableBuilder(
    column: $table.validadeDias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get plu =>
      $composableBuilder(column: $table.plu, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<double> get preco =>
      $composableBuilder(column: $table.preco, builder: (column) => column);

  GeneratedColumn<String> get unidade =>
      $composableBuilder(column: $table.unidade, builder: (column) => column);

  GeneratedColumn<int> get validadeDias => $composableBuilder(
    column: $table.validadeDias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  Expression<T> weighingHistoryRefs<T extends Object>(
    Expression<T> Function($$WeighingHistoryTableAnnotationComposer a) f,
  ) {
    final $$WeighingHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weighingHistory,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.weighingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productPriceHistoryRefs<T extends Object>(
    Expression<T> Function($$ProductPriceHistoryTableAnnotationComposer a) f,
  ) {
    final $$ProductPriceHistoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.productPriceHistory,
          getReferencedColumn: (t) => t.produtoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProductPriceHistoryTableAnnotationComposer(
                $db: $db,
                $table: $db.productPriceHistory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool weighingHistoryRefs,
            bool productPriceHistoryRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> plu = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<double> preco = const Value.absent(),
                Value<String> unidade = const Value.absent(),
                Value<int?> validadeDias = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> departamento = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                codigo: codigo,
                plu: plu,
                descricao: descricao,
                preco: preco,
                unidade: unidade,
                validadeDias: validadeDias,
                codigoBarras: codigoBarras,
                departamento: departamento,
                ativo: ativo,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String codigo,
                required String plu,
                required String descricao,
                required double preco,
                required String unidade,
                Value<int?> validadeDias = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> departamento = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => ProductsCompanion.insert(
                id: id,
                codigo: codigo,
                plu: plu,
                descricao: descricao,
                preco: preco,
                unidade: unidade,
                validadeDias: validadeDias,
                codigoBarras: codigoBarras,
                departamento: departamento,
                ativo: ativo,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({weighingHistoryRefs = false, productPriceHistoryRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weighingHistoryRefs) db.weighingHistory,
                    if (productPriceHistoryRefs) db.productPriceHistory,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weighingHistoryRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          WeighingHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._weighingHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).weighingHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.produtoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productPriceHistoryRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          ProductPriceHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._productPriceHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).productPriceHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.produtoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool weighingHistoryRefs,
        bool productPriceHistoryRefs,
      })
    >;
typedef $$WeighingHistoryTableCreateCompanionBuilder =
    WeighingHistoryCompanion Function({
      Value<int> id,
      required String uuid,
      required DateTime dataHora,
      required int produtoId,
      required String codigo,
      required String descricao,
      required double peso,
      required double precoKg,
      required double valorTotal,
      Value<String?> codigoBarras,
      Value<String?> layoutEtiqueta,
      Value<String?> impressora,
      Value<String?> comandaNumero,
      Value<String> statusImpressao,
      Value<int> quantidadeImpressoes,
    });
typedef $$WeighingHistoryTableUpdateCompanionBuilder =
    WeighingHistoryCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<DateTime> dataHora,
      Value<int> produtoId,
      Value<String> codigo,
      Value<String> descricao,
      Value<double> peso,
      Value<double> precoKg,
      Value<double> valorTotal,
      Value<String?> codigoBarras,
      Value<String?> layoutEtiqueta,
      Value<String?> impressora,
      Value<String?> comandaNumero,
      Value<String> statusImpressao,
      Value<int> quantidadeImpressoes,
    });

final class $$WeighingHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeighingHistoryTable,
          WeighingHistoryData
        > {
  $$WeighingHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _produtoIdTable(_$AppDatabase db) =>
      db.products.createAlias('weighing_history__produto_id__products__id');

  $$ProductsTableProcessedTableManager get produtoId {
    final $_column = $_itemColumn<int>('produto_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produtoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WeighingEmployeesTable, List<WeighingEmployee>>
  _weighingEmployeesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weighingEmployees,
        aliasName: 'weighing_history__id__weighing_employees__weighing_id',
      );

  $$WeighingEmployeesTableProcessedTableManager get weighingEmployeesRefs {
    final manager = $$WeighingEmployeesTableTableManager(
      $_db,
      $_db.weighingEmployees,
    ).filter((f) => f.weighingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weighingEmployeesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeighingHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $WeighingHistoryTable> {
  $$WeighingHistoryTableFilterComposer({
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

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precoKg => $composableBuilder(
    column: $table.precoKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layoutEtiqueta => $composableBuilder(
    column: $table.layoutEtiqueta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get impressora => $composableBuilder(
    column: $table.impressora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comandaNumero => $composableBuilder(
    column: $table.comandaNumero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusImpressao => $composableBuilder(
    column: $table.statusImpressao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantidadeImpressoes => $composableBuilder(
    column: $table.quantidadeImpressoes,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get produtoId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> weighingEmployeesRefs(
    Expression<bool> Function($$WeighingEmployeesTableFilterComposer f) f,
  ) {
    final $$WeighingEmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weighingEmployees,
      getReferencedColumn: (t) => t.weighingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingEmployeesTableFilterComposer(
            $db: $db,
            $table: $db.weighingEmployees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeighingHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $WeighingHistoryTable> {
  $$WeighingHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get peso => $composableBuilder(
    column: $table.peso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precoKg => $composableBuilder(
    column: $table.precoKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layoutEtiqueta => $composableBuilder(
    column: $table.layoutEtiqueta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get impressora => $composableBuilder(
    column: $table.impressora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comandaNumero => $composableBuilder(
    column: $table.comandaNumero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusImpressao => $composableBuilder(
    column: $table.statusImpressao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantidadeImpressoes => $composableBuilder(
    column: $table.quantidadeImpressoes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get produtoId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeighingHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeighingHistoryTable> {
  $$WeighingHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<double> get peso =>
      $composableBuilder(column: $table.peso, builder: (column) => column);

  GeneratedColumn<double> get precoKg =>
      $composableBuilder(column: $table.precoKg, builder: (column) => column);

  GeneratedColumn<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => column,
  );

  GeneratedColumn<String> get layoutEtiqueta => $composableBuilder(
    column: $table.layoutEtiqueta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get impressora => $composableBuilder(
    column: $table.impressora,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comandaNumero => $composableBuilder(
    column: $table.comandaNumero,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusImpressao => $composableBuilder(
    column: $table.statusImpressao,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantidadeImpressoes => $composableBuilder(
    column: $table.quantidadeImpressoes,
    builder: (column) => column,
  );

  $$ProductsTableAnnotationComposer get produtoId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> weighingEmployeesRefs<T extends Object>(
    Expression<T> Function($$WeighingEmployeesTableAnnotationComposer a) f,
  ) {
    final $$WeighingEmployeesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weighingEmployees,
          getReferencedColumn: (t) => t.weighingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeighingEmployeesTableAnnotationComposer(
                $db: $db,
                $table: $db.weighingEmployees,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WeighingHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeighingHistoryTable,
          WeighingHistoryData,
          $$WeighingHistoryTableFilterComposer,
          $$WeighingHistoryTableOrderingComposer,
          $$WeighingHistoryTableAnnotationComposer,
          $$WeighingHistoryTableCreateCompanionBuilder,
          $$WeighingHistoryTableUpdateCompanionBuilder,
          (WeighingHistoryData, $$WeighingHistoryTableReferences),
          WeighingHistoryData,
          PrefetchHooks Function({bool produtoId, bool weighingEmployeesRefs})
        > {
  $$WeighingHistoryTableTableManager(
    _$AppDatabase db,
    $WeighingHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeighingHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeighingHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeighingHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<int> produtoId = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<double> peso = const Value.absent(),
                Value<double> precoKg = const Value.absent(),
                Value<double> valorTotal = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> layoutEtiqueta = const Value.absent(),
                Value<String?> impressora = const Value.absent(),
                Value<String?> comandaNumero = const Value.absent(),
                Value<String> statusImpressao = const Value.absent(),
                Value<int> quantidadeImpressoes = const Value.absent(),
              }) => WeighingHistoryCompanion(
                id: id,
                uuid: uuid,
                dataHora: dataHora,
                produtoId: produtoId,
                codigo: codigo,
                descricao: descricao,
                peso: peso,
                precoKg: precoKg,
                valorTotal: valorTotal,
                codigoBarras: codigoBarras,
                layoutEtiqueta: layoutEtiqueta,
                impressora: impressora,
                comandaNumero: comandaNumero,
                statusImpressao: statusImpressao,
                quantidadeImpressoes: quantidadeImpressoes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required DateTime dataHora,
                required int produtoId,
                required String codigo,
                required String descricao,
                required double peso,
                required double precoKg,
                required double valorTotal,
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> layoutEtiqueta = const Value.absent(),
                Value<String?> impressora = const Value.absent(),
                Value<String?> comandaNumero = const Value.absent(),
                Value<String> statusImpressao = const Value.absent(),
                Value<int> quantidadeImpressoes = const Value.absent(),
              }) => WeighingHistoryCompanion.insert(
                id: id,
                uuid: uuid,
                dataHora: dataHora,
                produtoId: produtoId,
                codigo: codigo,
                descricao: descricao,
                peso: peso,
                precoKg: precoKg,
                valorTotal: valorTotal,
                codigoBarras: codigoBarras,
                layoutEtiqueta: layoutEtiqueta,
                impressora: impressora,
                comandaNumero: comandaNumero,
                statusImpressao: statusImpressao,
                quantidadeImpressoes: quantidadeImpressoes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeighingHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({produtoId = false, weighingEmployeesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (weighingEmployeesRefs) db.weighingEmployees,
                  ],
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
                        if (produtoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.produtoId,
                                    referencedTable:
                                        $$WeighingHistoryTableReferences
                                            ._produtoIdTable(db),
                                    referencedColumn:
                                        $$WeighingHistoryTableReferences
                                            ._produtoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (weighingEmployeesRefs)
                        await $_getPrefetchedData<
                          WeighingHistoryData,
                          $WeighingHistoryTable,
                          WeighingEmployee
                        >(
                          currentTable: table,
                          referencedTable: $$WeighingHistoryTableReferences
                              ._weighingEmployeesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeighingHistoryTableReferences(
                                db,
                                table,
                                p0,
                              ).weighingEmployeesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weighingId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WeighingHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeighingHistoryTable,
      WeighingHistoryData,
      $$WeighingHistoryTableFilterComposer,
      $$WeighingHistoryTableOrderingComposer,
      $$WeighingHistoryTableAnnotationComposer,
      $$WeighingHistoryTableCreateCompanionBuilder,
      $$WeighingHistoryTableUpdateCompanionBuilder,
      (WeighingHistoryData, $$WeighingHistoryTableReferences),
      WeighingHistoryData,
      PrefetchHooks Function({bool produtoId, bool weighingEmployeesRefs})
    >;
typedef $$ImportHistoryTableCreateCompanionBuilder =
    ImportHistoryCompanion Function({
      Value<int> id,
      required String arquivo,
      required int tamanho,
      required String hash,
      required DateTime dataModificacao,
      required DateTime dataImportacao,
      required int quantidadeLinhas,
      required int produtosNovos,
      required int produtosAtualizados,
      required int produtosComErro,
      required String status,
      Value<String?> mensagem,
      Value<String?> erros,
    });
typedef $$ImportHistoryTableUpdateCompanionBuilder =
    ImportHistoryCompanion Function({
      Value<int> id,
      Value<String> arquivo,
      Value<int> tamanho,
      Value<String> hash,
      Value<DateTime> dataModificacao,
      Value<DateTime> dataImportacao,
      Value<int> quantidadeLinhas,
      Value<int> produtosNovos,
      Value<int> produtosAtualizados,
      Value<int> produtosComErro,
      Value<String> status,
      Value<String?> mensagem,
      Value<String?> erros,
    });

class $$ImportHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ImportHistoryTable> {
  $$ImportHistoryTableFilterComposer({
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

  ColumnFilters<String> get arquivo => $composableBuilder(
    column: $table.arquivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tamanho => $composableBuilder(
    column: $table.tamanho,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataModificacao => $composableBuilder(
    column: $table.dataModificacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataImportacao => $composableBuilder(
    column: $table.dataImportacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantidadeLinhas => $composableBuilder(
    column: $table.quantidadeLinhas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get produtosNovos => $composableBuilder(
    column: $table.produtosNovos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get produtosAtualizados => $composableBuilder(
    column: $table.produtosAtualizados,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get produtosComErro => $composableBuilder(
    column: $table.produtosComErro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mensagem => $composableBuilder(
    column: $table.mensagem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get erros => $composableBuilder(
    column: $table.erros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportHistoryTable> {
  $$ImportHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get arquivo => $composableBuilder(
    column: $table.arquivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tamanho => $composableBuilder(
    column: $table.tamanho,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hash => $composableBuilder(
    column: $table.hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataModificacao => $composableBuilder(
    column: $table.dataModificacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataImportacao => $composableBuilder(
    column: $table.dataImportacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantidadeLinhas => $composableBuilder(
    column: $table.quantidadeLinhas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get produtosNovos => $composableBuilder(
    column: $table.produtosNovos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get produtosAtualizados => $composableBuilder(
    column: $table.produtosAtualizados,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get produtosComErro => $composableBuilder(
    column: $table.produtosComErro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mensagem => $composableBuilder(
    column: $table.mensagem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get erros => $composableBuilder(
    column: $table.erros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportHistoryTable> {
  $$ImportHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get arquivo =>
      $composableBuilder(column: $table.arquivo, builder: (column) => column);

  GeneratedColumn<int> get tamanho =>
      $composableBuilder(column: $table.tamanho, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<DateTime> get dataModificacao => $composableBuilder(
    column: $table.dataModificacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataImportacao => $composableBuilder(
    column: $table.dataImportacao,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantidadeLinhas => $composableBuilder(
    column: $table.quantidadeLinhas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get produtosNovos => $composableBuilder(
    column: $table.produtosNovos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get produtosAtualizados => $composableBuilder(
    column: $table.produtosAtualizados,
    builder: (column) => column,
  );

  GeneratedColumn<int> get produtosComErro => $composableBuilder(
    column: $table.produtosComErro,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get mensagem =>
      $composableBuilder(column: $table.mensagem, builder: (column) => column);

  GeneratedColumn<String> get erros =>
      $composableBuilder(column: $table.erros, builder: (column) => column);
}

class $$ImportHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportHistoryTable,
          ImportHistoryData,
          $$ImportHistoryTableFilterComposer,
          $$ImportHistoryTableOrderingComposer,
          $$ImportHistoryTableAnnotationComposer,
          $$ImportHistoryTableCreateCompanionBuilder,
          $$ImportHistoryTableUpdateCompanionBuilder,
          (
            ImportHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ImportHistoryTable,
              ImportHistoryData
            >,
          ),
          ImportHistoryData,
          PrefetchHooks Function()
        > {
  $$ImportHistoryTableTableManager(_$AppDatabase db, $ImportHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> arquivo = const Value.absent(),
                Value<int> tamanho = const Value.absent(),
                Value<String> hash = const Value.absent(),
                Value<DateTime> dataModificacao = const Value.absent(),
                Value<DateTime> dataImportacao = const Value.absent(),
                Value<int> quantidadeLinhas = const Value.absent(),
                Value<int> produtosNovos = const Value.absent(),
                Value<int> produtosAtualizados = const Value.absent(),
                Value<int> produtosComErro = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> mensagem = const Value.absent(),
                Value<String?> erros = const Value.absent(),
              }) => ImportHistoryCompanion(
                id: id,
                arquivo: arquivo,
                tamanho: tamanho,
                hash: hash,
                dataModificacao: dataModificacao,
                dataImportacao: dataImportacao,
                quantidadeLinhas: quantidadeLinhas,
                produtosNovos: produtosNovos,
                produtosAtualizados: produtosAtualizados,
                produtosComErro: produtosComErro,
                status: status,
                mensagem: mensagem,
                erros: erros,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String arquivo,
                required int tamanho,
                required String hash,
                required DateTime dataModificacao,
                required DateTime dataImportacao,
                required int quantidadeLinhas,
                required int produtosNovos,
                required int produtosAtualizados,
                required int produtosComErro,
                required String status,
                Value<String?> mensagem = const Value.absent(),
                Value<String?> erros = const Value.absent(),
              }) => ImportHistoryCompanion.insert(
                id: id,
                arquivo: arquivo,
                tamanho: tamanho,
                hash: hash,
                dataModificacao: dataModificacao,
                dataImportacao: dataImportacao,
                quantidadeLinhas: quantidadeLinhas,
                produtosNovos: produtosNovos,
                produtosAtualizados: produtosAtualizados,
                produtosComErro: produtosComErro,
                status: status,
                mensagem: mensagem,
                erros: erros,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportHistoryTable,
      ImportHistoryData,
      $$ImportHistoryTableFilterComposer,
      $$ImportHistoryTableOrderingComposer,
      $$ImportHistoryTableAnnotationComposer,
      $$ImportHistoryTableCreateCompanionBuilder,
      $$ImportHistoryTableUpdateCompanionBuilder,
      (
        ImportHistoryData,
        BaseReferences<_$AppDatabase, $ImportHistoryTable, ImportHistoryData>,
      ),
      ImportHistoryData,
      PrefetchHooks Function()
    >;
typedef $$LabelsTableCreateCompanionBuilder =
    LabelsCompanion Function({
      Value<int> id,
      required String nome,
      required double larguraMm,
      required double alturaMm,
      Value<bool> padrao,
      required DateTime dataCriacao,
      required DateTime dataAtualizacao,
    });
typedef $$LabelsTableUpdateCompanionBuilder =
    LabelsCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<double> larguraMm,
      Value<double> alturaMm,
      Value<bool> padrao,
      Value<DateTime> dataCriacao,
      Value<DateTime> dataAtualizacao,
    });

final class $$LabelsTableReferences
    extends BaseReferences<_$AppDatabase, $LabelsTable, Label> {
  $$LabelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LabelElementsTable, List<LabelElement>>
  _labelElementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.labelElements,
    aliasName: 'labels__id__label_elements__label_id',
  );

  $$LabelElementsTableProcessedTableManager get labelElementsRefs {
    final manager = $$LabelElementsTableTableManager(
      $_db,
      $_db.labelElements,
    ).filter((f) => f.labelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_labelElementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LabelsTableFilterComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get larguraMm => $composableBuilder(
    column: $table.larguraMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get alturaMm => $composableBuilder(
    column: $table.alturaMm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> labelElementsRefs(
    Expression<bool> Function($$LabelElementsTableFilterComposer f) f,
  ) {
    final $$LabelElementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labelElements,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelElementsTableFilterComposer(
            $db: $db,
            $table: $db.labelElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get larguraMm => $composableBuilder(
    column: $table.larguraMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get alturaMm => $composableBuilder(
    column: $table.alturaMm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<double> get larguraMm =>
      $composableBuilder(column: $table.larguraMm, builder: (column) => column);

  GeneratedColumn<double> get alturaMm =>
      $composableBuilder(column: $table.alturaMm, builder: (column) => column);

  GeneratedColumn<bool> get padrao =>
      $composableBuilder(column: $table.padrao, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataAtualizacao => $composableBuilder(
    column: $table.dataAtualizacao,
    builder: (column) => column,
  );

  Expression<T> labelElementsRefs<T extends Object>(
    Expression<T> Function($$LabelElementsTableAnnotationComposer a) f,
  ) {
    final $$LabelElementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labelElements,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelElementsTableAnnotationComposer(
            $db: $db,
            $table: $db.labelElements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabelsTable,
          Label,
          $$LabelsTableFilterComposer,
          $$LabelsTableOrderingComposer,
          $$LabelsTableAnnotationComposer,
          $$LabelsTableCreateCompanionBuilder,
          $$LabelsTableUpdateCompanionBuilder,
          (Label, $$LabelsTableReferences),
          Label,
          PrefetchHooks Function({bool labelElementsRefs})
        > {
  $$LabelsTableTableManager(_$AppDatabase db, $LabelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<double> larguraMm = const Value.absent(),
                Value<double> alturaMm = const Value.absent(),
                Value<bool> padrao = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<DateTime> dataAtualizacao = const Value.absent(),
              }) => LabelsCompanion(
                id: id,
                nome: nome,
                larguraMm: larguraMm,
                alturaMm: alturaMm,
                padrao: padrao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required double larguraMm,
                required double alturaMm,
                Value<bool> padrao = const Value.absent(),
                required DateTime dataCriacao,
                required DateTime dataAtualizacao,
              }) => LabelsCompanion.insert(
                id: id,
                nome: nome,
                larguraMm: larguraMm,
                alturaMm: alturaMm,
                padrao: padrao,
                dataCriacao: dataCriacao,
                dataAtualizacao: dataAtualizacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LabelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({labelElementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (labelElementsRefs) db.labelElements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (labelElementsRefs)
                    await $_getPrefetchedData<
                      Label,
                      $LabelsTable,
                      LabelElement
                    >(
                      currentTable: table,
                      referencedTable: $$LabelsTableReferences
                          ._labelElementsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LabelsTableReferences(
                        db,
                        table,
                        p0,
                      ).labelElementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.labelId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabelsTable,
      Label,
      $$LabelsTableFilterComposer,
      $$LabelsTableOrderingComposer,
      $$LabelsTableAnnotationComposer,
      $$LabelsTableCreateCompanionBuilder,
      $$LabelsTableUpdateCompanionBuilder,
      (Label, $$LabelsTableReferences),
      Label,
      PrefetchHooks Function({bool labelElementsRefs})
    >;
typedef $$LabelElementsTableCreateCompanionBuilder =
    LabelElementsCompanion Function({
      Value<int> id,
      required int labelId,
      required String tipo,
      required double x,
      required double y,
      required double largura,
      required double altura,
      Value<double> rotacao,
      Value<String> fonteFamilia,
      Value<double> fonteTamanho,
      Value<bool> negrito,
      Value<String> alinhamento,
      Value<String?> conteudoLivre,
      Value<int> ordem,
    });
typedef $$LabelElementsTableUpdateCompanionBuilder =
    LabelElementsCompanion Function({
      Value<int> id,
      Value<int> labelId,
      Value<String> tipo,
      Value<double> x,
      Value<double> y,
      Value<double> largura,
      Value<double> altura,
      Value<double> rotacao,
      Value<String> fonteFamilia,
      Value<double> fonteTamanho,
      Value<bool> negrito,
      Value<String> alinhamento,
      Value<String?> conteudoLivre,
      Value<int> ordem,
    });

final class $$LabelElementsTableReferences
    extends BaseReferences<_$AppDatabase, $LabelElementsTable, LabelElement> {
  $$LabelElementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LabelsTable _labelIdTable(_$AppDatabase db) =>
      db.labels.createAlias('label_elements__label_id__labels__id');

  $$LabelsTableProcessedTableManager get labelId {
    final $_column = $_itemColumn<int>('label_id')!;

    final manager = $$LabelsTableTableManager(
      $_db,
      $_db.labels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_labelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LabelElementsTableFilterComposer
    extends Composer<_$AppDatabase, $LabelElementsTable> {
  $$LabelElementsTableFilterComposer({
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

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get largura => $composableBuilder(
    column: $table.largura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altura => $composableBuilder(
    column: $table.altura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rotacao => $composableBuilder(
    column: $table.rotacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fonteFamilia => $composableBuilder(
    column: $table.fonteFamilia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fonteTamanho => $composableBuilder(
    column: $table.fonteTamanho,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get negrito => $composableBuilder(
    column: $table.negrito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alinhamento => $composableBuilder(
    column: $table.alinhamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conteudoLivre => $composableBuilder(
    column: $table.conteudoLivre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  $$LabelsTableFilterComposer get labelId {
    final $$LabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.labels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTableFilterComposer(
            $db: $db,
            $table: $db.labels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabelElementsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabelElementsTable> {
  $$LabelElementsTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get largura => $composableBuilder(
    column: $table.largura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altura => $composableBuilder(
    column: $table.altura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rotacao => $composableBuilder(
    column: $table.rotacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fonteFamilia => $composableBuilder(
    column: $table.fonteFamilia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fonteTamanho => $composableBuilder(
    column: $table.fonteTamanho,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get negrito => $composableBuilder(
    column: $table.negrito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alinhamento => $composableBuilder(
    column: $table.alinhamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conteudoLivre => $composableBuilder(
    column: $table.conteudoLivre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );

  $$LabelsTableOrderingComposer get labelId {
    final $$LabelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.labels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTableOrderingComposer(
            $db: $db,
            $table: $db.labels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabelElementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabelElementsTable> {
  $$LabelElementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get largura =>
      $composableBuilder(column: $table.largura, builder: (column) => column);

  GeneratedColumn<double> get altura =>
      $composableBuilder(column: $table.altura, builder: (column) => column);

  GeneratedColumn<double> get rotacao =>
      $composableBuilder(column: $table.rotacao, builder: (column) => column);

  GeneratedColumn<String> get fonteFamilia => $composableBuilder(
    column: $table.fonteFamilia,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fonteTamanho => $composableBuilder(
    column: $table.fonteTamanho,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get negrito =>
      $composableBuilder(column: $table.negrito, builder: (column) => column);

  GeneratedColumn<String> get alinhamento => $composableBuilder(
    column: $table.alinhamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conteudoLivre => $composableBuilder(
    column: $table.conteudoLivre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  $$LabelsTableAnnotationComposer get labelId {
    final $$LabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.labels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.labels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabelElementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabelElementsTable,
          LabelElement,
          $$LabelElementsTableFilterComposer,
          $$LabelElementsTableOrderingComposer,
          $$LabelElementsTableAnnotationComposer,
          $$LabelElementsTableCreateCompanionBuilder,
          $$LabelElementsTableUpdateCompanionBuilder,
          (LabelElement, $$LabelElementsTableReferences),
          LabelElement,
          PrefetchHooks Function({bool labelId})
        > {
  $$LabelElementsTableTableManager(_$AppDatabase db, $LabelElementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabelElementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabelElementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabelElementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> labelId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> largura = const Value.absent(),
                Value<double> altura = const Value.absent(),
                Value<double> rotacao = const Value.absent(),
                Value<String> fonteFamilia = const Value.absent(),
                Value<double> fonteTamanho = const Value.absent(),
                Value<bool> negrito = const Value.absent(),
                Value<String> alinhamento = const Value.absent(),
                Value<String?> conteudoLivre = const Value.absent(),
                Value<int> ordem = const Value.absent(),
              }) => LabelElementsCompanion(
                id: id,
                labelId: labelId,
                tipo: tipo,
                x: x,
                y: y,
                largura: largura,
                altura: altura,
                rotacao: rotacao,
                fonteFamilia: fonteFamilia,
                fonteTamanho: fonteTamanho,
                negrito: negrito,
                alinhamento: alinhamento,
                conteudoLivre: conteudoLivre,
                ordem: ordem,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int labelId,
                required String tipo,
                required double x,
                required double y,
                required double largura,
                required double altura,
                Value<double> rotacao = const Value.absent(),
                Value<String> fonteFamilia = const Value.absent(),
                Value<double> fonteTamanho = const Value.absent(),
                Value<bool> negrito = const Value.absent(),
                Value<String> alinhamento = const Value.absent(),
                Value<String?> conteudoLivre = const Value.absent(),
                Value<int> ordem = const Value.absent(),
              }) => LabelElementsCompanion.insert(
                id: id,
                labelId: labelId,
                tipo: tipo,
                x: x,
                y: y,
                largura: largura,
                altura: altura,
                rotacao: rotacao,
                fonteFamilia: fonteFamilia,
                fonteTamanho: fonteTamanho,
                negrito: negrito,
                alinhamento: alinhamento,
                conteudoLivre: conteudoLivre,
                ordem: ordem,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LabelElementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({labelId = false}) {
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
                    if (labelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.labelId,
                                referencedTable: $$LabelElementsTableReferences
                                    ._labelIdTable(db),
                                referencedColumn: $$LabelElementsTableReferences
                                    ._labelIdTable(db)
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

typedef $$LabelElementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabelElementsTable,
      LabelElement,
      $$LabelElementsTableFilterComposer,
      $$LabelElementsTableOrderingComposer,
      $$LabelElementsTableAnnotationComposer,
      $$LabelElementsTableCreateCompanionBuilder,
      $$LabelElementsTableUpdateCompanionBuilder,
      (LabelElement, $$LabelElementsTableReferences),
      LabelElement,
      PrefetchHooks Function({bool labelId})
    >;
typedef $$PrintersTableCreateCompanionBuilder =
    PrintersCompanion Function({
      Value<int> id,
      required String nome,
      required String endereco,
      required String tipoConexao,
      required String protocolo,
      Value<bool> padrao,
      Value<DateTime?> ultimaConexao,
    });
typedef $$PrintersTableUpdateCompanionBuilder =
    PrintersCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> endereco,
      Value<String> tipoConexao,
      Value<String> protocolo,
      Value<bool> padrao,
      Value<DateTime?> ultimaConexao,
    });

class $$PrintersTableFilterComposer
    extends Composer<_$AppDatabase, $PrintersTable> {
  $$PrintersTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoConexao => $composableBuilder(
    column: $table.tipoConexao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolo => $composableBuilder(
    column: $table.protocolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaConexao => $composableBuilder(
    column: $table.ultimaConexao,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrintersTableOrderingComposer
    extends Composer<_$AppDatabase, $PrintersTable> {
  $$PrintersTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoConexao => $composableBuilder(
    column: $table.tipoConexao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolo => $composableBuilder(
    column: $table.protocolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaConexao => $composableBuilder(
    column: $table.ultimaConexao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrintersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrintersTable> {
  $$PrintersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get endereco =>
      $composableBuilder(column: $table.endereco, builder: (column) => column);

  GeneratedColumn<String> get tipoConexao => $composableBuilder(
    column: $table.tipoConexao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get protocolo =>
      $composableBuilder(column: $table.protocolo, builder: (column) => column);

  GeneratedColumn<bool> get padrao =>
      $composableBuilder(column: $table.padrao, builder: (column) => column);

  GeneratedColumn<DateTime> get ultimaConexao => $composableBuilder(
    column: $table.ultimaConexao,
    builder: (column) => column,
  );
}

class $$PrintersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrintersTable,
          Printer,
          $$PrintersTableFilterComposer,
          $$PrintersTableOrderingComposer,
          $$PrintersTableAnnotationComposer,
          $$PrintersTableCreateCompanionBuilder,
          $$PrintersTableUpdateCompanionBuilder,
          (Printer, BaseReferences<_$AppDatabase, $PrintersTable, Printer>),
          Printer,
          PrefetchHooks Function()
        > {
  $$PrintersTableTableManager(_$AppDatabase db, $PrintersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrintersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrintersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrintersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> endereco = const Value.absent(),
                Value<String> tipoConexao = const Value.absent(),
                Value<String> protocolo = const Value.absent(),
                Value<bool> padrao = const Value.absent(),
                Value<DateTime?> ultimaConexao = const Value.absent(),
              }) => PrintersCompanion(
                id: id,
                nome: nome,
                endereco: endereco,
                tipoConexao: tipoConexao,
                protocolo: protocolo,
                padrao: padrao,
                ultimaConexao: ultimaConexao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String endereco,
                required String tipoConexao,
                required String protocolo,
                Value<bool> padrao = const Value.absent(),
                Value<DateTime?> ultimaConexao = const Value.absent(),
              }) => PrintersCompanion.insert(
                id: id,
                nome: nome,
                endereco: endereco,
                tipoConexao: tipoConexao,
                protocolo: protocolo,
                padrao: padrao,
                ultimaConexao: ultimaConexao,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrintersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrintersTable,
      Printer,
      $$PrintersTableFilterComposer,
      $$PrintersTableOrderingComposer,
      $$PrintersTableAnnotationComposer,
      $$PrintersTableCreateCompanionBuilder,
      $$PrintersTableUpdateCompanionBuilder,
      (Printer, BaseReferences<_$AppDatabase, $PrintersTable, Printer>),
      Printer,
      PrefetchHooks Function()
    >;
typedef $$ScalesTableCreateCompanionBuilder =
    ScalesCompanion Function({
      Value<int> id,
      required String nome,
      required String endereco,
      required String tipoConexao,
      required String protocolo,
      Value<bool> padrao,
    });
typedef $$ScalesTableUpdateCompanionBuilder =
    ScalesCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> endereco,
      Value<String> tipoConexao,
      Value<String> protocolo,
      Value<bool> padrao,
    });

class $$ScalesTableFilterComposer
    extends Composer<_$AppDatabase, $ScalesTable> {
  $$ScalesTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoConexao => $composableBuilder(
    column: $table.tipoConexao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocolo => $composableBuilder(
    column: $table.protocolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScalesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScalesTable> {
  $$ScalesTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endereco => $composableBuilder(
    column: $table.endereco,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoConexao => $composableBuilder(
    column: $table.tipoConexao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocolo => $composableBuilder(
    column: $table.protocolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScalesTable> {
  $$ScalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get endereco =>
      $composableBuilder(column: $table.endereco, builder: (column) => column);

  GeneratedColumn<String> get tipoConexao => $composableBuilder(
    column: $table.tipoConexao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get protocolo =>
      $composableBuilder(column: $table.protocolo, builder: (column) => column);

  GeneratedColumn<bool> get padrao =>
      $composableBuilder(column: $table.padrao, builder: (column) => column);
}

class $$ScalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScalesTable,
          Scale,
          $$ScalesTableFilterComposer,
          $$ScalesTableOrderingComposer,
          $$ScalesTableAnnotationComposer,
          $$ScalesTableCreateCompanionBuilder,
          $$ScalesTableUpdateCompanionBuilder,
          (Scale, BaseReferences<_$AppDatabase, $ScalesTable, Scale>),
          Scale,
          PrefetchHooks Function()
        > {
  $$ScalesTableTableManager(_$AppDatabase db, $ScalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> endereco = const Value.absent(),
                Value<String> tipoConexao = const Value.absent(),
                Value<String> protocolo = const Value.absent(),
                Value<bool> padrao = const Value.absent(),
              }) => ScalesCompanion(
                id: id,
                nome: nome,
                endereco: endereco,
                tipoConexao: tipoConexao,
                protocolo: protocolo,
                padrao: padrao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String endereco,
                required String tipoConexao,
                required String protocolo,
                Value<bool> padrao = const Value.absent(),
              }) => ScalesCompanion.insert(
                id: id,
                nome: nome,
                endereco: endereco,
                tipoConexao: tipoConexao,
                protocolo: protocolo,
                padrao: padrao,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScalesTable,
      Scale,
      $$ScalesTableFilterComposer,
      $$ScalesTableOrderingComposer,
      $$ScalesTableAnnotationComposer,
      $$ScalesTableCreateCompanionBuilder,
      $$ScalesTableUpdateCompanionBuilder,
      (Scale, BaseReferences<_$AppDatabase, $ScalesTable, Scale>),
      Scale,
      PrefetchHooks Function()
    >;
typedef $$ProductPriceHistoryTableCreateCompanionBuilder =
    ProductPriceHistoryCompanion Function({
      Value<int> id,
      required int produtoId,
      required double precoAnterior,
      required double precoNovo,
      required DateTime data,
      required String origem,
    });
typedef $$ProductPriceHistoryTableUpdateCompanionBuilder =
    ProductPriceHistoryCompanion Function({
      Value<int> id,
      Value<int> produtoId,
      Value<double> precoAnterior,
      Value<double> precoNovo,
      Value<DateTime> data,
      Value<String> origem,
    });

final class $$ProductPriceHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductPriceHistoryTable,
          ProductPriceHistoryData
        > {
  $$ProductPriceHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _produtoIdTable(_$AppDatabase db) => db.products
      .createAlias('product_price_history__produto_id__products__id');

  $$ProductsTableProcessedTableManager get produtoId {
    final $_column = $_itemColumn<int>('produto_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produtoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductPriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ProductPriceHistoryTable> {
  $$ProductPriceHistoryTableFilterComposer({
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

  ColumnFilters<double> get precoAnterior => $composableBuilder(
    column: $table.precoAnterior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precoNovo => $composableBuilder(
    column: $table.precoNovo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get produtoId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductPriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductPriceHistoryTable> {
  $$ProductPriceHistoryTableOrderingComposer({
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

  ColumnOrderings<double> get precoAnterior => $composableBuilder(
    column: $table.precoAnterior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precoNovo => $composableBuilder(
    column: $table.precoNovo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get produtoId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductPriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductPriceHistoryTable> {
  $$ProductPriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get precoAnterior => $composableBuilder(
    column: $table.precoAnterior,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precoNovo =>
      $composableBuilder(column: $table.precoNovo, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get origem =>
      $composableBuilder(column: $table.origem, builder: (column) => column);

  $$ProductsTableAnnotationComposer get produtoId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductPriceHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductPriceHistoryTable,
          ProductPriceHistoryData,
          $$ProductPriceHistoryTableFilterComposer,
          $$ProductPriceHistoryTableOrderingComposer,
          $$ProductPriceHistoryTableAnnotationComposer,
          $$ProductPriceHistoryTableCreateCompanionBuilder,
          $$ProductPriceHistoryTableUpdateCompanionBuilder,
          (ProductPriceHistoryData, $$ProductPriceHistoryTableReferences),
          ProductPriceHistoryData,
          PrefetchHooks Function({bool produtoId})
        > {
  $$ProductPriceHistoryTableTableManager(
    _$AppDatabase db,
    $ProductPriceHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductPriceHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductPriceHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProductPriceHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> produtoId = const Value.absent(),
                Value<double> precoAnterior = const Value.absent(),
                Value<double> precoNovo = const Value.absent(),
                Value<DateTime> data = const Value.absent(),
                Value<String> origem = const Value.absent(),
              }) => ProductPriceHistoryCompanion(
                id: id,
                produtoId: produtoId,
                precoAnterior: precoAnterior,
                precoNovo: precoNovo,
                data: data,
                origem: origem,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int produtoId,
                required double precoAnterior,
                required double precoNovo,
                required DateTime data,
                required String origem,
              }) => ProductPriceHistoryCompanion.insert(
                id: id,
                produtoId: produtoId,
                precoAnterior: precoAnterior,
                precoNovo: precoNovo,
                data: data,
                origem: origem,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductPriceHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produtoId = false}) {
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
                    if (produtoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.produtoId,
                                referencedTable:
                                    $$ProductPriceHistoryTableReferences
                                        ._produtoIdTable(db),
                                referencedColumn:
                                    $$ProductPriceHistoryTableReferences
                                        ._produtoIdTable(db)
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

typedef $$ProductPriceHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductPriceHistoryTable,
      ProductPriceHistoryData,
      $$ProductPriceHistoryTableFilterComposer,
      $$ProductPriceHistoryTableOrderingComposer,
      $$ProductPriceHistoryTableAnnotationComposer,
      $$ProductPriceHistoryTableCreateCompanionBuilder,
      $$ProductPriceHistoryTableUpdateCompanionBuilder,
      (ProductPriceHistoryData, $$ProductPriceHistoryTableReferences),
      ProductPriceHistoryData,
      PrefetchHooks Function({bool produtoId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      required DateTime dataHora,
      required String tipo,
      required String descricao,
      Value<String?> detalhes,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      Value<DateTime> dataHora,
      Value<String> tipo,
      Value<String> descricao,
      Value<String?> detalhes,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
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

  ColumnFilters<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detalhes => $composableBuilder(
    column: $table.detalhes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dataHora => $composableBuilder(
    column: $table.dataHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detalhes => $composableBuilder(
    column: $table.detalhes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataHora =>
      $composableBuilder(column: $table.dataHora, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<String> get detalhes =>
      $composableBuilder(column: $table.detalhes, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> dataHora = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<String?> detalhes = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                dataHora: dataHora,
                tipo: tipo,
                descricao: descricao,
                detalhes: detalhes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime dataHora,
                required String tipo,
                required String descricao,
                Value<String?> detalhes = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                dataHora: dataHora,
                tipo: tipo,
                descricao: descricao,
                detalhes: detalhes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String nome,
      Value<double> percentualComissao,
      Value<bool> ativo,
      required DateTime dataCriacao,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<double> percentualComissao,
      Value<bool> ativo,
      Value<DateTime> dataCriacao,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WeighingEmployeesTable, List<WeighingEmployee>>
  _weighingEmployeesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.weighingEmployees,
        aliasName: 'employees__id__weighing_employees__employee_id',
      );

  $$WeighingEmployeesTableProcessedTableManager get weighingEmployeesRefs {
    final manager = $$WeighingEmployeesTableTableManager(
      $_db,
      $_db.weighingEmployees,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _weighingEmployeesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentualComissao => $composableBuilder(
    column: $table.percentualComissao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> weighingEmployeesRefs(
    Expression<bool> Function($$WeighingEmployeesTableFilterComposer f) f,
  ) {
    final $$WeighingEmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weighingEmployees,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingEmployeesTableFilterComposer(
            $db: $db,
            $table: $db.weighingEmployees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentualComissao => $composableBuilder(
    column: $table.percentualComissao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<double> get percentualComissao => $composableBuilder(
    column: $table.percentualComissao,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  Expression<T> weighingEmployeesRefs<T extends Object>(
    Expression<T> Function($$WeighingEmployeesTableAnnotationComposer a) f,
  ) {
    final $$WeighingEmployeesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.weighingEmployees,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WeighingEmployeesTableAnnotationComposer(
                $db: $db,
                $table: $db.weighingEmployees,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({bool weighingEmployeesRefs})
        > {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<double> percentualComissao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                nome: nome,
                percentualComissao: percentualComissao,
                ativo: ativo,
                dataCriacao: dataCriacao,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<double> percentualComissao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                required DateTime dataCriacao,
              }) => EmployeesCompanion.insert(
                id: id,
                nome: nome,
                percentualComissao: percentualComissao,
                ativo: ativo,
                dataCriacao: dataCriacao,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weighingEmployeesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (weighingEmployeesRefs) db.weighingEmployees,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (weighingEmployeesRefs)
                    await $_getPrefetchedData<
                      Employee,
                      $EmployeesTable,
                      WeighingEmployee
                    >(
                      currentTable: table,
                      referencedTable: $$EmployeesTableReferences
                          ._weighingEmployeesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmployeesTableReferences(
                            db,
                            table,
                            p0,
                          ).weighingEmployeesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.employeeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({bool weighingEmployeesRefs})
    >;
typedef $$WeighingEmployeesTableCreateCompanionBuilder =
    WeighingEmployeesCompanion Function({
      Value<int> id,
      required int weighingId,
      required int employeeId,
    });
typedef $$WeighingEmployeesTableUpdateCompanionBuilder =
    WeighingEmployeesCompanion Function({
      Value<int> id,
      Value<int> weighingId,
      Value<int> employeeId,
    });

final class $$WeighingEmployeesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WeighingEmployeesTable,
          WeighingEmployee
        > {
  $$WeighingEmployeesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeighingHistoryTable _weighingIdTable(_$AppDatabase db) => db
      .weighingHistory
      .createAlias('weighing_employees__weighing_id__weighing_history__id');

  $$WeighingHistoryTableProcessedTableManager get weighingId {
    final $_column = $_itemColumn<int>('weighing_id')!;

    final manager = $$WeighingHistoryTableTableManager(
      $_db,
      $_db.weighingHistory,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weighingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias('weighing_employees__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeighingEmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $WeighingEmployeesTable> {
  $$WeighingEmployeesTableFilterComposer({
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

  $$WeighingHistoryTableFilterComposer get weighingId {
    final $$WeighingHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weighingId,
      referencedTable: $db.weighingHistory,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingHistoryTableFilterComposer(
            $db: $db,
            $table: $db.weighingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeighingEmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeighingEmployeesTable> {
  $$WeighingEmployeesTableOrderingComposer({
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

  $$WeighingHistoryTableOrderingComposer get weighingId {
    final $$WeighingHistoryTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weighingId,
      referencedTable: $db.weighingHistory,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingHistoryTableOrderingComposer(
            $db: $db,
            $table: $db.weighingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeighingEmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeighingEmployeesTable> {
  $$WeighingEmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$WeighingHistoryTableAnnotationComposer get weighingId {
    final $$WeighingHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weighingId,
      referencedTable: $db.weighingHistory,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeighingHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.weighingHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeighingEmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeighingEmployeesTable,
          WeighingEmployee,
          $$WeighingEmployeesTableFilterComposer,
          $$WeighingEmployeesTableOrderingComposer,
          $$WeighingEmployeesTableAnnotationComposer,
          $$WeighingEmployeesTableCreateCompanionBuilder,
          $$WeighingEmployeesTableUpdateCompanionBuilder,
          (WeighingEmployee, $$WeighingEmployeesTableReferences),
          WeighingEmployee,
          PrefetchHooks Function({bool weighingId, bool employeeId})
        > {
  $$WeighingEmployeesTableTableManager(
    _$AppDatabase db,
    $WeighingEmployeesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeighingEmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeighingEmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeighingEmployeesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weighingId = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
              }) => WeighingEmployeesCompanion(
                id: id,
                weighingId: weighingId,
                employeeId: employeeId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weighingId,
                required int employeeId,
              }) => WeighingEmployeesCompanion.insert(
                id: id,
                weighingId: weighingId,
                employeeId: employeeId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeighingEmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weighingId = false, employeeId = false}) {
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
                    if (weighingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.weighingId,
                                referencedTable:
                                    $$WeighingEmployeesTableReferences
                                        ._weighingIdTable(db),
                                referencedColumn:
                                    $$WeighingEmployeesTableReferences
                                        ._weighingIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable:
                                    $$WeighingEmployeesTableReferences
                                        ._employeeIdTable(db),
                                referencedColumn:
                                    $$WeighingEmployeesTableReferences
                                        ._employeeIdTable(db)
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

typedef $$WeighingEmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeighingEmployeesTable,
      WeighingEmployee,
      $$WeighingEmployeesTableFilterComposer,
      $$WeighingEmployeesTableOrderingComposer,
      $$WeighingEmployeesTableAnnotationComposer,
      $$WeighingEmployeesTableCreateCompanionBuilder,
      $$WeighingEmployeesTableUpdateCompanionBuilder,
      (WeighingEmployee, $$WeighingEmployeesTableReferences),
      WeighingEmployee,
      PrefetchHooks Function({bool weighingId, bool employeeId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$WeighingHistoryTableTableManager get weighingHistory =>
      $$WeighingHistoryTableTableManager(_db, _db.weighingHistory);
  $$ImportHistoryTableTableManager get importHistory =>
      $$ImportHistoryTableTableManager(_db, _db.importHistory);
  $$LabelsTableTableManager get labels =>
      $$LabelsTableTableManager(_db, _db.labels);
  $$LabelElementsTableTableManager get labelElements =>
      $$LabelElementsTableTableManager(_db, _db.labelElements);
  $$PrintersTableTableManager get printers =>
      $$PrintersTableTableManager(_db, _db.printers);
  $$ScalesTableTableManager get scales =>
      $$ScalesTableTableManager(_db, _db.scales);
  $$ProductPriceHistoryTableTableManager get productPriceHistory =>
      $$ProductPriceHistoryTableTableManager(_db, _db.productPriceHistory);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$WeighingEmployeesTableTableManager get weighingEmployees =>
      $$WeighingEmployeesTableTableManager(_db, _db.weighingEmployees);
}
