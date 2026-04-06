import 'package:tsl_mobile_app/core/database/isar_service.dart';
import 'package:tsl_mobile_app/features/history/services/history_storage.dart';
import 'package:tsl_mobile_app/features/settings/services/settings_service.dart';

// Applies history retention settings and removes expired non-favorite records
class HistoryRetentionService {
  HistoryRetentionService(this._historyStorage, this._settingsService);

  final HistoryStorage _historyStorage;
  final SettingsService _settingsService;

  // Creates a ready-to-use service with local settings and Isar storage
  static Future<HistoryRetentionService> create() async {
    final settingsService = await SettingsService.create();
    final historyStorage = HistoryStorage(IsarService.instance);
    return HistoryRetentionService(historyStorage, settingsService);
  }

  // Deletes expired records only when auto-delete is enabled
  Future<int> purgeExpiredIfEnabled({DateTime? now}) async {
    final settings = _settingsService.getSettings();
    if (!settings.autoDeleteEnabled) {
      return 0;
    }

    return _historyStorage.purgeExpiredRecords(now: now);
  }
}
