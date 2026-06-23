// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserConfigCollection on Isar {
  IsarCollection<UserConfig> get userConfigs => this.collection();
}

const UserConfigSchema = CollectionSchema(
  name: r'UserConfig',
  id: 1844971189088430043,
  properties: {
    r'categoryLimitKeys': PropertySchema(
      id: 0,
      name: r'categoryLimitKeys',
      type: IsarType.stringList,
    ),
    r'categoryLimitValues': PropertySchema(
      id: 1,
      name: r'categoryLimitValues',
      type: IsarType.doubleList,
    ),
    r'globalMonthlyBudget': PropertySchema(
      id: 2,
      name: r'globalMonthlyBudget',
      type: IsarType.double,
    ),
    r'hashedPin': PropertySchema(
      id: 3,
      name: r'hashedPin',
      type: IsarType.string,
    ),
    r'isSetupComplete': PropertySchema(
      id: 4,
      name: r'isSetupComplete',
      type: IsarType.bool,
    )
  },
  estimateSize: _userConfigEstimateSize,
  serialize: _userConfigSerialize,
  deserialize: _userConfigDeserialize,
  deserializeProp: _userConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userConfigGetId,
  getLinks: _userConfigGetLinks,
  attach: _userConfigAttach,
  version: '3.1.0+1',
);

int _userConfigEstimateSize(
  UserConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.categoryLimitKeys;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.categoryLimitValues;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  bytesCount += 3 + object.hashedPin.length * 3;
  return bytesCount;
}

void _userConfigSerialize(
  UserConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.categoryLimitKeys);
  writer.writeDoubleList(offsets[1], object.categoryLimitValues);
  writer.writeDouble(offsets[2], object.globalMonthlyBudget);
  writer.writeString(offsets[3], object.hashedPin);
  writer.writeBool(offsets[4], object.isSetupComplete);
}

UserConfig _userConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserConfig();
  object.categoryLimitKeys = reader.readStringList(offsets[0]);
  object.categoryLimitValues = reader.readDoubleList(offsets[1]);
  object.globalMonthlyBudget = reader.readDoubleOrNull(offsets[2]);
  object.hashedPin = reader.readString(offsets[3]);
  object.id = id;
  object.isSetupComplete = reader.readBool(offsets[4]);
  return object;
}

P _userConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readDoubleList(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userConfigGetId(UserConfig object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _userConfigGetLinks(UserConfig object) {
  return [];
}

void _userConfigAttach(IsarCollection<dynamic> col, Id id, UserConfig object) {
  object.id = id;
}

extension UserConfigQueryWhereSort
    on QueryBuilder<UserConfig, UserConfig, QWhere> {
  QueryBuilder<UserConfig, UserConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserConfigQueryWhere
    on QueryBuilder<UserConfig, UserConfig, QWhereClause> {
  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserConfigQueryFilter
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {
  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryLimitKeys',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryLimitKeys',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryLimitKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryLimitKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryLimitKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryLimitKeys',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryLimitKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryLimitKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryLimitKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryLimitKeys',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryLimitKeys',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryLimitKeys',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitKeys',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitKeys',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitKeys',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitKeys',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitKeys',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitKeysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitKeys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryLimitValues',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryLimitValues',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryLimitValues',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryLimitValues',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryLimitValues',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryLimitValues',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitValues',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitValues',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitValues',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitValues',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitValues',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      categoryLimitValuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryLimitValues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      globalMonthlyBudgetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'globalMonthlyBudget',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      globalMonthlyBudgetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'globalMonthlyBudget',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      globalMonthlyBudgetEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'globalMonthlyBudget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      globalMonthlyBudgetGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'globalMonthlyBudget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      globalMonthlyBudgetLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'globalMonthlyBudget',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      globalMonthlyBudgetBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'globalMonthlyBudget',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> hashedPinEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashedPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      hashedPinGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashedPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> hashedPinLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashedPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> hashedPinBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashedPin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      hashedPinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hashedPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> hashedPinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hashedPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> hashedPinContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hashedPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> hashedPinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hashedPin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      hashedPinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashedPin',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      hashedPinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hashedPin',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      isSetupCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSetupComplete',
        value: value,
      ));
    });
  }
}

extension UserConfigQueryObject
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {}

extension UserConfigQueryLinks
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {}

extension UserConfigQuerySortBy
    on QueryBuilder<UserConfig, UserConfig, QSortBy> {
  QueryBuilder<UserConfig, UserConfig, QAfterSortBy>
      sortByGlobalMonthlyBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalMonthlyBudget', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy>
      sortByGlobalMonthlyBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalMonthlyBudget', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByHashedPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashedPin', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByHashedPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashedPin', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByIsSetupComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSetupComplete', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy>
      sortByIsSetupCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSetupComplete', Sort.desc);
    });
  }
}

extension UserConfigQuerySortThenBy
    on QueryBuilder<UserConfig, UserConfig, QSortThenBy> {
  QueryBuilder<UserConfig, UserConfig, QAfterSortBy>
      thenByGlobalMonthlyBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalMonthlyBudget', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy>
      thenByGlobalMonthlyBudgetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'globalMonthlyBudget', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByHashedPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashedPin', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByHashedPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashedPin', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByIsSetupComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSetupComplete', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy>
      thenByIsSetupCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSetupComplete', Sort.desc);
    });
  }
}

extension UserConfigQueryWhereDistinct
    on QueryBuilder<UserConfig, UserConfig, QDistinct> {
  QueryBuilder<UserConfig, UserConfig, QDistinct>
      distinctByCategoryLimitKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryLimitKeys');
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct>
      distinctByCategoryLimitValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryLimitValues');
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct>
      distinctByGlobalMonthlyBudget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'globalMonthlyBudget');
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByHashedPin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashedPin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByIsSetupComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSetupComplete');
    });
  }
}

extension UserConfigQueryProperty
    on QueryBuilder<UserConfig, UserConfig, QQueryProperty> {
  QueryBuilder<UserConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserConfig, List<String>?, QQueryOperations>
      categoryLimitKeysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryLimitKeys');
    });
  }

  QueryBuilder<UserConfig, List<double>?, QQueryOperations>
      categoryLimitValuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryLimitValues');
    });
  }

  QueryBuilder<UserConfig, double?, QQueryOperations>
      globalMonthlyBudgetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'globalMonthlyBudget');
    });
  }

  QueryBuilder<UserConfig, String, QQueryOperations> hashedPinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashedPin');
    });
  }

  QueryBuilder<UserConfig, bool, QQueryOperations> isSetupCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSetupComplete');
    });
  }
}
