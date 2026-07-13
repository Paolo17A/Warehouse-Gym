// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutData {
  List<WorkoutPrescription> get prescriptions =>
      throw _privateConstructorUsedError;
  List<WorkoutSession> get history => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutDataCopyWith<WorkoutData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutDataCopyWith<$Res> {
  factory $WorkoutDataCopyWith(
          WorkoutData value, $Res Function(WorkoutData) then) =
      _$WorkoutDataCopyWithImpl<$Res, WorkoutData>;
  @useResult
  $Res call(
      {List<WorkoutPrescription> prescriptions, List<WorkoutSession> history});
}

/// @nodoc
class _$WorkoutDataCopyWithImpl<$Res, $Val extends WorkoutData>
    implements $WorkoutDataCopyWith<$Res> {
  _$WorkoutDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prescriptions = null,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      prescriptions: null == prescriptions
          ? _value.prescriptions
          : prescriptions // ignore: cast_nullable_to_non_nullable
              as List<WorkoutPrescription>,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSession>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutDataImplCopyWith<$Res>
    implements $WorkoutDataCopyWith<$Res> {
  factory _$$WorkoutDataImplCopyWith(
          _$WorkoutDataImpl value, $Res Function(_$WorkoutDataImpl) then) =
      __$$WorkoutDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WorkoutPrescription> prescriptions, List<WorkoutSession> history});
}

/// @nodoc
class __$$WorkoutDataImplCopyWithImpl<$Res>
    extends _$WorkoutDataCopyWithImpl<$Res, _$WorkoutDataImpl>
    implements _$$WorkoutDataImplCopyWith<$Res> {
  __$$WorkoutDataImplCopyWithImpl(
      _$WorkoutDataImpl _value, $Res Function(_$WorkoutDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prescriptions = null,
    Object? history = null,
  }) {
    return _then(_$WorkoutDataImpl(
      prescriptions: null == prescriptions
          ? _value._prescriptions
          : prescriptions // ignore: cast_nullable_to_non_nullable
              as List<WorkoutPrescription>,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSession>,
    ));
  }
}

/// @nodoc

class _$WorkoutDataImpl implements _WorkoutData {
  const _$WorkoutDataImpl(
      {final List<WorkoutPrescription> prescriptions = const [],
      final List<WorkoutSession> history = const []})
      : _prescriptions = prescriptions,
        _history = history;

  final List<WorkoutPrescription> _prescriptions;
  @override
  @JsonKey()
  List<WorkoutPrescription> get prescriptions {
    if (_prescriptions is EqualUnmodifiableListView) return _prescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prescriptions);
  }

  final List<WorkoutSession> _history;
  @override
  @JsonKey()
  List<WorkoutSession> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'WorkoutData(prescriptions: $prescriptions, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutDataImpl &&
            const DeepCollectionEquality()
                .equals(other._prescriptions, _prescriptions) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_prescriptions),
      const DeepCollectionEquality().hash(_history));

  /// Create a copy of WorkoutData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutDataImplCopyWith<_$WorkoutDataImpl> get copyWith =>
      __$$WorkoutDataImplCopyWithImpl<_$WorkoutDataImpl>(this, _$identity);
}

abstract class _WorkoutData implements WorkoutData {
  const factory _WorkoutData(
      {final List<WorkoutPrescription> prescriptions,
      final List<WorkoutSession> history}) = _$WorkoutDataImpl;

  @override
  List<WorkoutPrescription> get prescriptions;
  @override
  List<WorkoutSession> get history;

  /// Create a copy of WorkoutData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutDataImplCopyWith<_$WorkoutDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WorkoutState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutStateCopyWith<$Res> {
  factory $WorkoutStateCopyWith(
          WorkoutState value, $Res Function(WorkoutState) then) =
      _$WorkoutStateCopyWithImpl<$Res, WorkoutState>;
}

/// @nodoc
class _$WorkoutStateCopyWithImpl<$Res, $Val extends WorkoutState>
    implements $WorkoutStateCopyWith<$Res> {
  _$WorkoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'WorkoutState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements WorkoutState {
  const factory Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'WorkoutState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements WorkoutState {
  const factory Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$RefreshingImplCopyWith<$Res> {
  factory _$$RefreshingImplCopyWith(
          _$RefreshingImpl value, $Res Function(_$RefreshingImpl) then) =
      __$$RefreshingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WorkoutData data});

  $WorkoutDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$RefreshingImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$RefreshingImpl>
    implements _$$RefreshingImplCopyWith<$Res> {
  __$$RefreshingImplCopyWithImpl(
      _$RefreshingImpl _value, $Res Function(_$RefreshingImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$RefreshingImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as WorkoutData,
    ));
  }

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutDataCopyWith<$Res> get data {
    return $WorkoutDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$RefreshingImpl implements Refreshing {
  const _$RefreshingImpl(this.data);

  @override
  final WorkoutData data;

  @override
  String toString() {
    return 'WorkoutState.refreshing(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshingImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshingImplCopyWith<_$RefreshingImpl> get copyWith =>
      __$$RefreshingImplCopyWithImpl<_$RefreshingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) {
    return refreshing(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) {
    return refreshing?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (refreshing != null) {
      return refreshing(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) {
    return refreshing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) {
    return refreshing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (refreshing != null) {
      return refreshing(this);
    }
    return orElse();
  }
}

abstract class Refreshing implements WorkoutState {
  const factory Refreshing(final WorkoutData data) = _$RefreshingImpl;

  WorkoutData get data;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshingImplCopyWith<_$RefreshingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WorkoutData data});

  $WorkoutDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$LoadedImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as WorkoutData,
    ));
  }

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutDataCopyWith<$Res> get data {
    return $WorkoutDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$LoadedImpl implements Loaded {
  const _$LoadedImpl(this.data);

  @override
  final WorkoutData data;

  @override
  String toString() {
    return 'WorkoutState.loaded(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class Loaded implements WorkoutState {
  const factory Loaded(final WorkoutData data) = _$LoadedImpl;

  WorkoutData get data;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubmittingImplCopyWith<$Res> {
  factory _$$SubmittingImplCopyWith(
          _$SubmittingImpl value, $Res Function(_$SubmittingImpl) then) =
      __$$SubmittingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WorkoutData data});

  $WorkoutDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$SubmittingImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$SubmittingImpl>
    implements _$$SubmittingImplCopyWith<$Res> {
  __$$SubmittingImplCopyWithImpl(
      _$SubmittingImpl _value, $Res Function(_$SubmittingImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SubmittingImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as WorkoutData,
    ));
  }

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutDataCopyWith<$Res> get data {
    return $WorkoutDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SubmittingImpl implements Submitting {
  const _$SubmittingImpl(this.data);

  @override
  final WorkoutData data;

  @override
  String toString() {
    return 'WorkoutState.submitting(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmittingImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmittingImplCopyWith<_$SubmittingImpl> get copyWith =>
      __$$SubmittingImplCopyWithImpl<_$SubmittingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) {
    return submitting(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) {
    return submitting?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (submitting != null) {
      return submitting(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) {
    return submitting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) {
    return submitting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (submitting != null) {
      return submitting(this);
    }
    return orElse();
  }
}

abstract class Submitting implements WorkoutState {
  const factory Submitting(final WorkoutData data) = _$SubmittingImpl;

  WorkoutData get data;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmittingImplCopyWith<_$SubmittingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailedImplCopyWith<$Res> {
  factory _$$FailedImplCopyWith(
          _$FailedImpl value, $Res Function(_$FailedImpl) then) =
      __$$FailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});
}

/// @nodoc
class __$$FailedImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$FailedImpl>
    implements _$$FailedImplCopyWith<$Res> {
  __$$FailedImplCopyWithImpl(
      _$FailedImpl _value, $Res Function(_$FailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$FailedImpl(
      null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$FailedImpl implements Failed {
  const _$FailedImpl(this.failure);

  @override
  final Failure failure;

  @override
  String toString() {
    return 'WorkoutState.failed(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      __$$FailedImplCopyWithImpl<_$FailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(WorkoutData data) refreshing,
    required TResult Function(WorkoutData data) loaded,
    required TResult Function(WorkoutData data) submitting,
    required TResult Function(Failure failure) failed,
  }) {
    return failed(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(WorkoutData data)? refreshing,
    TResult? Function(WorkoutData data)? loaded,
    TResult? Function(WorkoutData data)? submitting,
    TResult? Function(Failure failure)? failed,
  }) {
    return failed?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(WorkoutData data)? refreshing,
    TResult Function(WorkoutData data)? loaded,
    TResult Function(WorkoutData data)? submitting,
    TResult Function(Failure failure)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Refreshing value) refreshing,
    required TResult Function(Loaded value) loaded,
    required TResult Function(Submitting value) submitting,
    required TResult Function(Failed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Refreshing value)? refreshing,
    TResult? Function(Loaded value)? loaded,
    TResult? Function(Submitting value)? submitting,
    TResult? Function(Failed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Refreshing value)? refreshing,
    TResult Function(Loaded value)? loaded,
    TResult Function(Submitting value)? submitting,
    TResult Function(Failed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class Failed implements WorkoutState {
  const factory Failed(final Failure failure) = _$FailedImpl;

  Failure get failure;

  /// Create a copy of WorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
