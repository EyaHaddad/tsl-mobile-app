// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  bool get enableTTS => throw _privateConstructorUsedError;
  double get speechRate => throw _privateConstructorUsedError;
  double get voicePitch => throw _privateConstructorUsedError;
  bool get enableVibration => throw _privateConstructorUsedError;
  bool get enableSound => throw _privateConstructorUsedError;
  String get language =>
      throw _privateConstructorUsedError; // 'ar' for Arabic, 'en' for English, 'fr' for French
  String get cameraResolution =>
      throw _privateConstructorUsedError; // 'low', 'medium', 'high'
  int get sequenceLength =>
      throw _privateConstructorUsedError; // frames to collect before inference
  double get confidenceThreshold => throw _privateConstructorUsedError;
  bool get autoDeleteEnabled => throw _privateConstructorUsedError;
  int get retentionDays => throw _privateConstructorUsedError;
  bool get persistAudioFiles => throw _privateConstructorUsedError;
  bool get isDarkMode => throw _privateConstructorUsedError;
  bool get showDebugInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {bool enableTTS,
      double speechRate,
      double voicePitch,
      bool enableVibration,
      bool enableSound,
      String language,
      String cameraResolution,
      int sequenceLength,
      double confidenceThreshold,
      bool autoDeleteEnabled,
      int retentionDays,
      bool persistAudioFiles,
      bool isDarkMode,
      bool showDebugInfo});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableTTS = null,
    Object? speechRate = null,
    Object? voicePitch = null,
    Object? enableVibration = null,
    Object? enableSound = null,
    Object? language = null,
    Object? cameraResolution = null,
    Object? sequenceLength = null,
    Object? confidenceThreshold = null,
    Object? autoDeleteEnabled = null,
    Object? retentionDays = null,
    Object? persistAudioFiles = null,
    Object? isDarkMode = null,
    Object? showDebugInfo = null,
  }) {
    return _then(_value.copyWith(
      enableTTS: null == enableTTS
          ? _value.enableTTS
          : enableTTS // ignore: cast_nullable_to_non_nullable
              as bool,
      speechRate: null == speechRate
          ? _value.speechRate
          : speechRate // ignore: cast_nullable_to_non_nullable
              as double,
      voicePitch: null == voicePitch
          ? _value.voicePitch
          : voicePitch // ignore: cast_nullable_to_non_nullable
              as double,
      enableVibration: null == enableVibration
          ? _value.enableVibration
          : enableVibration // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSound: null == enableSound
          ? _value.enableSound
          : enableSound // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      cameraResolution: null == cameraResolution
          ? _value.cameraResolution
          : cameraResolution // ignore: cast_nullable_to_non_nullable
              as String,
      sequenceLength: null == sequenceLength
          ? _value.sequenceLength
          : sequenceLength // ignore: cast_nullable_to_non_nullable
              as int,
      confidenceThreshold: null == confidenceThreshold
          ? _value.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      autoDeleteEnabled: null == autoDeleteEnabled
          ? _value.autoDeleteEnabled
          : autoDeleteEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      retentionDays: null == retentionDays
          ? _value.retentionDays
          : retentionDays // ignore: cast_nullable_to_non_nullable
              as int,
      persistAudioFiles: null == persistAudioFiles
          ? _value.persistAudioFiles
          : persistAudioFiles // ignore: cast_nullable_to_non_nullable
              as bool,
      isDarkMode: null == isDarkMode
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showDebugInfo: null == showDebugInfo
          ? _value.showDebugInfo
          : showDebugInfo // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableTTS,
      double speechRate,
      double voicePitch,
      bool enableVibration,
      bool enableSound,
      String language,
      String cameraResolution,
      int sequenceLength,
      double confidenceThreshold,
      bool autoDeleteEnabled,
      int retentionDays,
      bool persistAudioFiles,
      bool isDarkMode,
      bool showDebugInfo});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableTTS = null,
    Object? speechRate = null,
    Object? voicePitch = null,
    Object? enableVibration = null,
    Object? enableSound = null,
    Object? language = null,
    Object? cameraResolution = null,
    Object? sequenceLength = null,
    Object? confidenceThreshold = null,
    Object? autoDeleteEnabled = null,
    Object? retentionDays = null,
    Object? persistAudioFiles = null,
    Object? isDarkMode = null,
    Object? showDebugInfo = null,
  }) {
    return _then(_$AppSettingsImpl(
      enableTTS: null == enableTTS
          ? _value.enableTTS
          : enableTTS // ignore: cast_nullable_to_non_nullable
              as bool,
      speechRate: null == speechRate
          ? _value.speechRate
          : speechRate // ignore: cast_nullable_to_non_nullable
              as double,
      voicePitch: null == voicePitch
          ? _value.voicePitch
          : voicePitch // ignore: cast_nullable_to_non_nullable
              as double,
      enableVibration: null == enableVibration
          ? _value.enableVibration
          : enableVibration // ignore: cast_nullable_to_non_nullable
              as bool,
      enableSound: null == enableSound
          ? _value.enableSound
          : enableSound // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      cameraResolution: null == cameraResolution
          ? _value.cameraResolution
          : cameraResolution // ignore: cast_nullable_to_non_nullable
              as String,
      sequenceLength: null == sequenceLength
          ? _value.sequenceLength
          : sequenceLength // ignore: cast_nullable_to_non_nullable
              as int,
      confidenceThreshold: null == confidenceThreshold
          ? _value.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      autoDeleteEnabled: null == autoDeleteEnabled
          ? _value.autoDeleteEnabled
          : autoDeleteEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      retentionDays: null == retentionDays
          ? _value.retentionDays
          : retentionDays // ignore: cast_nullable_to_non_nullable
              as int,
      persistAudioFiles: null == persistAudioFiles
          ? _value.persistAudioFiles
          : persistAudioFiles // ignore: cast_nullable_to_non_nullable
              as bool,
      isDarkMode: null == isDarkMode
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showDebugInfo: null == showDebugInfo
          ? _value.showDebugInfo
          : showDebugInfo // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.enableTTS = false,
      this.speechRate = 1.0,
      this.voicePitch = 1.0,
      this.enableVibration = true,
      this.enableSound = true,
      this.language = 'ar',
      this.cameraResolution = 'high',
      this.sequenceLength = 30,
      this.confidenceThreshold = 0.7,
      this.autoDeleteEnabled = true,
      this.retentionDays = 7,
      this.persistAudioFiles = false,
      this.isDarkMode = false,
      this.showDebugInfo = true});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool enableTTS;
  @override
  @JsonKey()
  final double speechRate;
  @override
  @JsonKey()
  final double voicePitch;
  @override
  @JsonKey()
  final bool enableVibration;
  @override
  @JsonKey()
  final bool enableSound;
  @override
  @JsonKey()
  final String language;
// 'ar' for Arabic, 'en' for English, 'fr' for French
  @override
  @JsonKey()
  final String cameraResolution;
// 'low', 'medium', 'high'
  @override
  @JsonKey()
  final int sequenceLength;
// frames to collect before inference
  @override
  @JsonKey()
  final double confidenceThreshold;
  @override
  @JsonKey()
  final bool autoDeleteEnabled;
  @override
  @JsonKey()
  final int retentionDays;
  @override
  @JsonKey()
  final bool persistAudioFiles;
  @override
  @JsonKey()
  final bool isDarkMode;
  @override
  @JsonKey()
  final bool showDebugInfo;

  @override
  String toString() {
    return 'AppSettings(enableTTS: $enableTTS, speechRate: $speechRate, voicePitch: $voicePitch, enableVibration: $enableVibration, enableSound: $enableSound, language: $language, cameraResolution: $cameraResolution, sequenceLength: $sequenceLength, confidenceThreshold: $confidenceThreshold, autoDeleteEnabled: $autoDeleteEnabled, retentionDays: $retentionDays, persistAudioFiles: $persistAudioFiles, isDarkMode: $isDarkMode, showDebugInfo: $showDebugInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.enableTTS, enableTTS) ||
                other.enableTTS == enableTTS) &&
            (identical(other.speechRate, speechRate) ||
                other.speechRate == speechRate) &&
            (identical(other.voicePitch, voicePitch) ||
                other.voicePitch == voicePitch) &&
            (identical(other.enableVibration, enableVibration) ||
                other.enableVibration == enableVibration) &&
            (identical(other.enableSound, enableSound) ||
                other.enableSound == enableSound) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.cameraResolution, cameraResolution) ||
                other.cameraResolution == cameraResolution) &&
            (identical(other.sequenceLength, sequenceLength) ||
                other.sequenceLength == sequenceLength) &&
            (identical(other.confidenceThreshold, confidenceThreshold) ||
                other.confidenceThreshold == confidenceThreshold) &&
            (identical(other.autoDeleteEnabled, autoDeleteEnabled) ||
                other.autoDeleteEnabled == autoDeleteEnabled) &&
            (identical(other.retentionDays, retentionDays) ||
                other.retentionDays == retentionDays) &&
            (identical(other.persistAudioFiles, persistAudioFiles) ||
                other.persistAudioFiles == persistAudioFiles) &&
            (identical(other.isDarkMode, isDarkMode) ||
                other.isDarkMode == isDarkMode) &&
            (identical(other.showDebugInfo, showDebugInfo) ||
                other.showDebugInfo == showDebugInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enableTTS,
      speechRate,
      voicePitch,
      enableVibration,
      enableSound,
      language,
      cameraResolution,
      sequenceLength,
      confidenceThreshold,
      autoDeleteEnabled,
      retentionDays,
      persistAudioFiles,
      isDarkMode,
      showDebugInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final bool enableTTS,
      final double speechRate,
      final double voicePitch,
      final bool enableVibration,
      final bool enableSound,
      final String language,
      final String cameraResolution,
      final int sequenceLength,
      final double confidenceThreshold,
      final bool autoDeleteEnabled,
      final int retentionDays,
      final bool persistAudioFiles,
      final bool isDarkMode,
      final bool showDebugInfo}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  bool get enableTTS;
  @override
  double get speechRate;
  @override
  double get voicePitch;
  @override
  bool get enableVibration;
  @override
  bool get enableSound;
  @override
  String get language;
  @override // 'ar' for Arabic, 'en' for English, 'fr' for French
  String get cameraResolution;
  @override // 'low', 'medium', 'high'
  int get sequenceLength;
  @override // frames to collect before inference
  double get confidenceThreshold;
  @override
  bool get autoDeleteEnabled;
  @override
  int get retentionDays;
  @override
  bool get persistAudioFiles;
  @override
  bool get isDarkMode;
  @override
  bool get showDebugInfo;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
