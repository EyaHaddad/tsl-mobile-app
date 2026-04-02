// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gesture_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GestureModel _$GestureModelFromJson(Map<String, dynamic> json) {
  return _GestureModel.fromJson(json);
}

/// @nodoc
mixin _$GestureModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<List<double>> get landmarks =>
      throw _privateConstructorUsedError; // Sequence of hand landmarks (21 points per frame)
  int get frameCount => throw _privateConstructorUsedError;

  /// Serializes this GestureModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GestureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GestureModelCopyWith<GestureModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GestureModelCopyWith<$Res> {
  factory $GestureModelCopyWith(
    GestureModel value,
    $Res Function(GestureModel) then,
  ) = _$GestureModelCopyWithImpl<$Res, GestureModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String nameAr,
    String description,
    List<List<double>> landmarks,
    int frameCount,
  });
}

/// @nodoc
class _$GestureModelCopyWithImpl<$Res, $Val extends GestureModel>
    implements $GestureModelCopyWith<$Res> {
  _$GestureModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GestureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = null,
    Object? description = null,
    Object? landmarks = null,
    Object? frameCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            nameAr: null == nameAr
                ? _value.nameAr
                : nameAr // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            landmarks: null == landmarks
                ? _value.landmarks
                : landmarks // ignore: cast_nullable_to_non_nullable
                      as List<List<double>>,
            frameCount: null == frameCount
                ? _value.frameCount
                : frameCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GestureModelImplCopyWith<$Res>
    implements $GestureModelCopyWith<$Res> {
  factory _$$GestureModelImplCopyWith(
    _$GestureModelImpl value,
    $Res Function(_$GestureModelImpl) then,
  ) = __$$GestureModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String nameAr,
    String description,
    List<List<double>> landmarks,
    int frameCount,
  });
}

/// @nodoc
class __$$GestureModelImplCopyWithImpl<$Res>
    extends _$GestureModelCopyWithImpl<$Res, _$GestureModelImpl>
    implements _$$GestureModelImplCopyWith<$Res> {
  __$$GestureModelImplCopyWithImpl(
    _$GestureModelImpl _value,
    $Res Function(_$GestureModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GestureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = null,
    Object? description = null,
    Object? landmarks = null,
    Object? frameCount = null,
  }) {
    return _then(
      _$GestureModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nameAr: null == nameAr
            ? _value.nameAr
            : nameAr // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        landmarks: null == landmarks
            ? _value._landmarks
            : landmarks // ignore: cast_nullable_to_non_nullable
                  as List<List<double>>,
        frameCount: null == frameCount
            ? _value.frameCount
            : frameCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GestureModelImpl implements _GestureModel {
  const _$GestureModelImpl({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    final List<List<double>> landmarks = const [],
    this.frameCount = 0,
  }) : _landmarks = landmarks;

  factory _$GestureModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GestureModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String nameAr;
  @override
  final String description;
  final List<List<double>> _landmarks;
  @override
  @JsonKey()
  List<List<double>> get landmarks {
    if (_landmarks is EqualUnmodifiableListView) return _landmarks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_landmarks);
  }

  // Sequence of hand landmarks (21 points per frame)
  @override
  @JsonKey()
  final int frameCount;

  @override
  String toString() {
    return 'GestureModel(id: $id, name: $name, nameAr: $nameAr, description: $description, landmarks: $landmarks, frameCount: $frameCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GestureModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._landmarks,
              _landmarks,
            ) &&
            (identical(other.frameCount, frameCount) ||
                other.frameCount == frameCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    nameAr,
    description,
    const DeepCollectionEquality().hash(_landmarks),
    frameCount,
  );

  /// Create a copy of GestureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GestureModelImplCopyWith<_$GestureModelImpl> get copyWith =>
      __$$GestureModelImplCopyWithImpl<_$GestureModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GestureModelImplToJson(this);
  }
}

abstract class _GestureModel implements GestureModel {
  const factory _GestureModel({
    required final String id,
    required final String name,
    required final String nameAr,
    required final String description,
    final List<List<double>> landmarks,
    final int frameCount,
  }) = _$GestureModelImpl;

  factory _GestureModel.fromJson(Map<String, dynamic> json) =
      _$GestureModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get nameAr;
  @override
  String get description;
  @override
  List<List<double>> get landmarks; // Sequence of hand landmarks (21 points per frame)
  @override
  int get frameCount;

  /// Create a copy of GestureModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GestureModelImplCopyWith<_$GestureModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecognitionResult _$RecognitionResultFromJson(Map<String, dynamic> json) {
  return _RecognitionResult.fromJson(json);
}

/// @nodoc
mixin _$RecognitionResult {
  String get gesture => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  List<RecognitionMatch> get alternatives => throw _privateConstructorUsedError;
  int get processingTimeMs => throw _privateConstructorUsedError;

  /// Serializes this RecognitionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognitionResultCopyWith<RecognitionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognitionResultCopyWith<$Res> {
  factory $RecognitionResultCopyWith(
    RecognitionResult value,
    $Res Function(RecognitionResult) then,
  ) = _$RecognitionResultCopyWithImpl<$Res, RecognitionResult>;
  @useResult
  $Res call({
    String gesture,
    double confidence,
    List<RecognitionMatch> alternatives,
    int processingTimeMs,
  });
}

/// @nodoc
class _$RecognitionResultCopyWithImpl<$Res, $Val extends RecognitionResult>
    implements $RecognitionResultCopyWith<$Res> {
  _$RecognitionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gesture = null,
    Object? confidence = null,
    Object? alternatives = null,
    Object? processingTimeMs = null,
  }) {
    return _then(
      _value.copyWith(
            gesture: null == gesture
                ? _value.gesture
                : gesture // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            alternatives: null == alternatives
                ? _value.alternatives
                : alternatives // ignore: cast_nullable_to_non_nullable
                      as List<RecognitionMatch>,
            processingTimeMs: null == processingTimeMs
                ? _value.processingTimeMs
                : processingTimeMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecognitionResultImplCopyWith<$Res>
    implements $RecognitionResultCopyWith<$Res> {
  factory _$$RecognitionResultImplCopyWith(
    _$RecognitionResultImpl value,
    $Res Function(_$RecognitionResultImpl) then,
  ) = __$$RecognitionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String gesture,
    double confidence,
    List<RecognitionMatch> alternatives,
    int processingTimeMs,
  });
}

/// @nodoc
class __$$RecognitionResultImplCopyWithImpl<$Res>
    extends _$RecognitionResultCopyWithImpl<$Res, _$RecognitionResultImpl>
    implements _$$RecognitionResultImplCopyWith<$Res> {
  __$$RecognitionResultImplCopyWithImpl(
    _$RecognitionResultImpl _value,
    $Res Function(_$RecognitionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gesture = null,
    Object? confidence = null,
    Object? alternatives = null,
    Object? processingTimeMs = null,
  }) {
    return _then(
      _$RecognitionResultImpl(
        gesture: null == gesture
            ? _value.gesture
            : gesture // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        alternatives: null == alternatives
            ? _value._alternatives
            : alternatives // ignore: cast_nullable_to_non_nullable
                  as List<RecognitionMatch>,
        processingTimeMs: null == processingTimeMs
            ? _value.processingTimeMs
            : processingTimeMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecognitionResultImpl implements _RecognitionResult {
  const _$RecognitionResultImpl({
    required this.gesture,
    required this.confidence,
    final List<RecognitionMatch> alternatives = const [],
    this.processingTimeMs = 0,
  }) : _alternatives = alternatives;

  factory _$RecognitionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecognitionResultImplFromJson(json);

  @override
  final String gesture;
  @override
  final double confidence;
  final List<RecognitionMatch> _alternatives;
  @override
  @JsonKey()
  List<RecognitionMatch> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  @JsonKey()
  final int processingTimeMs;

  @override
  String toString() {
    return 'RecognitionResult(gesture: $gesture, confidence: $confidence, alternatives: $alternatives, processingTimeMs: $processingTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognitionResultImpl &&
            (identical(other.gesture, gesture) || other.gesture == gesture) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(
              other._alternatives,
              _alternatives,
            ) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gesture,
    confidence,
    const DeepCollectionEquality().hash(_alternatives),
    processingTimeMs,
  );

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognitionResultImplCopyWith<_$RecognitionResultImpl> get copyWith =>
      __$$RecognitionResultImplCopyWithImpl<_$RecognitionResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecognitionResultImplToJson(this);
  }
}

abstract class _RecognitionResult implements RecognitionResult {
  const factory _RecognitionResult({
    required final String gesture,
    required final double confidence,
    final List<RecognitionMatch> alternatives,
    final int processingTimeMs,
  }) = _$RecognitionResultImpl;

  factory _RecognitionResult.fromJson(Map<String, dynamic> json) =
      _$RecognitionResultImpl.fromJson;

  @override
  String get gesture;
  @override
  double get confidence;
  @override
  List<RecognitionMatch> get alternatives;
  @override
  int get processingTimeMs;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognitionResultImplCopyWith<_$RecognitionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecognitionMatch _$RecognitionMatchFromJson(Map<String, dynamic> json) {
  return _RecognitionMatch.fromJson(json);
}

/// @nodoc
mixin _$RecognitionMatch {
  String get gesture => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this RecognitionMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecognitionMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognitionMatchCopyWith<RecognitionMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognitionMatchCopyWith<$Res> {
  factory $RecognitionMatchCopyWith(
    RecognitionMatch value,
    $Res Function(RecognitionMatch) then,
  ) = _$RecognitionMatchCopyWithImpl<$Res, RecognitionMatch>;
  @useResult
  $Res call({String gesture, double confidence});
}

/// @nodoc
class _$RecognitionMatchCopyWithImpl<$Res, $Val extends RecognitionMatch>
    implements $RecognitionMatchCopyWith<$Res> {
  _$RecognitionMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognitionMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gesture = null, Object? confidence = null}) {
    return _then(
      _value.copyWith(
            gesture: null == gesture
                ? _value.gesture
                : gesture // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RecognitionMatchImplCopyWith<$Res>
    implements $RecognitionMatchCopyWith<$Res> {
  factory _$$RecognitionMatchImplCopyWith(
    _$RecognitionMatchImpl value,
    $Res Function(_$RecognitionMatchImpl) then,
  ) = __$$RecognitionMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gesture, double confidence});
}

/// @nodoc
class __$$RecognitionMatchImplCopyWithImpl<$Res>
    extends _$RecognitionMatchCopyWithImpl<$Res, _$RecognitionMatchImpl>
    implements _$$RecognitionMatchImplCopyWith<$Res> {
  __$$RecognitionMatchImplCopyWithImpl(
    _$RecognitionMatchImpl _value,
    $Res Function(_$RecognitionMatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecognitionMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gesture = null, Object? confidence = null}) {
    return _then(
      _$RecognitionMatchImpl(
        gesture: null == gesture
            ? _value.gesture
            : gesture // ignore: cast_nullable_to_non_nullable
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
class _$RecognitionMatchImpl implements _RecognitionMatch {
  const _$RecognitionMatchImpl({
    required this.gesture,
    required this.confidence,
  });

  factory _$RecognitionMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecognitionMatchImplFromJson(json);

  @override
  final String gesture;
  @override
  final double confidence;

  @override
  String toString() {
    return 'RecognitionMatch(gesture: $gesture, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognitionMatchImpl &&
            (identical(other.gesture, gesture) || other.gesture == gesture) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gesture, confidence);

  /// Create a copy of RecognitionMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognitionMatchImplCopyWith<_$RecognitionMatchImpl> get copyWith =>
      __$$RecognitionMatchImplCopyWithImpl<_$RecognitionMatchImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecognitionMatchImplToJson(this);
  }
}

abstract class _RecognitionMatch implements RecognitionMatch {
  const factory _RecognitionMatch({
    required final String gesture,
    required final double confidence,
  }) = _$RecognitionMatchImpl;

  factory _RecognitionMatch.fromJson(Map<String, dynamic> json) =
      _$RecognitionMatchImpl.fromJson;

  @override
  String get gesture;
  @override
  double get confidence;

  /// Create a copy of RecognitionMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognitionMatchImplCopyWith<_$RecognitionMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HandLandmark _$HandLandmarkFromJson(Map<String, dynamic> json) {
  return _HandLandmark.fromJson(json);
}

/// @nodoc
mixin _$HandLandmark {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get z => throw _privateConstructorUsedError;
  double get visibility => throw _privateConstructorUsedError;

  /// Serializes this HandLandmark to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HandLandmark
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HandLandmarkCopyWith<HandLandmark> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HandLandmarkCopyWith<$Res> {
  factory $HandLandmarkCopyWith(
    HandLandmark value,
    $Res Function(HandLandmark) then,
  ) = _$HandLandmarkCopyWithImpl<$Res, HandLandmark>;
  @useResult
  $Res call({double x, double y, double z, double visibility});
}

/// @nodoc
class _$HandLandmarkCopyWithImpl<$Res, $Val extends HandLandmark>
    implements $HandLandmarkCopyWith<$Res> {
  _$HandLandmarkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HandLandmark
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? z = null,
    Object? visibility = null,
  }) {
    return _then(
      _value.copyWith(
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            z: null == z
                ? _value.z
                : z // ignore: cast_nullable_to_non_nullable
                      as double,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HandLandmarkImplCopyWith<$Res>
    implements $HandLandmarkCopyWith<$Res> {
  factory _$$HandLandmarkImplCopyWith(
    _$HandLandmarkImpl value,
    $Res Function(_$HandLandmarkImpl) then,
  ) = __$$HandLandmarkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y, double z, double visibility});
}

/// @nodoc
class __$$HandLandmarkImplCopyWithImpl<$Res>
    extends _$HandLandmarkCopyWithImpl<$Res, _$HandLandmarkImpl>
    implements _$$HandLandmarkImplCopyWith<$Res> {
  __$$HandLandmarkImplCopyWithImpl(
    _$HandLandmarkImpl _value,
    $Res Function(_$HandLandmarkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HandLandmark
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? z = null,
    Object? visibility = null,
  }) {
    return _then(
      _$HandLandmarkImpl(
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        z: null == z
            ? _value.z
            : z // ignore: cast_nullable_to_non_nullable
                  as double,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HandLandmarkImpl implements _HandLandmark {
  const _$HandLandmarkImpl({
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  factory _$HandLandmarkImpl.fromJson(Map<String, dynamic> json) =>
      _$$HandLandmarkImplFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  final double z;
  @override
  final double visibility;

  @override
  String toString() {
    return 'HandLandmark(x: $x, y: $y, z: $z, visibility: $visibility)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HandLandmarkImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.z, z) || other.z == z) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, z, visibility);

  /// Create a copy of HandLandmark
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HandLandmarkImplCopyWith<_$HandLandmarkImpl> get copyWith =>
      __$$HandLandmarkImplCopyWithImpl<_$HandLandmarkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HandLandmarkImplToJson(this);
  }
}

abstract class _HandLandmark implements HandLandmark {
  const factory _HandLandmark({
    required final double x,
    required final double y,
    required final double z,
    required final double visibility,
  }) = _$HandLandmarkImpl;

  factory _HandLandmark.fromJson(Map<String, dynamic> json) =
      _$HandLandmarkImpl.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get z;
  @override
  double get visibility;

  /// Create a copy of HandLandmark
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HandLandmarkImplCopyWith<_$HandLandmarkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
