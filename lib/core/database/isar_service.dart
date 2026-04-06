import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tsl_mobile_app/features/history/models/history_record.dart';

class IsarService {
  IsarService._();

  static final IsarService instance = IsarService._();

  Isar? _isar;

  bool get isInitialized => _isar != null;

  Isar get isar {
    final database = _isar;
    if (database == null) {
      throw StateError('Isar has not been initialized yet.');
    }
    return database;
  }

  Future<Isar> init() async {
    final existing = _isar;
    if (existing != null) {
      return existing;
    }

    final directory = await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [HistoryRecordSchema],
      directory: directory.path,
      inspector: kDebugMode,
    );

    return _isar!;
  }

  Future<void> close() async {
    final database = _isar;
    _isar = null;
    await database?.close();
  }
}
