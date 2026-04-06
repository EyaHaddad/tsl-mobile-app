import 'package:isar/isar.dart';

import 'package:tsl_mobile_app/core/database/isar_service.dart';
import 'package:tsl_mobile_app/features/history/models/history_record.dart';

// Isar-backed data access layer for history records
class HistoryStorage {
  HistoryStorage(this._isarService);

  final IsarService _isarService;

  Isar get _isar => _isarService.isar;

  // Creates an in-memory record instance
  // 
  // Call [saveRecord] to persist it to the local database
  HistoryRecord createRecord({
    required String recognizedText,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool isFavorite = false,
    String? audioPath,
    double? confidence,
    List<String> alternatives = const [],
  }) {
    return HistoryRecord()
      ..recognizedText = recognizedText
      ..createdAt = createdAt ?? DateTime.now()
      ..expiresAt = expiresAt
      ..isFavorite = isFavorite
      ..audioPath = audioPath
      ..confidence = confidence
      ..alternatives = List<String>.from(alternatives);
  }

  // Inserts or updates a history record
  Future<HistoryRecord> saveRecord(HistoryRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.historyRecords.put(record);
    });
    return record;
  }

  // Returns all records sorted by favorite first, then newest first
  Future<List<HistoryRecord>> getAllRecords() async {
    final records = await _isar.historyRecords.where().findAll();
    records.sort(_compareRecords);
    return records;
  }

  // Returns one record by id or null if it does not exist
  Future<HistoryRecord?> getRecordById(int id) async {
    return _isar.historyRecords.get(id);
  }

  // Deletes a single record by id
  Future<void> deleteRecord(int id) async {
    await _isar.writeTxn(() async {
      await _isar.historyRecords.delete(id);
    });
  }

  // Toggles favorite status, or sets it to [value] when provided
  Future<void> toggleFavorite(int id, {bool? value}) async {
    await _isar.writeTxn(() async {
      final record = await _isar.historyRecords.get(id);
      if (record == null) {
        return;
      }

      record.isFavorite = value ?? !record.isFavorite;
      await _isar.historyRecords.put(record);
    });
  }

  // Deletes all non-favorite records that reached their expiration date
  Future<int> purgeExpiredRecords({DateTime? now}) async {
    final currentTime = now ?? DateTime.now();
    final records = await _isar.historyRecords.where().findAll();
    final expiredIds = records
        .where(
          (record) =>
              !record.isFavorite &&
              record.expiresAt != null &&
              !record.expiresAt!.isAfter(currentTime),
        )
        .map((record) => record.id)
        .toList();

    if (expiredIds.isEmpty) {
      return 0;
    }

    await _isar.writeTxn(() async {
      await _isar.historyRecords.deleteAll(expiredIds);
    });

    return expiredIds.length;
  }

  // Removes all records from local storage
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.historyRecords.clear();
    });
  }

  int _compareRecords(HistoryRecord a, HistoryRecord b) {
    if (a.isFavorite != b.isFavorite) {
      return a.isFavorite ? -1 : 1;
    }

    return b.createdAt.compareTo(a.createdAt);
  }
}
