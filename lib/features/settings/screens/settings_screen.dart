import 'package:flutter/material.dart';
import 'package:tsl_mobile_app/core/database/isar_service.dart';
import 'package:tsl_mobile_app/core/services/history_retention_service.dart';
import 'package:tsl_mobile_app/features/history/services/history_storage.dart';
import 'package:tsl_mobile_app/features/settings/services/settings_service.dart';

// Storage settings screen with persistent preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Map<String, int> _durationDaysMap = {
    'أسبوع واحد': 7,
    'أسبوعان': 14,
    'شهر واحد': 30,
    'ثلاثة أشهر': 90,
    'ستة أشهر': 180,
    'سنة كاملة': 365,
    'للأبد': 0,
  };

  String _selectedDuration = 'أسبوع واحد';
  bool _autoDelete = false;
  bool _persistAudioFiles = false;
  bool _isLoading = true;

  SettingsService? _settingsService;

  final List<String> _durations = [
    'أسبوع واحد',
    'أسبوعان',
    'شهر واحد',
    'ثلاثة أشهر',
    'ستة أشهر',
    'سنة كاملة',
    'للأبد',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final service = await SettingsService.create();
    final settings = service.getSettings();
    if (!mounted) return;

    setState(() {
      _settingsService = service;
      _autoDelete = settings.autoDeleteEnabled;
      _persistAudioFiles = settings.persistAudioFiles;
      _selectedDuration = _durationFromDays(settings.retentionDays);
      _isLoading = false;
    });
  }

  String _durationFromDays(int days) {
    for (final entry in _durationDaysMap.entries) {
      if (entry.value == days) {
        return entry.key;
      }
    }
    return 'أسبوع واحد';
  }

  Future<void> _saveStorageSettings() async {
    final service = _settingsService;
    if (service == null) return;

    final retentionDays = _durationDaysMap[_selectedDuration] ?? 7;
    await service.updateSetting((current) {
      return current.copyWith(
        autoDeleteEnabled: _autoDelete,
        retentionDays: retentionDays,
        persistAudioFiles: _persistAudioFiles,
      );
    });

    final retentionService = HistoryRetentionService(
      HistoryStorage(IsarService.instance),
      service,
    );
    await retentionService.purgeExpiredIfEnabled();
  }

  // Opens a picker to select retention duration
  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'اختر المدة',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              // Duration list
              SizedBox(
                height: 320,
                child: ListView.builder(
                  itemCount: _durations.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDuration = _durations[index];
                        });
                        _saveStorageSettings();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _durations[index],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    _selectedDuration == _durations[index]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedDuration == _durations[index]
                                    ? const Color(0xFF2DC9A0)
                                    : Colors.black,
                              ),
                            ),
                            if (_selectedDuration == _durations[index])
                              const Icon(Icons.check, color: Color(0xFF2DC9A0)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green header section (at top) with back arrow inside
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
              color: const Color(0xFF2DC9A0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'إعدادات التخزين',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'اختر مدة حفظ التسجيلات',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Settings content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Duration picker
                    const Text(
                      'مدة الحفظ',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showDurationPicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2DC9A0),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDuration,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF2DC9A0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Auto-delete toggle
                    const Text(
                      'حذف تلقائي',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _autoDelete
                              ? const Color(0xFF2DC9A0)
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: _autoDelete
                            ? const Color(0xFF2DC9A0).withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _autoDelete ? 'مفعّل' : 'معطّل',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 14,
                              color: _autoDelete
                                  ? const Color(0xFF2DC9A0)
                                  : Colors.grey,
                            ),
                          ),
                          Switch(
                            value: _autoDelete,
                            onChanged: (value) {
                              setState(() {
                                _autoDelete = value;
                              });
                              _saveStorageSettings();
                            },
                            activeThumbColor: const Color(0xFF2DC9A0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'حفظ الصوت',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _persistAudioFiles
                              ? const Color(0xFF2DC9A0)
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: _persistAudioFiles
                            ? const Color(0xFF2DC9A0).withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _persistAudioFiles ? 'مفعّل' : 'معطّل',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 14,
                              color: _persistAudioFiles
                                  ? const Color(0xFF2DC9A0)
                                  : Colors.grey,
                            ),
                          ),
                          Switch(
                            value: _persistAudioFiles,
                            onChanged: (value) {
                              setState(() {
                                _persistAudioFiles = value;
                              });
                              _saveStorageSettings();
                            },
                            activeThumbColor: const Color(0xFF2DC9A0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
