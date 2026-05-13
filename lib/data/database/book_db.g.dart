// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_db.dart';

// ignore_for_file: type=lint
class $DbBookTable extends DbBook
    with TableInfo<$DbBookTable, DbBookData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbBookTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookmarkedMeta =
      const VerificationMeta('bookmarked');
  @override
  late final GeneratedColumn<bool> bookmarked = GeneratedColumn<bool>(
      'bookmarked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("bookmarked" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, image, description, bookmarked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_book';
  @override
  VerificationContext validateIntegrity(Insertable<DbBookData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('bookmarked')) {
      context.handle(
          _bookmarkedMeta,
          bookmarked.isAcceptableOrUnknown(
              data['bookmarked']!, _bookmarkedMeta));
    } else if (isInserting) {
      context.missing(_bookmarkedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbBookData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbBookData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      bookmarked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}bookmarked'])!,
    );
  }

  @override
  $DbBookTable createAlias(String alias) {
    return $DbBookTable(attachedDatabase, alias);
  }
}

class DbBookData extends DataClass implements Insertable<DbBookData> {
  final int id;
  final String label;
  final String image;
  final String description;
  final bool bookmarked;
  const DbBookData(
      {required this.id,
      required this.label,
      required this.image,
      required this.description,
      required this.bookmarked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    map['image'] = Variable<String>(image);
    map['description'] = Variable<String>(description);
    map['bookmarked'] = Variable<bool>(bookmarked);
    return map;
  }

  DbBookCompanion toCompanion(bool nullToAbsent) {
    return DbBookCompanion(
      id: Value(id),
      label: Value(label),
      image: Value(image),
      description: Value(description),
      bookmarked: Value(bookmarked),
    );
  }

  factory DbBookData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbBookData(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      image: serializer.fromJson<String>(json['image']),
      description: serializer.fromJson<String>(json['description']),
      bookmarked: serializer.fromJson<bool>(json['bookmarked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'image': serializer.toJson<String>(image),
      'description': serializer.toJson<String>(description),
      'bookmarked': serializer.toJson<bool>(bookmarked),
    };
  }

  DbBookData copyWith(
          {int? id,
          String? label,
          String? image,
          String? description,
          bool? bookmarked}) =>
      DbBookData(
        id: id ?? this.id,
        label: label ?? this.label,
        image: image ?? this.image,
        description: description ?? this.description,
        bookmarked: bookmarked ?? this.bookmarked,
      );
  @override
  String toString() {
    return (StringBuffer('DbBookData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('image: $image, ')
          ..write('description: $description, ')
          ..write('bookmarked: $bookmarked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, image, description, bookmarked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbBookData &&
          other.id == this.id &&
          other.label == this.label &&
          other.image == this.image &&
          other.description == this.description &&
          other.bookmarked == this.bookmarked);
}

class DbBookCompanion extends UpdateCompanion<DbBookData> {
  final Value<int> id;
  final Value<String> label;
  final Value<String> image;
  final Value<String> description;
  final Value<bool> bookmarked;
  const DbBookCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.image = const Value.absent(),
    this.description = const Value.absent(),
    this.bookmarked = const Value.absent(),
  });
  DbBookCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required String image,
    required String description,
    required bool bookmarked,
  })  : label = Value(label),
        image = Value(image),
        description = Value(description),
        bookmarked = Value(bookmarked);
  static Insertable<DbBookData> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? image,
    Expression<String>? description,
    Expression<bool>? bookmarked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (image != null) 'image': image,
      if (description != null) 'description': description,
      if (bookmarked != null) 'bookmarked': bookmarked,
    });
  }

  DbBookCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<String>? image,
      Value<String>? description,
      Value<bool>? bookmarked}) {
    return DbBookCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      image: image ?? this.image,
      description: description ?? this.description,
      bookmarked: bookmarked ?? this.bookmarked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (bookmarked.present) {
      map['bookmarked'] = Variable<bool>(bookmarked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbBookCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('image: $image, ')
          ..write('description: $description, ')
          ..write('bookmarked: $bookmarked')
          ..write(')'))
        .toString();
  }
}

class $DbBookTagTable extends DbBookTag
    with TableInfo<$DbBookTagTable, DbBookTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbBookTagTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookIdMeta =
      const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, bookId, name, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_book_tag';
  @override
  VerificationContext validateIntegrity(Insertable<DbBookTagData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbBookTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbBookTagData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $DbBookTagTable createAlias(String alias) {
    return $DbBookTagTable(attachedDatabase, alias);
  }
}

class DbBookTagData extends DataClass
    implements Insertable<DbBookTagData> {
  final int id;
  final int bookId;
  final String name;
  final double amount;
  const DbBookTagData(
      {required this.id,
      required this.bookId,
      required this.name,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  DbBookTagCompanion toCompanion(bool nullToAbsent) {
    return DbBookTagCompanion(
      id: Value(id),
      bookId: Value(bookId),
      name: Value(name),
      amount: Value(amount),
    );
  }

  factory DbBookTagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbBookTagData(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
    };
  }

  DbBookTagData copyWith(
          {int? id, int? bookId, String? name, double? amount}) =>
      DbBookTagData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
      );
  @override
  String toString() {
    return (StringBuffer('DbBookTagData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, name, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbBookTagData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.name == this.name &&
          other.amount == this.amount);
}

class DbBookTagCompanion extends UpdateCompanion<DbBookTagData> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<String> name;
  final Value<double> amount;
  const DbBookTagCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
  });
  DbBookTagCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required String name,
    required double amount,
  })  : bookId = Value(bookId),
        name = Value(name),
        amount = Value(amount);
  static Insertable<DbBookTagData> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<String>? name,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
    });
  }

  DbBookTagCompanion copyWith(
      {Value<int>? id,
      Value<int>? bookId,
      Value<String>? name,
      Value<double>? amount}) {
    return DbBookTagCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbBookTagCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('name: $name, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

abstract class _$BookDatabase extends GeneratedDatabase {
  _$BookDatabase(QueryExecutor e) : super(e);
  late final $DbBookTable dbBook = $DbBookTable(this);
  late final $DbBookTagTable dbBookTag = $DbBookTagTable(this);
  late final BookDao bookDao = BookDao(this as BookDatabase);
  late final BookTagDao bookTagDao =
      BookTagDao(this as BookDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dbBook, dbBookTag];
}

mixin _$BookDaoMixin on DatabaseAccessor<BookDatabase> {
  $DbBookTable get dbBook => attachedDatabase.dbBook;
}
mixin _$BookTagDaoMixin on DatabaseAccessor<BookDatabase> {
  $DbBookTagTable get dbBookTag => attachedDatabase.dbBookTag;
}
