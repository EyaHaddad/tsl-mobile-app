import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:tsl_mobile_app/features/history/models/history_record.dart';
import 'package:tsl_mobile_app/features/settings/models/settings_model.dart';

void main() {
  group('HistoryRecord Model Tests', () {
    test('HistoryRecord should initialize with default values', () {
      final record = HistoryRecord();
      
      expect(record.id, equals(Isar.autoIncrement));
      expect(record.isFavorite, isFalse);
      expect(record.confidence, isNull);
      expect(record.audioPath, isNull);
      expect(record.expiresAt, isNull);
      expect(record.alternatives, isEmpty);
    });

    test('HistoryRecord should initialize with custom values', () {
      final now = DateTime.now();
      final expireTime = now.add(Duration(days: 7));
      
      final record = HistoryRecord()
        ..recognizedText = 'hello'
        ..audioPath = '/path/to/audio.mp3'
        ..createdAt = now
        ..expiresAt = expireTime
        ..isFavorite = true
        ..confidence = 0.95
        ..alternatives = ['hi', 'hey'];

      expect(record.recognizedText, equals('hello'));
      expect(record.audioPath, equals('/path/to/audio.mp3'));
      expect(record.createdAt, equals(now));
      expect(record.expiresAt, equals(expireTime));
      expect(record.isFavorite, isTrue);
      expect(record.confidence, equals(0.95));
      expect(record.alternatives.length, equals(2));
      expect(record.alternatives, contains('hi'));
    });

    test('HistoryRecord should handle null confidence', () {
      final record = HistoryRecord()
        ..recognizedText = 'test'
        ..createdAt = DateTime.now()
        ..confidence = null;

      expect(record.confidence, isNull);
    });

    test('HistoryRecord should handle empty alternatives list', () {
      final record = HistoryRecord()
        ..recognizedText = 'test'
        ..createdAt = DateTime.now()
        ..alternatives = [];

      expect(record.alternatives, isEmpty);
      expect(record.alternatives.length, equals(0));
    });

    test('HistoryRecord should support multiple alternatives', () {
      final record = HistoryRecord()
        ..recognizedText = 'hello'
        ..createdAt = DateTime.now()
        ..alternatives = ['hi', 'hey', 'hello there', 'hallo'];

      expect(record.alternatives.length, equals(4));
      expect(record.alternatives[0], equals('hi'));
      expect(record.alternatives[3], equals('hallo'));
    });



    test('HistoryRecord should store recognized text correctly', () {
      final text = 'السلام عليكم';
      final record = HistoryRecord()
        ..recognizedText = text
        ..createdAt = DateTime.now();

      expect(record.recognizedText, equals(text));
    });

    test('HistoryRecord ID defaults to autoIncrement', () {
      final record = HistoryRecord();
      expect(record.id, equals(Isar.autoIncrement));
    });

    test('HistoryRecord should handle audioPath as optional', () {
      final record1 = HistoryRecord()
        ..recognizedText = 'with_audio'
        ..createdAt = DateTime.now()
        ..audioPath = '/path/to/file.mp3';

      final record2 = HistoryRecord()
        ..recognizedText = 'without_audio'
        ..createdAt = DateTime.now()
        ..audioPath = null;

      expect(record1.audioPath, isNotNull);
      expect(record2.audioPath, isNull);
    });
  });

  group('AppSettings Model Tests', () {
    test('AppSettings should initialize with default values', () {
      const settings = AppSettings();

      expect(settings.enableTTS, isFalse);
      expect(settings.speechRate, equals(1.0));
      expect(settings.voicePitch, equals(1.0));
      expect(settings.enableVibration, isTrue);
      expect(settings.enableSound, isTrue);
      expect(settings.language, equals('ar'));
      expect(settings.cameraResolution, equals('high'));
      expect(settings.sequenceLength, equals(30));
      expect(settings.confidenceThreshold, equals(0.7));
      expect(settings.autoDeleteEnabled, isTrue);
      expect(settings.retentionDays, equals(7));
      expect(settings.persistAudioFiles, isFalse);
      expect(settings.isDarkMode, isFalse);
      expect(settings.showDebugInfo, isTrue);
    });

    test('AppSettings should support custom TTS values', () {
      const settings = AppSettings(
        enableTTS: true,
        speechRate: 1.5,
        voicePitch: 0.8,
      );

      expect(settings.enableTTS, isTrue);
      expect(settings.speechRate, equals(1.5));
      expect(settings.voicePitch, equals(0.8));
    });

    test('AppSettings should support language switching', () {
      const settingsAr = AppSettings(language: 'ar');
      const settingsEn = AppSettings(language: 'en');
      const settingsFr = AppSettings(language: 'fr');

      expect(settingsAr.language, equals('ar'));
      expect(settingsEn.language, equals('en'));
      expect(settingsFr.language, equals('fr'));
    });

    test('AppSettings should support camera resolution options', () {
      const settingsLow = AppSettings(cameraResolution: 'low');
      const settingsMed = AppSettings(cameraResolution: 'medium');
      const settingsHigh = AppSettings(cameraResolution: 'high');

      expect(settingsLow.cameraResolution, equals('low'));
      expect(settingsMed.cameraResolution, equals('medium'));
      expect(settingsHigh.cameraResolution, equals('high'));
    });

    test('AppSettings should support auto-delete toggle', () {
      const enabledSettings = AppSettings(autoDeleteEnabled: true);
      const disabledSettings = AppSettings(autoDeleteEnabled: false);

      expect(enabledSettings.autoDeleteEnabled, isTrue);
      expect(disabledSettings.autoDeleteEnabled, isFalse);
    });

    test('AppSettings should support retention period configuration - 1 day', () {
      const settings = AppSettings(retentionDays: 1);
      expect(settings.retentionDays, equals(1));
    });

    test('AppSettings should support retention period configuration - 7 days', () {
      const settings = AppSettings(retentionDays: 7);
      expect(settings.retentionDays, equals(7));
    });

    test('AppSettings should support retention period configuration - 30 days', () {
      const settings = AppSettings(retentionDays: 30);
      expect(settings.retentionDays, equals(30));
    });

    test('AppSettings should support confidence threshold configuration', () {
      const settings = AppSettings(confidenceThreshold: 0.5);
      expect(settings.confidenceThreshold, equals(0.5));
    });

    test('AppSettings should support dark mode toggle', () {
      const lightSettings = AppSettings(isDarkMode: false);
      const darkSettings = AppSettings(isDarkMode: true);

      expect(lightSettings.isDarkMode, isFalse);
      expect(darkSettings.isDarkMode, isTrue);
    });

    test('AppSettings should support audio persistence toggle', () {
      const persistSettings = AppSettings(persistAudioFiles: true);
      const deleteSettings = AppSettings(persistAudioFiles: false);

      expect(persistSettings.persistAudioFiles, isTrue);
      expect(deleteSettings.persistAudioFiles, isFalse);
    });

    test('AppSettings should support sequence length configuration', () {
      const settings = AppSettings(sequenceLength: 60);
      expect(settings.sequenceLength, equals(60));
    });

    test('AppSettings should support vibration toggle', () {
      const enabledSettings = AppSettings(enableVibration: true);
      const disabledSettings = AppSettings(enableVibration: false);

      expect(enabledSettings.enableVibration, isTrue);
      expect(disabledSettings.enableVibration, isFalse);
    });

    test('AppSettings should support sound toggle', () {
      const enabledSettings = AppSettings(enableSound: true);
      const disabledSettings = AppSettings(enableSound: false);

      expect(enabledSettings.enableSound, isTrue);
      expect(disabledSettings.enableSound, isFalse);
    });

    test('AppSettings should serialize to JSON', () {
      const settings = AppSettings(
        enableTTS: true,
        language: 'en',
        autoDeleteEnabled: true,
        retentionDays: 14,
      );

      final json = settings.toJson();

      expect(json['enableTTS'], isTrue);
      expect(json['language'], equals('en'));
      expect(json['autoDeleteEnabled'], isTrue);
      expect(json['retentionDays'], equals(14));
    });

    test('AppSettings should deserialize from JSON', () {
      final json = {
        'enableTTS': true,
        'speechRate': 1.2,
        'voicePitch': 0.9,
        'enableVibration': true,
        'enableSound': true,
        'language': 'fr',
        'cameraResolution': 'medium',
        'sequenceLength': 40,
        'confidenceThreshold': 0.6,
        'autoDeleteEnabled': false,
        'retentionDays': 3,
        'persistAudioFiles': true,
        'isDarkMode': true,
        'showDebugInfo': false,
      };

      final settings = AppSettings.fromJson(json);

      expect(settings.enableTTS, isTrue);
      expect(settings.speechRate, equals(1.2));
      expect(settings.language, equals('fr'));
      expect(settings.autoDeleteEnabled, isFalse);
      expect(settings.retentionDays, equals(3));
    });

    test('AppSettings should be immutable', () {
      const settings = AppSettings(enableTTS: false);

      // Should not be able to modify original
      expect(settings.enableTTS, isFalse);
      // copyWith creates new instance
      final newSettings = settings.copyWith(enableTTS: true);
      expect(newSettings.enableTTS, isTrue);
      expect(settings.enableTTS, isFalse); // Original unchanged
    });

    test('AppSettings copyWith should update single field', () {
      const original = AppSettings(
        language: 'ar',
        enableTTS: false,
      );

      final updated = original.copyWith(enableTTS: true);

      expect(updated.language, equals('ar')); // Unchanged
      expect(updated.enableTTS, isTrue); // Changed
    });

    test('AppSettings copyWith should update multiple fields', () {
      const original = AppSettings(
        language: 'ar',
        retentionDays: 7,
        confidenceThreshold: 0.7,
      );

      final updated = original.copyWith(
        language: 'en',
        retentionDays: 14,
        confidenceThreshold: 0.5,
      );

      expect(updated.language, equals('en'));
      expect(updated.retentionDays, equals(14));
      expect(updated.confidenceThreshold, equals(0.5));
    });
  });
}//(HistoryRecord + AppSettings)
//8 HistoryRecord tests (initialisation et champs uniquement)//
//25 AppSettings tests (configuration du modèle)
