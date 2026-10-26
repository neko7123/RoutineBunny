// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutineItemsTable extends RoutineItems
    with TableInfo<$RoutineItemsTable, RoutineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customFieldsJsonMeta =
      const VerificationMeta('customFieldsJson');
  @override
  late final GeneratedColumn<String> customFieldsJson = GeneratedColumn<String>(
      'custom_fields_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _isPausedMeta =
      const VerificationMeta('isPaused');
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
      'is_paused', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paused" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        description,
        photoPath,
        customFieldsJson,
        isPaused,
        isArchived,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_items';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('custom_fields_json')) {
      context.handle(
          _customFieldsJsonMeta,
          customFieldsJson.isAcceptableOrUnknown(
              data['custom_fields_json']!, _customFieldsJsonMeta));
    }
    if (data.containsKey('is_paused')) {
      context.handle(_isPausedMeta,
          isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      customFieldsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_fields_json'])!,
      isPaused: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paused'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RoutineItemsTable createAlias(String alias) {
    return $RoutineItemsTable(attachedDatabase, alias);
  }
}

class RoutineItem extends DataClass implements Insertable<RoutineItem> {
  final String id;
  final String name;
  final String category;
  final String? description;
  final String? photoPath;
  final String customFieldsJson;
  final bool isPaused;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineItem(
      {required this.id,
      required this.name,
      required this.category,
      this.description,
      this.photoPath,
      required this.customFieldsJson,
      required this.isPaused,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['custom_fields_json'] = Variable<String>(customFieldsJson);
    map['is_paused'] = Variable<bool>(isPaused);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineItemsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      customFieldsJson: Value(customFieldsJson),
      isPaused: Value(isPaused),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      customFieldsJson: serializer.fromJson<String>(json['customFieldsJson']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'photoPath': serializer.toJson<String?>(photoPath),
      'customFieldsJson': serializer.toJson<String>(customFieldsJson),
      'isPaused': serializer.toJson<bool>(isPaused),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineItem copyWith(
          {String? id,
          String? name,
          String? category,
          Value<String?> description = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          String? customFieldsJson,
          bool? isPaused,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RoutineItem(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        customFieldsJson: customFieldsJson ?? this.customFieldsJson,
        isPaused: isPaused ?? this.isPaused,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RoutineItem copyWithCompanion(RoutineItemsCompanion data) {
    return RoutineItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      customFieldsJson: data.customFieldsJson.present
          ? data.customFieldsJson.value
          : this.customFieldsJson,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('photoPath: $photoPath, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('isPaused: $isPaused, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, description, photoPath,
      customFieldsJson, isPaused, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.description == this.description &&
          other.photoPath == this.photoPath &&
          other.customFieldsJson == this.customFieldsJson &&
          other.isPaused == this.isPaused &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineItemsCompanion extends UpdateCompanion<RoutineItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> description;
  final Value<String?> photoPath;
  final Value<String> customFieldsJson;
  final Value<bool> isPaused;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineItemsCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.description = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        category = Value(category),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RoutineItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? photoPath,
    Expression<String>? customFieldsJson,
    Expression<bool>? isPaused,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (photoPath != null) 'photo_path': photoPath,
      if (customFieldsJson != null) 'custom_fields_json': customFieldsJson,
      if (isPaused != null) 'is_paused': isPaused,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? category,
      Value<String?>? description,
      Value<String?>? photoPath,
      Value<String>? customFieldsJson,
      Value<bool>? isPaused,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RoutineItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      customFieldsJson: customFieldsJson ?? this.customFieldsJson,
      isPaused: isPaused ?? this.isPaused,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (customFieldsJson.present) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('photoPath: $photoPath, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('isPaused: $isPaused, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineSchedulesTable extends RoutineSchedules
    with TableInfo<$RoutineSchedulesTable, RoutineSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES routine_items (id)'));
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekdaysMaskMeta =
      const VerificationMeta('weekdaysMask');
  @override
  late final GeneratedColumn<int> weekdaysMask = GeneratedColumn<int>(
      'weekdays_mask', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _oneTimeDateMeta =
      const VerificationMeta('oneTimeDate');
  @override
  late final GeneratedColumn<DateTime> oneTimeDate = GeneratedColumn<DateTime>(
      'one_time_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, itemId, kind, weekdaysMask, oneTimeDate, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('weekdays_mask')) {
      context.handle(
          _weekdaysMaskMeta,
          weekdaysMask.isAcceptableOrUnknown(
              data['weekdays_mask']!, _weekdaysMaskMeta));
    }
    if (data.containsKey('one_time_date')) {
      context.handle(
          _oneTimeDateMeta,
          oneTimeDate.isAcceptableOrUnknown(
              data['one_time_date']!, _oneTimeDateMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineSchedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      weekdaysMask: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekdays_mask'])!,
      oneTimeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}one_time_date']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  $RoutineSchedulesTable createAlias(String alias) {
    return $RoutineSchedulesTable(attachedDatabase, alias);
  }
}

class RoutineSchedule extends DataClass implements Insertable<RoutineSchedule> {
  final String id;
  final String itemId;
  final String kind;
  final int weekdaysMask;
  final DateTime? oneTimeDate;
  final DateTime? startDate;
  final DateTime? endDate;
  const RoutineSchedule(
      {required this.id,
      required this.itemId,
      required this.kind,
      required this.weekdaysMask,
      this.oneTimeDate,
      this.startDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['kind'] = Variable<String>(kind);
    map['weekdays_mask'] = Variable<int>(weekdaysMask);
    if (!nullToAbsent || oneTimeDate != null) {
      map['one_time_date'] = Variable<DateTime>(oneTimeDate);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  RoutineSchedulesCompanion toCompanion(bool nullToAbsent) {
    return RoutineSchedulesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      kind: Value(kind),
      weekdaysMask: Value(weekdaysMask),
      oneTimeDate: oneTimeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(oneTimeDate),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory RoutineSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineSchedule(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      kind: serializer.fromJson<String>(json['kind']),
      weekdaysMask: serializer.fromJson<int>(json['weekdaysMask']),
      oneTimeDate: serializer.fromJson<DateTime?>(json['oneTimeDate']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'kind': serializer.toJson<String>(kind),
      'weekdaysMask': serializer.toJson<int>(weekdaysMask),
      'oneTimeDate': serializer.toJson<DateTime?>(oneTimeDate),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  RoutineSchedule copyWith(
          {String? id,
          String? itemId,
          String? kind,
          int? weekdaysMask,
          Value<DateTime?> oneTimeDate = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent()}) =>
      RoutineSchedule(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        kind: kind ?? this.kind,
        weekdaysMask: weekdaysMask ?? this.weekdaysMask,
        oneTimeDate: oneTimeDate.present ? oneTimeDate.value : this.oneTimeDate,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  RoutineSchedule copyWithCompanion(RoutineSchedulesCompanion data) {
    return RoutineSchedule(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      kind: data.kind.present ? data.kind.value : this.kind,
      weekdaysMask: data.weekdaysMask.present
          ? data.weekdaysMask.value
          : this.weekdaysMask,
      oneTimeDate:
          data.oneTimeDate.present ? data.oneTimeDate.value : this.oneTimeDate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineSchedule(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('kind: $kind, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('oneTimeDate: $oneTimeDate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, itemId, kind, weekdaysMask, oneTimeDate, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineSchedule &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.kind == this.kind &&
          other.weekdaysMask == this.weekdaysMask &&
          other.oneTimeDate == this.oneTimeDate &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class RoutineSchedulesCompanion extends UpdateCompanion<RoutineSchedule> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<String> kind;
  final Value<int> weekdaysMask;
  final Value<DateTime?> oneTimeDate;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<int> rowid;
  const RoutineSchedulesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.kind = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    this.oneTimeDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineSchedulesCompanion.insert({
    required String id,
    required String itemId,
    required String kind,
    this.weekdaysMask = const Value.absent(),
    this.oneTimeDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        kind = Value(kind);
  static Insertable<RoutineSchedule> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<String>? kind,
    Expression<int>? weekdaysMask,
    Expression<DateTime>? oneTimeDate,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (kind != null) 'kind': kind,
      if (weekdaysMask != null) 'weekdays_mask': weekdaysMask,
      if (oneTimeDate != null) 'one_time_date': oneTimeDate,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineSchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<String>? kind,
      Value<int>? weekdaysMask,
      Value<DateTime?>? oneTimeDate,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<int>? rowid}) {
    return RoutineSchedulesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      kind: kind ?? this.kind,
      weekdaysMask: weekdaysMask ?? this.weekdaysMask,
      oneTimeDate: oneTimeDate ?? this.oneTimeDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (weekdaysMask.present) {
      map['weekdays_mask'] = Variable<int>(weekdaysMask.value);
    }
    if (oneTimeDate.present) {
      map['one_time_date'] = Variable<DateTime>(oneTimeDate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('kind: $kind, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('oneTimeDate: $oneTimeDate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineTimeSlotsTable extends RoutineTimeSlots
    with TableInfo<$RoutineTimeSlotsTable, RoutineTimeSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineTimeSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES routine_schedules (id)'));
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reminderMinutesBeforeMeta =
      const VerificationMeta('reminderMinutesBefore');
  @override
  late final GeneratedColumn<int> reminderMinutesBefore = GeneratedColumn<int>(
      'reminder_minutes_before', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, scheduleId, hour, minute, reminderMinutesBefore];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_time_slots';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineTimeSlot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('reminder_minutes_before')) {
      context.handle(
          _reminderMinutesBeforeMeta,
          reminderMinutesBefore.isAcceptableOrUnknown(
              data['reminder_minutes_before']!, _reminderMinutesBeforeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineTimeSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineTimeSlot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
      reminderMinutesBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reminder_minutes_before'])!,
    );
  }

  @override
  $RoutineTimeSlotsTable createAlias(String alias) {
    return $RoutineTimeSlotsTable(attachedDatabase, alias);
  }
}

class RoutineTimeSlot extends DataClass implements Insertable<RoutineTimeSlot> {
  final int id;
  final String scheduleId;
  final int hour;
  final int minute;
  final int reminderMinutesBefore;
  const RoutineTimeSlot(
      {required this.id,
      required this.scheduleId,
      required this.hour,
      required this.minute,
      required this.reminderMinutesBefore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['reminder_minutes_before'] = Variable<int>(reminderMinutesBefore);
    return map;
  }

  RoutineTimeSlotsCompanion toCompanion(bool nullToAbsent) {
    return RoutineTimeSlotsCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      hour: Value(hour),
      minute: Value(minute),
      reminderMinutesBefore: Value(reminderMinutesBefore),
    );
  }

  factory RoutineTimeSlot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineTimeSlot(
      id: serializer.fromJson<int>(json['id']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      reminderMinutesBefore:
          serializer.fromJson<int>(json['reminderMinutesBefore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'reminderMinutesBefore': serializer.toJson<int>(reminderMinutesBefore),
    };
  }

  RoutineTimeSlot copyWith(
          {int? id,
          String? scheduleId,
          int? hour,
          int? minute,
          int? reminderMinutesBefore}) =>
      RoutineTimeSlot(
        id: id ?? this.id,
        scheduleId: scheduleId ?? this.scheduleId,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        reminderMinutesBefore:
            reminderMinutesBefore ?? this.reminderMinutesBefore,
      );
  RoutineTimeSlot copyWithCompanion(RoutineTimeSlotsCompanion data) {
    return RoutineTimeSlot(
      id: data.id.present ? data.id.value : this.id,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      reminderMinutesBefore: data.reminderMinutesBefore.present
          ? data.reminderMinutesBefore.value
          : this.reminderMinutesBefore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineTimeSlot(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, scheduleId, hour, minute, reminderMinutesBefore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineTimeSlot &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.reminderMinutesBefore == this.reminderMinutesBefore);
}

class RoutineTimeSlotsCompanion extends UpdateCompanion<RoutineTimeSlot> {
  final Value<int> id;
  final Value<String> scheduleId;
  final Value<int> hour;
  final Value<int> minute;
  final Value<int> reminderMinutesBefore;
  const RoutineTimeSlotsCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.reminderMinutesBefore = const Value.absent(),
  });
  RoutineTimeSlotsCompanion.insert({
    this.id = const Value.absent(),
    required String scheduleId,
    required int hour,
    required int minute,
    this.reminderMinutesBefore = const Value.absent(),
  })  : scheduleId = Value(scheduleId),
        hour = Value(hour),
        minute = Value(minute);
  static Insertable<RoutineTimeSlot> custom({
    Expression<int>? id,
    Expression<String>? scheduleId,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<int>? reminderMinutesBefore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (reminderMinutesBefore != null)
        'reminder_minutes_before': reminderMinutesBefore,
    });
  }

  RoutineTimeSlotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? scheduleId,
      Value<int>? hour,
      Value<int>? minute,
      Value<int>? reminderMinutesBefore}) {
    return RoutineTimeSlotsCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (reminderMinutesBefore.present) {
      map['reminder_minutes_before'] =
          Variable<int>(reminderMinutesBefore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineTimeSlotsCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('reminderMinutesBefore: $reminderMinutesBefore')
          ..write(')'))
        .toString();
  }
}

class $RoutineOccurrencesTable extends RoutineOccurrences
    with TableInfo<$RoutineOccurrencesTable, RoutineOccurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES routine_items (id)'));
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, itemId, scheduledAt, status, recordedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_occurrences';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineOccurrence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineOccurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineOccurrence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at']),
    );
  }

  @override
  $RoutineOccurrencesTable createAlias(String alias) {
    return $RoutineOccurrencesTable(attachedDatabase, alias);
  }
}

class RoutineOccurrence extends DataClass
    implements Insertable<RoutineOccurrence> {
  final String id;
  final String itemId;
  final DateTime scheduledAt;
  final String status;
  final DateTime? recordedAt;
  const RoutineOccurrence(
      {required this.id,
      required this.itemId,
      required this.scheduledAt,
      required this.status,
      this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_id'] = Variable<String>(itemId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || recordedAt != null) {
      map['recorded_at'] = Variable<DateTime>(recordedAt);
    }
    return map;
  }

  RoutineOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return RoutineOccurrencesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      scheduledAt: Value(scheduledAt),
      status: Value(status),
      recordedAt: recordedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(recordedAt),
    );
  }

  factory RoutineOccurrence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineOccurrence(
      id: serializer.fromJson<String>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      status: serializer.fromJson<String>(json['status']),
      recordedAt: serializer.fromJson<DateTime?>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemId': serializer.toJson<String>(itemId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'status': serializer.toJson<String>(status),
      'recordedAt': serializer.toJson<DateTime?>(recordedAt),
    };
  }

  RoutineOccurrence copyWith(
          {String? id,
          String? itemId,
          DateTime? scheduledAt,
          String? status,
          Value<DateTime?> recordedAt = const Value.absent()}) =>
      RoutineOccurrence(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        status: status ?? this.status,
        recordedAt: recordedAt.present ? recordedAt.value : this.recordedAt,
      );
  RoutineOccurrence copyWithCompanion(RoutineOccurrencesCompanion data) {
    return RoutineOccurrence(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineOccurrence(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, scheduledAt, status, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineOccurrence &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status &&
          other.recordedAt == this.recordedAt);
}

class RoutineOccurrencesCompanion extends UpdateCompanion<RoutineOccurrence> {
  final Value<String> id;
  final Value<String> itemId;
  final Value<DateTime> scheduledAt;
  final Value<String> status;
  final Value<DateTime?> recordedAt;
  final Value<int> rowid;
  const RoutineOccurrencesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineOccurrencesCompanion.insert({
    required String id,
    required String itemId,
    required DateTime scheduledAt,
    required String status,
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemId = Value(itemId),
        scheduledAt = Value(scheduledAt),
        status = Value(status);
  static Insertable<RoutineOccurrence> custom({
    Expression<String>? id,
    Expression<String>? itemId,
    Expression<DateTime>? scheduledAt,
    Expression<String>? status,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineOccurrencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemId,
      Value<DateTime>? scheduledAt,
      Value<String>? status,
      Value<DateTime?>? recordedAt,
      Value<int>? rowid}) {
    return RoutineOccurrencesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineOccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineScheduleOverridesTable extends RoutineScheduleOverrides
    with TableInfo<$RoutineScheduleOverridesTable, RoutineScheduleOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineScheduleOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES routine_items (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _timeSlotsJsonMeta =
      const VerificationMeta('timeSlotsJson');
  @override
  late final GeneratedColumn<String> timeSlotsJson = GeneratedColumn<String>(
      'time_slots_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isCancelledMeta =
      const VerificationMeta('isCancelled');
  @override
  late final GeneratedColumn<bool> isCancelled = GeneratedColumn<bool>(
      'is_cancelled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_cancelled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [itemId, date, timeSlotsJson, isCancelled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_schedule_overrides';
  @override
  VerificationContext validateIntegrity(
      Insertable<RoutineScheduleOverride> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time_slots_json')) {
      context.handle(
          _timeSlotsJsonMeta,
          timeSlotsJson.isAcceptableOrUnknown(
              data['time_slots_json']!, _timeSlotsJsonMeta));
    }
    if (data.containsKey('is_cancelled')) {
      context.handle(
          _isCancelledMeta,
          isCancelled.isAcceptableOrUnknown(
              data['is_cancelled']!, _isCancelledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, date};
  @override
  RoutineScheduleOverride map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineScheduleOverride(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      timeSlotsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}time_slots_json'])!,
      isCancelled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_cancelled'])!,
    );
  }

  @override
  $RoutineScheduleOverridesTable createAlias(String alias) {
    return $RoutineScheduleOverridesTable(attachedDatabase, alias);
  }
}

class RoutineScheduleOverride extends DataClass
    implements Insertable<RoutineScheduleOverride> {
  final String itemId;
  final DateTime date;
  final String timeSlotsJson;
  final bool isCancelled;
  const RoutineScheduleOverride(
      {required this.itemId,
      required this.date,
      required this.timeSlotsJson,
      required this.isCancelled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['date'] = Variable<DateTime>(date);
    map['time_slots_json'] = Variable<String>(timeSlotsJson);
    map['is_cancelled'] = Variable<bool>(isCancelled);
    return map;
  }

  RoutineScheduleOverridesCompanion toCompanion(bool nullToAbsent) {
    return RoutineScheduleOverridesCompanion(
      itemId: Value(itemId),
      date: Value(date),
      timeSlotsJson: Value(timeSlotsJson),
      isCancelled: Value(isCancelled),
    );
  }

  factory RoutineScheduleOverride.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineScheduleOverride(
      itemId: serializer.fromJson<String>(json['itemId']),
      date: serializer.fromJson<DateTime>(json['date']),
      timeSlotsJson: serializer.fromJson<String>(json['timeSlotsJson']),
      isCancelled: serializer.fromJson<bool>(json['isCancelled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'date': serializer.toJson<DateTime>(date),
      'timeSlotsJson': serializer.toJson<String>(timeSlotsJson),
      'isCancelled': serializer.toJson<bool>(isCancelled),
    };
  }

  RoutineScheduleOverride copyWith(
          {String? itemId,
          DateTime? date,
          String? timeSlotsJson,
          bool? isCancelled}) =>
      RoutineScheduleOverride(
        itemId: itemId ?? this.itemId,
        date: date ?? this.date,
        timeSlotsJson: timeSlotsJson ?? this.timeSlotsJson,
        isCancelled: isCancelled ?? this.isCancelled,
      );
  RoutineScheduleOverride copyWithCompanion(
      RoutineScheduleOverridesCompanion data) {
    return RoutineScheduleOverride(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      date: data.date.present ? data.date.value : this.date,
      timeSlotsJson: data.timeSlotsJson.present
          ? data.timeSlotsJson.value
          : this.timeSlotsJson,
      isCancelled:
          data.isCancelled.present ? data.isCancelled.value : this.isCancelled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineScheduleOverride(')
          ..write('itemId: $itemId, ')
          ..write('date: $date, ')
          ..write('timeSlotsJson: $timeSlotsJson, ')
          ..write('isCancelled: $isCancelled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, date, timeSlotsJson, isCancelled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineScheduleOverride &&
          other.itemId == this.itemId &&
          other.date == this.date &&
          other.timeSlotsJson == this.timeSlotsJson &&
          other.isCancelled == this.isCancelled);
}

class RoutineScheduleOverridesCompanion
    extends UpdateCompanion<RoutineScheduleOverride> {
  final Value<String> itemId;
  final Value<DateTime> date;
  final Value<String> timeSlotsJson;
  final Value<bool> isCancelled;
  final Value<int> rowid;
  const RoutineScheduleOverridesCompanion({
    this.itemId = const Value.absent(),
    this.date = const Value.absent(),
    this.timeSlotsJson = const Value.absent(),
    this.isCancelled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineScheduleOverridesCompanion.insert({
    required String itemId,
    required DateTime date,
    this.timeSlotsJson = const Value.absent(),
    this.isCancelled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : itemId = Value(itemId),
        date = Value(date);
  static Insertable<RoutineScheduleOverride> custom({
    Expression<String>? itemId,
    Expression<DateTime>? date,
    Expression<String>? timeSlotsJson,
    Expression<bool>? isCancelled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (date != null) 'date': date,
      if (timeSlotsJson != null) 'time_slots_json': timeSlotsJson,
      if (isCancelled != null) 'is_cancelled': isCancelled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineScheduleOverridesCompanion copyWith(
      {Value<String>? itemId,
      Value<DateTime>? date,
      Value<String>? timeSlotsJson,
      Value<bool>? isCancelled,
      Value<int>? rowid}) {
    return RoutineScheduleOverridesCompanion(
      itemId: itemId ?? this.itemId,
      date: date ?? this.date,
      timeSlotsJson: timeSlotsJson ?? this.timeSlotsJson,
      isCancelled: isCancelled ?? this.isCancelled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (timeSlotsJson.present) {
      map['time_slots_json'] = Variable<String>(timeSlotsJson.value);
    }
    if (isCancelled.present) {
      map['is_cancelled'] = Variable<bool>(isCancelled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineScheduleOverridesCompanion(')
          ..write('itemId: $itemId, ')
          ..write('date: $date, ')
          ..write('timeSlotsJson: $timeSlotsJson, ')
          ..write('isCancelled: $isCancelled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutineItemsTable routineItems = $RoutineItemsTable(this);
  late final $RoutineSchedulesTable routineSchedules =
      $RoutineSchedulesTable(this);
  late final $RoutineTimeSlotsTable routineTimeSlots =
      $RoutineTimeSlotsTable(this);
  late final $RoutineOccurrencesTable routineOccurrences =
      $RoutineOccurrencesTable(this);
  late final $RoutineScheduleOverridesTable routineScheduleOverrides =
      $RoutineScheduleOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        routineItems,
        routineSchedules,
        routineTimeSlots,
        routineOccurrences,
        routineScheduleOverrides
      ];
}

typedef $$RoutineItemsTableCreateCompanionBuilder = RoutineItemsCompanion
    Function({
  required String id,
  required String name,
  required String category,
  Value<String?> description,
  Value<String?> photoPath,
  Value<String> customFieldsJson,
  Value<bool> isPaused,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RoutineItemsTableUpdateCompanionBuilder = RoutineItemsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> category,
  Value<String?> description,
  Value<String?> photoPath,
  Value<String> customFieldsJson,
  Value<bool> isPaused,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RoutineItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineItemsTable, RoutineItem> {
  $$RoutineItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineSchedulesTable, List<RoutineSchedule>>
      _routineSchedulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.routineSchedules,
              aliasName: 'routine_items__id__routine_schedules__item_id');

  $$RoutineSchedulesTableProcessedTableManager get routineSchedulesRefs {
    final manager =
        $$RoutineSchedulesTableTableManager($_db, $_db.routineSchedules)
            .filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_routineSchedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RoutineOccurrencesTable, List<RoutineOccurrence>>
      _routineOccurrencesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.routineOccurrences,
              aliasName: 'routine_items__id__routine_occurrences__item_id');

  $$RoutineOccurrencesTableProcessedTableManager get routineOccurrencesRefs {
    final manager =
        $$RoutineOccurrencesTableTableManager($_db, $_db.routineOccurrences)
            .filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_routineOccurrencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RoutineScheduleOverridesTable,
      List<RoutineScheduleOverride>> _routineScheduleOverridesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.routineScheduleOverrides,
          aliasName: 'routine_items__id__routine_schedule_overrides__item_id');

  $$RoutineScheduleOverridesTableProcessedTableManager
      get routineScheduleOverridesRefs {
    final manager = $$RoutineScheduleOverridesTableTableManager(
            $_db, $_db.routineScheduleOverrides)
        .filter((f) => f.itemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_routineScheduleOverridesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoutineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customFieldsJson => $composableBuilder(
      column: $table.customFieldsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaused => $composableBuilder(
      column: $table.isPaused, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> routineSchedulesRefs(
      Expression<bool> Function($$RoutineSchedulesTableFilterComposer f) f) {
    final $$RoutineSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineSchedules,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.routineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> routineOccurrencesRefs(
      Expression<bool> Function($$RoutineOccurrencesTableFilterComposer f) f) {
    final $$RoutineOccurrencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineOccurrences,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineOccurrencesTableFilterComposer(
              $db: $db,
              $table: $db.routineOccurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> routineScheduleOverridesRefs(
      Expression<bool> Function($$RoutineScheduleOverridesTableFilterComposer f)
          f) {
    final $$RoutineScheduleOverridesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.routineScheduleOverrides,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RoutineScheduleOverridesTableFilterComposer(
                  $db: $db,
                  $table: $db.routineScheduleOverrides,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RoutineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customFieldsJson => $composableBuilder(
      column: $table.customFieldsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaused => $composableBuilder(
      column: $table.isPaused, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RoutineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get customFieldsJson => $composableBuilder(
      column: $table.customFieldsJson, builder: (column) => column);

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> routineSchedulesRefs<T extends Object>(
      Expression<T> Function($$RoutineSchedulesTableAnnotationComposer a) f) {
    final $$RoutineSchedulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineSchedules,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineSchedulesTableAnnotationComposer(
              $db: $db,
              $table: $db.routineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> routineOccurrencesRefs<T extends Object>(
      Expression<T> Function($$RoutineOccurrencesTableAnnotationComposer a) f) {
    final $$RoutineOccurrencesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.routineOccurrences,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RoutineOccurrencesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.routineOccurrences,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> routineScheduleOverridesRefs<T extends Object>(
      Expression<T> Function(
              $$RoutineScheduleOverridesTableAnnotationComposer a)
          f) {
    final $$RoutineScheduleOverridesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.routineScheduleOverrides,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RoutineScheduleOverridesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.routineScheduleOverrides,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RoutineItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineItemsTable,
    RoutineItem,
    $$RoutineItemsTableFilterComposer,
    $$RoutineItemsTableOrderingComposer,
    $$RoutineItemsTableAnnotationComposer,
    $$RoutineItemsTableCreateCompanionBuilder,
    $$RoutineItemsTableUpdateCompanionBuilder,
    (RoutineItem, $$RoutineItemsTableReferences),
    RoutineItem,
    PrefetchHooks Function(
        {bool routineSchedulesRefs,
        bool routineOccurrencesRefs,
        bool routineScheduleOverridesRefs})> {
  $$RoutineItemsTableTableManager(_$AppDatabase db, $RoutineItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String> customFieldsJson = const Value.absent(),
            Value<bool> isPaused = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineItemsCompanion(
            id: id,
            name: name,
            category: category,
            description: description,
            photoPath: photoPath,
            customFieldsJson: customFieldsJson,
            isPaused: isPaused,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String category,
            Value<String?> description = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String> customFieldsJson = const Value.absent(),
            Value<bool> isPaused = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineItemsCompanion.insert(
            id: id,
            name: name,
            category: category,
            description: description,
            photoPath: photoPath,
            customFieldsJson: customFieldsJson,
            isPaused: isPaused,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineItemsTable, RoutineItem>(table),
                    $$RoutineItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {routineSchedulesRefs = false,
              routineOccurrencesRefs = false,
              routineScheduleOverridesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineSchedulesRefs) db.routineSchedules,
                if (routineOccurrencesRefs) db.routineOccurrences,
                if (routineScheduleOverridesRefs) db.routineScheduleOverrides
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineSchedulesRefs)
                    await $_getPrefetchedDataByColumns<
                            RoutineItem,
                            $RoutineItemsTable,
                            RoutineSchedule,
                            $RoutineSchedulesTable>(
                        currentTable: table,
                        referencedTable: $$RoutineItemsTableReferences
                            ._routineSchedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutineItemsTableReferences(db, table, p0)
                                .routineSchedulesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'item_id',
                        typedResults: items),
                  if (routineOccurrencesRefs)
                    await $_getPrefetchedDataByColumns<
                            RoutineItem,
                            $RoutineItemsTable,
                            RoutineOccurrence,
                            $RoutineOccurrencesTable>(
                        currentTable: table,
                        referencedTable: $$RoutineItemsTableReferences
                            ._routineOccurrencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutineItemsTableReferences(db, table, p0)
                                .routineOccurrencesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'item_id',
                        typedResults: items),
                  if (routineScheduleOverridesRefs)
                    await $_getPrefetchedDataByColumns<
                            RoutineItem,
                            $RoutineItemsTable,
                            RoutineScheduleOverride,
                            $RoutineScheduleOverridesTable>(
                        currentTable: table,
                        referencedTable: $$RoutineItemsTableReferences
                            ._routineScheduleOverridesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutineItemsTableReferences(db, table, p0)
                                .routineScheduleOverridesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'item_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoutineItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineItemsTable,
    RoutineItem,
    $$RoutineItemsTableFilterComposer,
    $$RoutineItemsTableOrderingComposer,
    $$RoutineItemsTableAnnotationComposer,
    $$RoutineItemsTableCreateCompanionBuilder,
    $$RoutineItemsTableUpdateCompanionBuilder,
    (RoutineItem, $$RoutineItemsTableReferences),
    RoutineItem,
    PrefetchHooks Function(
        {bool routineSchedulesRefs,
        bool routineOccurrencesRefs,
        bool routineScheduleOverridesRefs})>;
typedef $$RoutineSchedulesTableCreateCompanionBuilder
    = RoutineSchedulesCompanion Function({
  required String id,
  required String itemId,
  required String kind,
  Value<int> weekdaysMask,
  Value<DateTime?> oneTimeDate,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});
typedef $$RoutineSchedulesTableUpdateCompanionBuilder
    = RoutineSchedulesCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<String> kind,
  Value<int> weekdaysMask,
  Value<DateTime?> oneTimeDate,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});

final class $$RoutineSchedulesTableReferences extends BaseReferences<
    _$AppDatabase, $RoutineSchedulesTable, RoutineSchedule> {
  $$RoutineSchedulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RoutineItemsTable _itemIdTable(_$AppDatabase db) => db.routineItems
      .createAlias('routine_schedules__item_id__routine_items__id');

  $$RoutineItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$RoutineItemsTableTableManager($_db, $_db.routineItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RoutineTimeSlotsTable, List<RoutineTimeSlot>>
      _routineTimeSlotsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.routineTimeSlots,
              aliasName:
                  'routine_schedules__id__routine_time_slots__schedule_id');

  $$RoutineTimeSlotsTableProcessedTableManager get routineTimeSlotsRefs {
    final manager = $$RoutineTimeSlotsTableTableManager(
            $_db, $_db.routineTimeSlots)
        .filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_routineTimeSlotsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoutineSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineSchedulesTable> {
  $$RoutineSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekdaysMask => $composableBuilder(
      column: $table.weekdaysMask, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get oneTimeDate => $composableBuilder(
      column: $table.oneTimeDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  $$RoutineItemsTableFilterComposer get itemId {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableFilterComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> routineTimeSlotsRefs(
      Expression<bool> Function($$RoutineTimeSlotsTableFilterComposer f) f) {
    final $$RoutineTimeSlotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineTimeSlots,
        getReferencedColumn: (t) => t.scheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineTimeSlotsTableFilterComposer(
              $db: $db,
              $table: $db.routineTimeSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutineSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineSchedulesTable> {
  $$RoutineSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekdaysMask => $composableBuilder(
      column: $table.weekdaysMask,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get oneTimeDate => $composableBuilder(
      column: $table.oneTimeDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  $$RoutineItemsTableOrderingComposer get itemId {
    final $$RoutineItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableOrderingComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineSchedulesTable> {
  $$RoutineSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get weekdaysMask => $composableBuilder(
      column: $table.weekdaysMask, builder: (column) => column);

  GeneratedColumn<DateTime> get oneTimeDate => $composableBuilder(
      column: $table.oneTimeDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  $$RoutineItemsTableAnnotationComposer get itemId {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> routineTimeSlotsRefs<T extends Object>(
      Expression<T> Function($$RoutineTimeSlotsTableAnnotationComposer a) f) {
    final $$RoutineTimeSlotsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineTimeSlots,
        getReferencedColumn: (t) => t.scheduleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineTimeSlotsTableAnnotationComposer(
              $db: $db,
              $table: $db.routineTimeSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutineSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineSchedulesTable,
    RoutineSchedule,
    $$RoutineSchedulesTableFilterComposer,
    $$RoutineSchedulesTableOrderingComposer,
    $$RoutineSchedulesTableAnnotationComposer,
    $$RoutineSchedulesTableCreateCompanionBuilder,
    $$RoutineSchedulesTableUpdateCompanionBuilder,
    (RoutineSchedule, $$RoutineSchedulesTableReferences),
    RoutineSchedule,
    PrefetchHooks Function({bool itemId, bool routineTimeSlotsRefs})> {
  $$RoutineSchedulesTableTableManager(
      _$AppDatabase db, $RoutineSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<int> weekdaysMask = const Value.absent(),
            Value<DateTime?> oneTimeDate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineSchedulesCompanion(
            id: id,
            itemId: itemId,
            kind: kind,
            weekdaysMask: weekdaysMask,
            oneTimeDate: oneTimeDate,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String itemId,
            required String kind,
            Value<int> weekdaysMask = const Value.absent(),
            Value<DateTime?> oneTimeDate = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineSchedulesCompanion.insert(
            id: id,
            itemId: itemId,
            kind: kind,
            weekdaysMask: weekdaysMask,
            oneTimeDate: oneTimeDate,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineSchedulesTable, RoutineSchedule>(table),
                    $$RoutineSchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {itemId = false, routineTimeSlotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineTimeSlotsRefs) db.routineTimeSlots
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$RoutineSchedulesTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$RoutineSchedulesTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineTimeSlotsRefs)
                    await $_getPrefetchedDataByColumns<
                            RoutineSchedule,
                            $RoutineSchedulesTable,
                            RoutineTimeSlot,
                            $RoutineTimeSlotsTable>(
                        currentTable: table,
                        referencedTable: $$RoutineSchedulesTableReferences
                            ._routineTimeSlotsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutineSchedulesTableReferences(db, table, p0)
                                .routineTimeSlotsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'schedule_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoutineSchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineSchedulesTable,
    RoutineSchedule,
    $$RoutineSchedulesTableFilterComposer,
    $$RoutineSchedulesTableOrderingComposer,
    $$RoutineSchedulesTableAnnotationComposer,
    $$RoutineSchedulesTableCreateCompanionBuilder,
    $$RoutineSchedulesTableUpdateCompanionBuilder,
    (RoutineSchedule, $$RoutineSchedulesTableReferences),
    RoutineSchedule,
    PrefetchHooks Function({bool itemId, bool routineTimeSlotsRefs})>;
typedef $$RoutineTimeSlotsTableCreateCompanionBuilder
    = RoutineTimeSlotsCompanion Function({
  Value<int> id,
  required String scheduleId,
  required int hour,
  required int minute,
  Value<int> reminderMinutesBefore,
});
typedef $$RoutineTimeSlotsTableUpdateCompanionBuilder
    = RoutineTimeSlotsCompanion Function({
  Value<int> id,
  Value<String> scheduleId,
  Value<int> hour,
  Value<int> minute,
  Value<int> reminderMinutesBefore,
});

final class $$RoutineTimeSlotsTableReferences extends BaseReferences<
    _$AppDatabase, $RoutineTimeSlotsTable, RoutineTimeSlot> {
  $$RoutineTimeSlotsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RoutineSchedulesTable _scheduleIdTable(_$AppDatabase db) => db
      .routineSchedules
      .createAlias('routine_time_slots__schedule_id__routine_schedules__id');

  $$RoutineSchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<String>('schedule_id')!;

    final manager =
        $$RoutineSchedulesTableTableManager($_db, $_db.routineSchedules)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutineTimeSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineTimeSlotsTable> {
  $$RoutineTimeSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderMinutesBefore => $composableBuilder(
      column: $table.reminderMinutesBefore,
      builder: (column) => ColumnFilters(column));

  $$RoutineSchedulesTableFilterComposer get scheduleId {
    final $$RoutineSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.routineSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.routineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineTimeSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineTimeSlotsTable> {
  $$RoutineTimeSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderMinutesBefore => $composableBuilder(
      column: $table.reminderMinutesBefore,
      builder: (column) => ColumnOrderings(column));

  $$RoutineSchedulesTableOrderingComposer get scheduleId {
    final $$RoutineSchedulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.routineSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineSchedulesTableOrderingComposer(
              $db: $db,
              $table: $db.routineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineTimeSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineTimeSlotsTable> {
  $$RoutineTimeSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<int> get reminderMinutesBefore => $composableBuilder(
      column: $table.reminderMinutesBefore, builder: (column) => column);

  $$RoutineSchedulesTableAnnotationComposer get scheduleId {
    final $$RoutineSchedulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scheduleId,
        referencedTable: $db.routineSchedules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineSchedulesTableAnnotationComposer(
              $db: $db,
              $table: $db.routineSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineTimeSlotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineTimeSlotsTable,
    RoutineTimeSlot,
    $$RoutineTimeSlotsTableFilterComposer,
    $$RoutineTimeSlotsTableOrderingComposer,
    $$RoutineTimeSlotsTableAnnotationComposer,
    $$RoutineTimeSlotsTableCreateCompanionBuilder,
    $$RoutineTimeSlotsTableUpdateCompanionBuilder,
    (RoutineTimeSlot, $$RoutineTimeSlotsTableReferences),
    RoutineTimeSlot,
    PrefetchHooks Function({bool scheduleId})> {
  $$RoutineTimeSlotsTableTableManager(
      _$AppDatabase db, $RoutineTimeSlotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineTimeSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineTimeSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineTimeSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> scheduleId = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> minute = const Value.absent(),
            Value<int> reminderMinutesBefore = const Value.absent(),
          }) =>
              RoutineTimeSlotsCompanion(
            id: id,
            scheduleId: scheduleId,
            hour: hour,
            minute: minute,
            reminderMinutesBefore: reminderMinutesBefore,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String scheduleId,
            required int hour,
            required int minute,
            Value<int> reminderMinutesBefore = const Value.absent(),
          }) =>
              RoutineTimeSlotsCompanion.insert(
            id: id,
            scheduleId: scheduleId,
            hour: hour,
            minute: minute,
            reminderMinutesBefore: reminderMinutesBefore,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineTimeSlotsTable, RoutineTimeSlot>(table),
                    $$RoutineTimeSlotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (scheduleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scheduleId,
                    referencedTable:
                        $$RoutineTimeSlotsTableReferences._scheduleIdTable(db),
                    referencedColumn: $$RoutineTimeSlotsTableReferences
                        ._scheduleIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoutineTimeSlotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineTimeSlotsTable,
    RoutineTimeSlot,
    $$RoutineTimeSlotsTableFilterComposer,
    $$RoutineTimeSlotsTableOrderingComposer,
    $$RoutineTimeSlotsTableAnnotationComposer,
    $$RoutineTimeSlotsTableCreateCompanionBuilder,
    $$RoutineTimeSlotsTableUpdateCompanionBuilder,
    (RoutineTimeSlot, $$RoutineTimeSlotsTableReferences),
    RoutineTimeSlot,
    PrefetchHooks Function({bool scheduleId})>;
typedef $$RoutineOccurrencesTableCreateCompanionBuilder
    = RoutineOccurrencesCompanion Function({
  required String id,
  required String itemId,
  required DateTime scheduledAt,
  required String status,
  Value<DateTime?> recordedAt,
  Value<int> rowid,
});
typedef $$RoutineOccurrencesTableUpdateCompanionBuilder
    = RoutineOccurrencesCompanion Function({
  Value<String> id,
  Value<String> itemId,
  Value<DateTime> scheduledAt,
  Value<String> status,
  Value<DateTime?> recordedAt,
  Value<int> rowid,
});

final class $$RoutineOccurrencesTableReferences extends BaseReferences<
    _$AppDatabase, $RoutineOccurrencesTable, RoutineOccurrence> {
  $$RoutineOccurrencesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RoutineItemsTable _itemIdTable(_$AppDatabase db) => db.routineItems
      .createAlias('routine_occurrences__item_id__routine_items__id');

  $$RoutineItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$RoutineItemsTableTableManager($_db, $_db.routineItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutineOccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineOccurrencesTable> {
  $$RoutineOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  $$RoutineItemsTableFilterComposer get itemId {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableFilterComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineOccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineOccurrencesTable> {
  $$RoutineOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  $$RoutineItemsTableOrderingComposer get itemId {
    final $$RoutineItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableOrderingComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineOccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineOccurrencesTable> {
  $$RoutineOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  $$RoutineItemsTableAnnotationComposer get itemId {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineOccurrencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineOccurrencesTable,
    RoutineOccurrence,
    $$RoutineOccurrencesTableFilterComposer,
    $$RoutineOccurrencesTableOrderingComposer,
    $$RoutineOccurrencesTableAnnotationComposer,
    $$RoutineOccurrencesTableCreateCompanionBuilder,
    $$RoutineOccurrencesTableUpdateCompanionBuilder,
    (RoutineOccurrence, $$RoutineOccurrencesTableReferences),
    RoutineOccurrence,
    PrefetchHooks Function({bool itemId})> {
  $$RoutineOccurrencesTableTableManager(
      _$AppDatabase db, $RoutineOccurrencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineOccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineOccurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineOccurrencesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> recordedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineOccurrencesCompanion(
            id: id,
            itemId: itemId,
            scheduledAt: scheduledAt,
            status: status,
            recordedAt: recordedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String itemId,
            required DateTime scheduledAt,
            required String status,
            Value<DateTime?> recordedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineOccurrencesCompanion.insert(
            id: id,
            itemId: itemId,
            scheduledAt: scheduledAt,
            status: status,
            recordedAt: recordedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineOccurrencesTable, RoutineOccurrence>(
                        table),
                    $$RoutineOccurrencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$RoutineOccurrencesTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$RoutineOccurrencesTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoutineOccurrencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineOccurrencesTable,
    RoutineOccurrence,
    $$RoutineOccurrencesTableFilterComposer,
    $$RoutineOccurrencesTableOrderingComposer,
    $$RoutineOccurrencesTableAnnotationComposer,
    $$RoutineOccurrencesTableCreateCompanionBuilder,
    $$RoutineOccurrencesTableUpdateCompanionBuilder,
    (RoutineOccurrence, $$RoutineOccurrencesTableReferences),
    RoutineOccurrence,
    PrefetchHooks Function({bool itemId})>;
typedef $$RoutineScheduleOverridesTableCreateCompanionBuilder
    = RoutineScheduleOverridesCompanion Function({
  required String itemId,
  required DateTime date,
  Value<String> timeSlotsJson,
  Value<bool> isCancelled,
  Value<int> rowid,
});
typedef $$RoutineScheduleOverridesTableUpdateCompanionBuilder
    = RoutineScheduleOverridesCompanion Function({
  Value<String> itemId,
  Value<DateTime> date,
  Value<String> timeSlotsJson,
  Value<bool> isCancelled,
  Value<int> rowid,
});

final class $$RoutineScheduleOverridesTableReferences extends BaseReferences<
    _$AppDatabase, $RoutineScheduleOverridesTable, RoutineScheduleOverride> {
  $$RoutineScheduleOverridesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RoutineItemsTable _itemIdTable(_$AppDatabase db) => db.routineItems
      .createAlias('routine_schedule_overrides__item_id__routine_items__id');

  $$RoutineItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = $$RoutineItemsTableTableManager($_db, $_db.routineItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutineScheduleOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineScheduleOverridesTable> {
  $$RoutineScheduleOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeSlotsJson => $composableBuilder(
      column: $table.timeSlotsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCancelled => $composableBuilder(
      column: $table.isCancelled, builder: (column) => ColumnFilters(column));

  $$RoutineItemsTableFilterComposer get itemId {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableFilterComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineScheduleOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineScheduleOverridesTable> {
  $$RoutineScheduleOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeSlotsJson => $composableBuilder(
      column: $table.timeSlotsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCancelled => $composableBuilder(
      column: $table.isCancelled, builder: (column) => ColumnOrderings(column));

  $$RoutineItemsTableOrderingComposer get itemId {
    final $$RoutineItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableOrderingComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineScheduleOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineScheduleOverridesTable> {
  $$RoutineScheduleOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get timeSlotsJson => $composableBuilder(
      column: $table.timeSlotsJson, builder: (column) => column);

  GeneratedColumn<bool> get isCancelled => $composableBuilder(
      column: $table.isCancelled, builder: (column) => column);

  $$RoutineItemsTableAnnotationComposer get itemId {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineScheduleOverridesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineScheduleOverridesTable,
    RoutineScheduleOverride,
    $$RoutineScheduleOverridesTableFilterComposer,
    $$RoutineScheduleOverridesTableOrderingComposer,
    $$RoutineScheduleOverridesTableAnnotationComposer,
    $$RoutineScheduleOverridesTableCreateCompanionBuilder,
    $$RoutineScheduleOverridesTableUpdateCompanionBuilder,
    (RoutineScheduleOverride, $$RoutineScheduleOverridesTableReferences),
    RoutineScheduleOverride,
    PrefetchHooks Function({bool itemId})> {
  $$RoutineScheduleOverridesTableTableManager(
      _$AppDatabase db, $RoutineScheduleOverridesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineScheduleOverridesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineScheduleOverridesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineScheduleOverridesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> timeSlotsJson = const Value.absent(),
            Value<bool> isCancelled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineScheduleOverridesCompanion(
            itemId: itemId,
            date: date,
            timeSlotsJson: timeSlotsJson,
            isCancelled: isCancelled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemId,
            required DateTime date,
            Value<String> timeSlotsJson = const Value.absent(),
            Value<bool> isCancelled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineScheduleOverridesCompanion.insert(
            itemId: itemId,
            date: date,
            timeSlotsJson: timeSlotsJson,
            isCancelled: isCancelled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineScheduleOverridesTable,
                        RoutineScheduleOverride>(table),
                    $$RoutineScheduleOverridesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable: $$RoutineScheduleOverridesTableReferences
                        ._itemIdTable(db),
                    referencedColumn: $$RoutineScheduleOverridesTableReferences
                        ._itemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoutineScheduleOverridesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RoutineScheduleOverridesTable,
        RoutineScheduleOverride,
        $$RoutineScheduleOverridesTableFilterComposer,
        $$RoutineScheduleOverridesTableOrderingComposer,
        $$RoutineScheduleOverridesTableAnnotationComposer,
        $$RoutineScheduleOverridesTableCreateCompanionBuilder,
        $$RoutineScheduleOverridesTableUpdateCompanionBuilder,
        (RoutineScheduleOverride, $$RoutineScheduleOverridesTableReferences),
        RoutineScheduleOverride,
        PrefetchHooks Function({bool itemId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutineItemsTableTableManager get routineItems =>
      $$RoutineItemsTableTableManager(_db, _db.routineItems);
  $$RoutineSchedulesTableTableManager get routineSchedules =>
      $$RoutineSchedulesTableTableManager(_db, _db.routineSchedules);
  $$RoutineTimeSlotsTableTableManager get routineTimeSlots =>
      $$RoutineTimeSlotsTableTableManager(_db, _db.routineTimeSlots);
  $$RoutineOccurrencesTableTableManager get routineOccurrences =>
      $$RoutineOccurrencesTableTableManager(_db, _db.routineOccurrences);
  $$RoutineScheduleOverridesTableTableManager get routineScheduleOverrides =>
      $$RoutineScheduleOverridesTableTableManager(
          _db, _db.routineScheduleOverrides);
}
