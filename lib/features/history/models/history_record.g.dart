// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryRecordCollection on Isar {
  IsarCollection<HistoryRecord> get historyRecords => this.collection();
}

const HistoryRecordSchema = CollectionSchema(
  name: r'HistoryRecord',
  id: -4305771715677521449,
  properties: {
    r'alternatives': PropertySchema(
      id: 0,
      name: r'alternatives',
      type: IsarType.stringList,
    ),
    r'audioPath': PropertySchema(
      id: 1,
      name: r'audioPath',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 2,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'expiresAt': PropertySchema(
      id: 4,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'isFavorite': PropertySchema(
      id: 5,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'recognizedText': PropertySchema(
      id: 6,
      name: r'recognizedText',
      type: IsarType.string,
    )
  },
  estimateSize: _historyRecordEstimateSize,
  serialize: _historyRecordSerialize,
  deserialize: _historyRecordDeserialize,
  deserializeProp: _historyRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'expiresAt': IndexSchema(
      id: 4994901953235663716,
      name: r'expiresAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'expiresAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _historyRecordGetId,
  getLinks: _historyRecordGetLinks,
  attach: _historyRecordAttach,
  version: '3.1.0+1',
);

int _historyRecordEstimateSize(
  HistoryRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.alternatives.length * 3;
  {
    for (var i = 0; i < object.alternatives.length; i++) {
      final value = object.alternatives[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.audioPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.recognizedText.length * 3;
  return bytesCount;
}

void _historyRecordSerialize(
  HistoryRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.alternatives);
  writer.writeString(offsets[1], object.audioPath);
  writer.writeDouble(offsets[2], object.confidence);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeDateTime(offsets[4], object.expiresAt);
  writer.writeBool(offsets[5], object.isFavorite);
  writer.writeString(offsets[6], object.recognizedText);
}

HistoryRecord _historyRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryRecord();
  object.alternatives = reader.readStringList(offsets[0]) ?? [];
  object.audioPath = reader.readStringOrNull(offsets[1]);
  object.confidence = reader.readDoubleOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.expiresAt = reader.readDateTimeOrNull(offsets[4]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[5]);
  object.recognizedText = reader.readString(offsets[6]);
  return object;
}

P _historyRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _historyRecordGetId(HistoryRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _historyRecordGetLinks(HistoryRecord object) {
  return [];
}

void _historyRecordAttach(
    IsarCollection<dynamic> col, Id id, HistoryRecord object) {
  object.id = id;
}

extension HistoryRecordQueryWhereSort
    on QueryBuilder<HistoryRecord, HistoryRecord, QWhere> {
  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhere> anyExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expiresAt'),
      );
    });
  }
}

extension HistoryRecordQueryWhere
    on QueryBuilder<HistoryRecord, HistoryRecord, QWhereClause> {
  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiresAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtEqualTo(DateTime? expiresAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expiresAt',
        value: [expiresAt],
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtNotEqualTo(DateTime? expiresAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [],
              upper: [expiresAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [expiresAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [expiresAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expiresAt',
              lower: [],
              upper: [expiresAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtGreaterThan(
    DateTime? expiresAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [expiresAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtLessThan(
    DateTime? expiresAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [],
        upper: [expiresAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterWhereClause>
      expiresAtBetween(
    DateTime? lowerExpiresAt,
    DateTime? upperExpiresAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expiresAt',
        lower: [lowerExpiresAt],
        includeLower: includeLower,
        upper: [upperExpiresAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HistoryRecordQueryFilter
    on QueryBuilder<HistoryRecord, HistoryRecord, QFilterCondition> {
  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alternatives',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alternatives',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alternatives',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alternatives',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alternatives',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alternatives',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alternatives',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alternatives',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alternatives',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alternatives',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alternatives',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alternatives',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alternatives',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alternatives',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alternatives',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      alternativesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alternatives',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioPath',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioPath',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      audioPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      confidenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confidence',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      confidenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confidence',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      confidenceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      confidenceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      confidenceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      confidenceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      expiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      expiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      expiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      expiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recognizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recognizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recognizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recognizedText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recognizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recognizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recognizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recognizedText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recognizedText',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterFilterCondition>
      recognizedTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recognizedText',
        value: '',
      ));
    });
  }
}

extension HistoryRecordQueryObject
    on QueryBuilder<HistoryRecord, HistoryRecord, QFilterCondition> {}

extension HistoryRecordQueryLinks
    on QueryBuilder<HistoryRecord, HistoryRecord, QFilterCondition> {}

extension HistoryRecordQuerySortBy
    on QueryBuilder<HistoryRecord, HistoryRecord, QSortBy> {
  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> sortByAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByRecognizedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recognizedText', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      sortByRecognizedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recognizedText', Sort.desc);
    });
  }
}

extension HistoryRecordQuerySortThenBy
    on QueryBuilder<HistoryRecord, HistoryRecord, QSortThenBy> {
  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenByAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByRecognizedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recognizedText', Sort.asc);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QAfterSortBy>
      thenByRecognizedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recognizedText', Sort.desc);
    });
  }
}

extension HistoryRecordQueryWhereDistinct
    on QueryBuilder<HistoryRecord, HistoryRecord, QDistinct> {
  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct>
      distinctByAlternatives() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alternatives');
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct> distinctByAudioPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct> distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<HistoryRecord, HistoryRecord, QDistinct>
      distinctByRecognizedText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recognizedText',
          caseSensitive: caseSensitive);
    });
  }
}

extension HistoryRecordQueryProperty
    on QueryBuilder<HistoryRecord, HistoryRecord, QQueryProperty> {
  QueryBuilder<HistoryRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HistoryRecord, List<String>, QQueryOperations>
      alternativesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alternatives');
    });
  }

  QueryBuilder<HistoryRecord, String?, QQueryOperations> audioPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioPath');
    });
  }

  QueryBuilder<HistoryRecord, double?, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<HistoryRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HistoryRecord, DateTime?, QQueryOperations> expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<HistoryRecord, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<HistoryRecord, String, QQueryOperations>
      recognizedTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recognizedText');
    });
  }
}
