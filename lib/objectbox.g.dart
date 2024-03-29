// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'dbModels/accountEntry.dart';
import 'dbModels/categoryEntry.dart';
import 'dbModels/spending_entry_model.dart';
import 'dbModels/subscriptionEntry.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 8560210450077052426),
      name: 'SpendingEntry',
      lastPropertyId: const IdUid(13, 5435925545126985859),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7195425436018089589),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 9070935246921026076),
            name: 'caption',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 909106519423985789),
            name: 'value',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6493336795288176181),
            name: 'dateTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 1459171979900264546),
            name: 'tagId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 491636686344489777),
            name: 'itemType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 5087545426494177644),
            name: 'accId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 2695665378395874140),
            name: 'recAccId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 4336210243650426089),
            name: 'excludeFromSpending',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 5435925545126985859),
            name: 'excludeFromIncome',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(2, 4628037891868379992),
      name: 'AccountEntry',
      lastPropertyId: const IdUid(12, 4146724335968185070),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4548300855998218223),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 862177462193124388),
            name: 'caption',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5877470395505109673),
            name: 'show',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(3, 6876147056865672656),
      name: 'CategoryEntry',
      lastPropertyId: const IdUid(5, 7028775727629461499),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7398582131714520346),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7498253641532519877),
            name: 'caption',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3574373731886766926),
            name: 'iconId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 1057013297611123348),
            name: 'show',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7028775727629461499),
            name: 'basic',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 339781400904698153),
      name: 'SubscriptionEntry',
      lastPropertyId: const IdUid(12, 7092018692399597984),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8889103460676735390),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7483632844973367605),
            name: 'accId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3804804196151179403),
            name: 'amount',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 4334730256663215889),
            name: 'tagId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7746341186528567602),
            name: 'caption',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 6195353886424052043),
            name: 'show',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7523886048058297245),
            name: 'enabled',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 6142704881520708855),
            name: 'repeatType',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 6233568357190563081),
            name: 'renewMonth',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 8424235496591900317),
            name: 'repeatNum',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 1639184482840924624),
            name: 'endDate',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 7092018692399597984),
            name: 'startDate',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(4, 339781400904698153),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        5060431788235565225,
        5741241459831399899,
        8425197643574923808,
        5907243860043474919,
        4137086924124134754,
        7432248733667643728,
        15194870399924056,
        6089891455904726489,
        5003231796258913563,
        8733589571265371023,
        3537792083452359201,
        4146724335968185070
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    SpendingEntry: EntityDefinition<SpendingEntry>(
        model: _entities[0],
        toOneRelations: (SpendingEntry object) => [],
        toManyRelations: (SpendingEntry object) => {},
        getId: (SpendingEntry object) => object.id,
        setId: (SpendingEntry object, int id) {
          object.id = id;
        },
        objectToFB: (SpendingEntry object, fb.Builder fbb) {
          final captionOffset = fbb.writeString(object.caption);
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, captionOffset);
          fbb.addFloat64(2, object.value);
          fbb.addInt64(3, object.dateTime);
          fbb.addInt64(6, object.tagId);
          fbb.addInt64(7, object.itemType);
          fbb.addInt64(8, object.accId);
          fbb.addInt64(9, object.recAccId);
          fbb.addBool(11, object.excludeFromSpending);
          fbb.addBool(12, object.excludeFromIncome);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SpendingEntry()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..caption = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..value =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0)
            ..dateTime =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)
            ..tagId =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0)
            ..itemType =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0)
            ..accId =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0)
            ..recAccId =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0)
            ..excludeFromSpending =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 26, false)
            ..excludeFromIncome =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 28, false);

          return object;
        }),
    AccountEntry: EntityDefinition<AccountEntry>(
        model: _entities[1],
        toOneRelations: (AccountEntry object) => [],
        toManyRelations: (AccountEntry object) => {},
        getId: (AccountEntry object) => object.id,
        setId: (AccountEntry object, int id) {
          object.id = id;
        },
        objectToFB: (AccountEntry object, fb.Builder fbb) {
          final captionOffset = fbb.writeString(object.caption);
          fbb.startTable(13);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, captionOffset);
          fbb.addBool(2, object.show);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AccountEntry(
              caption: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..show =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 8, false);

          return object;
        }),
    CategoryEntry: EntityDefinition<CategoryEntry>(
        model: _entities[2],
        toOneRelations: (CategoryEntry object) => [],
        toManyRelations: (CategoryEntry object) => {},
        getId: (CategoryEntry object) => object.id,
        setId: (CategoryEntry object, int id) {
          object.id = id;
        },
        objectToFB: (CategoryEntry object, fb.Builder fbb) {
          final captionOffset = fbb.writeString(object.caption);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, captionOffset);
          fbb.addInt64(2, object.iconId);
          fbb.addBool(3, object.show);
          fbb.addBool(4, object.basic);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = CategoryEntry(
              caption: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              iconId:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0),
              basic: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 12, false))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..show =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 10, false);

          return object;
        }),
    SubscriptionEntry: EntityDefinition<SubscriptionEntry>(
        model: _entities[3],
        toOneRelations: (SubscriptionEntry object) => [],
        toManyRelations: (SubscriptionEntry object) => {},
        getId: (SubscriptionEntry object) => object.id,
        setId: (SubscriptionEntry object, int id) {
          object.id = id;
        },
        objectToFB: (SubscriptionEntry object, fb.Builder fbb) {
          final captionOffset = fbb.writeString(object.caption);
          fbb.startTable(13);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.accId);
          fbb.addFloat64(2, object.amount);
          fbb.addInt64(3, object.tagId);
          fbb.addOffset(4, captionOffset);
          fbb.addBool(5, object.show);
          fbb.addBool(6, object.enabled);
          fbb.addInt64(7, object.repeatType);
          fbb.addInt64(8, object.renewMonth);
          fbb.addInt64(9, object.repeatNum);
          fbb.addInt64(10, object.endDate);
          fbb.addInt64(11, object.startDate);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SubscriptionEntry(
              caption: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, ''))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..accId = const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0)
            ..amount =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0)
            ..tagId =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)
            ..show =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false)
            ..enabled =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 16, false)
            ..repeatType =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 18, 0)
            ..renewMonth =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0)
            ..repeatNum =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0)
            ..endDate =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 24, 0)
            ..startDate =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 26, 0);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [SpendingEntry] entity fields to define ObjectBox queries.
class SpendingEntry_ {
  /// see [SpendingEntry.id]
  static final id =
      QueryIntegerProperty<SpendingEntry>(_entities[0].properties[0]);

  /// see [SpendingEntry.caption]
  static final caption =
      QueryStringProperty<SpendingEntry>(_entities[0].properties[1]);

  /// see [SpendingEntry.value]
  static final value =
      QueryDoubleProperty<SpendingEntry>(_entities[0].properties[2]);

  /// see [SpendingEntry.dateTime]
  static final dateTime =
      QueryIntegerProperty<SpendingEntry>(_entities[0].properties[3]);

  /// see [SpendingEntry.tagId]
  static final tagId =
      QueryIntegerProperty<SpendingEntry>(_entities[0].properties[4]);

  /// see [SpendingEntry.itemType]
  static final itemType =
      QueryIntegerProperty<SpendingEntry>(_entities[0].properties[5]);

  /// see [SpendingEntry.accId]
  static final accId =
      QueryIntegerProperty<SpendingEntry>(_entities[0].properties[6]);

  /// see [SpendingEntry.recAccId]
  static final recAccId =
      QueryIntegerProperty<SpendingEntry>(_entities[0].properties[7]);

  /// see [SpendingEntry.excludeFromSpending]
  static final excludeFromSpending =
      QueryBooleanProperty<SpendingEntry>(_entities[0].properties[8]);

  /// see [SpendingEntry.excludeFromIncome]
  static final excludeFromIncome =
      QueryBooleanProperty<SpendingEntry>(_entities[0].properties[9]);
}

/// [AccountEntry] entity fields to define ObjectBox queries.
class AccountEntry_ {
  /// see [AccountEntry.id]
  static final id =
      QueryIntegerProperty<AccountEntry>(_entities[1].properties[0]);

  /// see [AccountEntry.caption]
  static final caption =
      QueryStringProperty<AccountEntry>(_entities[1].properties[1]);

  /// see [AccountEntry.show]
  static final show =
      QueryBooleanProperty<AccountEntry>(_entities[1].properties[2]);
}

/// [CategoryEntry] entity fields to define ObjectBox queries.
class CategoryEntry_ {
  /// see [CategoryEntry.id]
  static final id =
      QueryIntegerProperty<CategoryEntry>(_entities[2].properties[0]);

  /// see [CategoryEntry.caption]
  static final caption =
      QueryStringProperty<CategoryEntry>(_entities[2].properties[1]);

  /// see [CategoryEntry.iconId]
  static final iconId =
      QueryIntegerProperty<CategoryEntry>(_entities[2].properties[2]);

  /// see [CategoryEntry.show]
  static final show =
      QueryBooleanProperty<CategoryEntry>(_entities[2].properties[3]);

  /// see [CategoryEntry.basic]
  static final basic =
      QueryBooleanProperty<CategoryEntry>(_entities[2].properties[4]);
}

/// [SubscriptionEntry] entity fields to define ObjectBox queries.
class SubscriptionEntry_ {
  /// see [SubscriptionEntry.id]
  static final id =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[0]);

  /// see [SubscriptionEntry.accId]
  static final accId =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[1]);

  /// see [SubscriptionEntry.amount]
  static final amount =
      QueryDoubleProperty<SubscriptionEntry>(_entities[3].properties[2]);

  /// see [SubscriptionEntry.tagId]
  static final tagId =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[3]);

  /// see [SubscriptionEntry.caption]
  static final caption =
      QueryStringProperty<SubscriptionEntry>(_entities[3].properties[4]);

  /// see [SubscriptionEntry.show]
  static final show =
      QueryBooleanProperty<SubscriptionEntry>(_entities[3].properties[5]);

  /// see [SubscriptionEntry.enabled]
  static final enabled =
      QueryBooleanProperty<SubscriptionEntry>(_entities[3].properties[6]);

  /// see [SubscriptionEntry.repeatType]
  static final repeatType =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[7]);

  /// see [SubscriptionEntry.renewMonth]
  static final renewMonth =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[8]);

  /// see [SubscriptionEntry.repeatNum]
  static final repeatNum =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[9]);

  /// see [SubscriptionEntry.endDate]
  static final endDate =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[10]);

  /// see [SubscriptionEntry.startDate]
  static final startDate =
      QueryIntegerProperty<SubscriptionEntry>(_entities[3].properties[11]);
}
