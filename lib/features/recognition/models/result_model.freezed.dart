// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecognitionResultData _$RecognitionResultDataFromJson(
  Map<String, dynamic> json,
) {
  return _RecognitionResultData.fromJson(json);
}

/// @nodoc
mixin _$RecognitionResultData {
  String get primaryGesture => throw _privateConstructorUsedError;
  String get primaryGestureAr => throw _privateConstructorUsedError;
  double get primaryConfidence => throw _privateConstructorUsedError;
  List<AlternativeMatch> get alternatives => throw _privateConstructorUsedError;
  int get processingTime => throw _privateConstructorUsedError; // ms
  int get sequenceLength =>
      throw _privateConstructorUsedError; // number of frames
  String get debug => throw _privateConstructorUsedError;

  /// Serializes this RecognitionResultData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecognitionResultData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognitionResultDataCopyWith<RecognitionResultData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognitionResultDataCopyWith<$Res> {
  factory $RecognitionResultDataCopyWith(
    RecognitionResultData value,
    $Res Function(RecognitionResultData) then,
  ) = _$RecognitionResultDataCopyWithImpl<$Res, RecognitionResultData>;
  @useResult
  $Res call({
    String primaryGesture,
    String primaryGestureAr,
    double primaryConfidence,
    List<AlternativeMatch> alternatives,
    int processingTime,
    int sequenceLength,
    String debug,
  });
}

/// @nodoc
class _$RecognitionResultDataCopyWithImpl<
  $Res,
  $Val extends RecognitionResultData
>
    implements $RecognitionResultDataCopyWith<$Res> {
  _$RecognitionResultDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognitionResultData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryGesture = null,
    Object? primaryGestureAr = null,
    Object? primaryConfidence = null,
    Object? alternatives = null,
    Object? processingTime = null,
    Object? sequenceLength = null,
    Object? debug = null,
  }) {
    return _then(
      _value.copyWith(
            primaryGesture: null == primaryGesture
                ? _value.primaryGesture
                : primaryGesture // ignore: cast_nullable_to_non_nullable
                      as String,
            primaryGestureAr: null == primaryGestureAr
                ? _value.primaryGestureAr
                : primaryGestureAr // ignore: cast_nullable_to_non_nullable
                      as String,
            primaryConfidence: null == primaryConfidence
                ? _value.primaryConfidence
                : primaryConfidence // ignore: cast_nullable_to_non_nullable
                      as double,
            alternatives: null == alternatives
                ? _value.alternatives
                : alternatives // ignore: cast_nullable_to_non_nullable
                      as List<AlternativeMatch>,
            processingTime: null == processingTime
                ? _value.processingTime
                : processingTime // ignore: cast_nullable_to_non_nullable
                      as int,
            sequenceLength: null == sequenceLength
                ? _value.sequenceLength
                : sequenceLength // ignore: cast_nullable_to_non_nullable
                      as int,
            debug: null == debug
                ? _value.debug
                : debug // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecognitionResultDataImplCopyWith<$Res>
    implements $RecognitionResultDataCopyWith<$Res> {
  factory _$$RecognitionResultDataImplCopyWith(
    _$RecognitionResultDataImpl value,
    $Res Function(_$RecognitionResultDataImpl) then,
  ) = __$$RecognitionResultDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String primaryGesture,
    String primaryGestureAr,
    double primaryConfidence,
    List<AlternativeMatch> alternatives,
    int processingTime,
    int sequenceLength,
    String debug,
  });
}

/// @nodoc
class __$$RecognitionResultDataImplCopyWithImpl<$Res>
    extends
        _$RecognitionResultDataCopyWithImpl<$Res, _$RecognitionResultDataImpl>
    implements _$$RecognitionResultDataImplCopyWith<$Res> {
  __$$RecognitionResultDataImplCopyWithImpl(
    _$RecognitionResultDataImpl _value,
    $Res Function(_$RecognitionResultDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecognitionResultData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryGesture = null,
    Object? primaryGestureAr = null,
    Object? primaryConfidence = null,
    Object? alternatives = null,
    Object? processingTime = null,
    Object? sequenceLength = null,
    Object? debug = null,
  }) {
    return _then(
      _$RecognitionResultDataImpl(
        primaryGesture: null == primaryGesture
            ? _value.primaryGesture
            : primaryGesture // ignore: cast_nullable_to_non_nullable
                  as String,
        primaryGestureAr: null == primaryGestureAr
            ? _value.primaryGestureAr
            : primaryGestureAr // ignore: cast_nullable_to_non_nullable
                  as String,
        primaryConfidence: null == primaryConfidence
            ? _value.primaryConfidence
            : primaryConfidence // ignore: cast_nullable_to_non_nullable
                  as double,
        alternatives: null == alternatives
            ? _value._alternatives
            : alternatives // ignore: cast_nullable_to_non_nullable
                  as List<AlternativeMatch>,
        processingTime: null == processingTime
            ? _value.processingTime
            : processingTime // ignore: cast_nullable_to_non_nullable
                  as int,
        sequenceLength: null == sequenceLength
            ? _value.sequenceLength
            : sequenceLength // ignore: cast_nullable_to_non_nullable
                  as int,
        debug: null == debug
            ? _value.debug
            : debug // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecognitionResultDataImpl implements _RecognitionResultData {
  const _$RecognitionResultDataImpl({
    required this.primaryGesture,
    required this.primaryGestureAr,
    required this.primaryConfidence,
    final List<AlternativeMatch> alternatives = const [],
    this.processingTime = 0,
    this.sequenceLength = 0,
    this.debug = '',
  }) : _alternatives = alternatives;

  factory _$RecognitionResultDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecognitionResultDataImplFromJson(json);

  @override
  final String primaryGesture;
  @override
  final String primaryGestureAr;
  @override
  final double primaryConfidence;
  final List<AlternativeMatch> _alternatives;
  @override
  @JsonKey()
  List<AlternativeMatch> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  @JsonKey()
  final int processingTime;
  // ms
  @override
  @JsonKey()
  final int sequenceLength;
  // number of frames
  @override
  @JsonKey()
  final String debug;

  @override
  String toString() {
    return 'RecognitionResultData(primaryGesture: $primaryGesture, primaryGestureAr: $primaryGestureAr, primaryConfidence: $primaryConfidence, alternatives: $alternatives, processingTime: $processingTime, sequenceLength: $sequenceLength, debug: $debug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognitionResultDataImpl &&
            (identical(other.primaryGesture, primaryGesture) ||
                other.primaryGesture == primaryGesture) &&
            (identical(other.primaryGestureAr, primaryGestureAr) ||
                other.primaryGestureAr == primaryGestureAr) &&
            (identical(other.primaryConfidence, primaryConfidence) ||
                other.primaryConfidence == primaryConfidence) &&
            const DeepCollectionEquality().equals(
              other._alternatives,
              _alternatives,
            ) &&
            (identical(other.processingTime, processingTime) ||
                other.processingTime == processingTime) &&
            (identical(other.sequenceLength, sequenceLength) ||
                other.sequenceLength == sequenceLength) &&
            (identical(other.debug, debug) || other.debug == debug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    primaryGesture,
    primaryGestureAr,
    primaryConfidence,
    const DeepCollectionEquality().hash(_alternatives),
    processingTime,
    sequenceLength,
    debug,
  );

  /// Create a copy of RecognitionResultData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognitionResultDataImplCopyWith<_$RecognitionResultDataImpl>
  get copyWith =>
      __$$RecognitionResultDataImplCopyWithImpl<_$RecognitionResultDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecognitionResultDataImplToJson(this);
  }
}

abstract class _RecognitionResultData implements RecognitionResultData {
  const factory _RecognitionResultData({
    required final String primaryGesture,
    required final String primaryGestureAr,
    required final double primaryConfidence,
    final List<AlternativeMatch> alternatives,
    final int processingTime,
    final int sequenceLength,
    final String debug,
  }) = _$RecognitionResultDataImpl;

  factory _RecognitionResultData.fromJson(Map<String, dynamic> json) =
      _$RecognitionResultDataImpl.fromJson;

  @override
  String get primaryGesture;
  @override
  String get primaryGestureAr;
  @override
  double get primaryConfidence;
  @override
  List<AlternativeMatch> get alternatives;
  @override
  int get processingTime; // ms
  @override
  int get sequenceLength; // number of frames
  @override
  String get debug;

  /// Create a copy of RecognitionResultData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognitionResultDataImplCopyWith<_$RecognitionResultDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AlternativeMatch _$AlternativeMatchFromJson(Map<String, dynamic> json) {
  return _AlternativeMatch.fromJson(json);
}

/// @nodoc
mixin _$AlternativeMatch {
  String get gesture => throw _privateConstructorUsedError;
  String get gestureAr => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this AlternativeMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlternativeMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlternativeMatchCopyWith<AlternativeMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlternativeMatchCopyWith<$Res> {
  factory $AlternativeMatchCopyWith(
    AlternativeMatch value,
    $Res Function(AlternativeMatch) then,
  ) = _$AlternativeMatchCopyWithImpl<$Res, AlternativeMatch>;
  @useResult
  $Res call({String gesture, String gestureAr, double confidence});
}

/// @nodoc
class _$AlternativeMatchCopyWithImpl<$Res, $Val extends AlternativeMatch>
    implements $AlternativeMatchCopyWith<$Res> {
  _$AlternativeMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlternativeMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gesture = null,
    Object? gestureAr = null,
    Object? confidence = null,
  }) {
    return _then(
      _value.copyWith(
            gesture: null == gesture
                ? _value.gesture
                : gesture // ignore: cast_nullable_to_non_nullable
                      as String,
            gestureAr: null == gestureAr
                ? _value.gestureAr
                : gestureAr // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlternativeMatchImplCopyWith<$Res>
    implements $AlternativeMatchCopyWith<$Res> {
  factory _$$AlternativeMatchImplCopyWith(
    _$AlternativeMatchImpl value,
    $Res Function(_$AlternativeMatchImpl) then,
  ) = __$$AlternativeMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gesture, String gestureAr, double confidence});
}

/// @nodoc
class __$$AlternativeMatchImplCopyWithImpl<$Res>
    extends _$AlternativeMatchCopyWithImpl<$Res, _$AlternativeMatchImpl>
    implements _$$AlternativeMatchImplCopyWith<$Res> {
  __$$AlternativeMatchImplCopyWithImpl(
    _$AlternativeMatchImpl _value,
    $Res Function(_$AlternativeMatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlternativeMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gesture = null,
    Object? gestureAr = null,
    Object? confidence = null,
  }) {
    return _then(
      _$AlternativeMatchImpl(
        gesture: null == gesture
            ? _value.gesture
            : gesture // ignore: cast_nullable_to_non_nullable
                  as String,
        gestureAr: null == gestureAr
            ? _value.gestureAr
            : gestureAr // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlternativeMatchImpl implements _AlternativeMatch {
  const _$AlternativeMatchImpl({
    required this.gesture,
    required this.gestureAr,
    required this.confidence,
  });

  factory _$AlternativeMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlternativeMatchImplFromJson(json);

  @override
  final String gesture;
  @override
  final String gestureAr;
  @override
  final double confidence;

  @override
  String toString() {
    return 'AlternativeMatch(gesture: $gesture, gestureAr: $gestureAr, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlternativeMatchImpl &&
            (identical(other.gesture, gesture) || other.gesture == gesture) &&
            (identical(other.gestureAr, gestureAr) ||
                other.gestureAr == gestureAr) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gesture, gestureAr, confidence);

  /// Create a copy of AlternativeMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlternativeMatchImplCopyWith<_$AlternativeMatchImpl> get copyWith =>
      __$$AlternativeMatchImplCopyWithImpl<_$AlternativeMatchImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AlternativeMatchImplToJson(this);
  }
}

abstract class _AlternativeMatch implements AlternativeMatch {
  const factory _AlternativeMatch({
    required final String gesture,
    required final String gestureAr,
    required final double confidence,
  }) = _$AlternativeMatchImpl;

  factory _AlternativeMatch.fromJson(Map<String, dynamic> json) =
      _$AlternativeMatchImpl.fromJson;

  @override
  String get gesture;
  @override
  String get gestureAr;
  @override
  double get confidence;

  /// Create a copy of AlternativeMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlternativeMatchImplCopyWith<_$AlternativeMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
