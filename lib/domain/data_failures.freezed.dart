// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DataFailures<T> {
  String? get failedValue => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? failedValue) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? failedValue)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? failedValue)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataFailuresCopyWith<T, DataFailures<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataFailuresCopyWith<T, $Res> {
  factory $DataFailuresCopyWith(
          DataFailures<T> value, $Res Function(DataFailures<T>) then) =
      _$DataFailuresCopyWithImpl<T, $Res, DataFailures<T>>;
  @useResult
  $Res call({String? failedValue});
}

/// @nodoc
class _$DataFailuresCopyWithImpl<T, $Res, $Val extends DataFailures<T>>
    implements $DataFailuresCopyWith<T, $Res> {
  _$DataFailuresCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_value.copyWith(
      failedValue: freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonErrorCopyWith<T, $Res>
    implements $DataFailuresCopyWith<T, $Res> {
  factory _$$CommonErrorCopyWith(
          _$CommonError<T> value, $Res Function(_$CommonError<T>) then) =
      __$$CommonErrorCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String? failedValue});
}

/// @nodoc
class __$$CommonErrorCopyWithImpl<T, $Res>
    extends _$DataFailuresCopyWithImpl<T, $Res, _$CommonError<T>>
    implements _$$CommonErrorCopyWith<T, $Res> {
  __$$CommonErrorCopyWithImpl(
      _$CommonError<T> _value, $Res Function(_$CommonError<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failedValue = freezed,
  }) {
    return _then(_$CommonError<T>(
      freezed == failedValue
          ? _value.failedValue
          : failedValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CommonError<T> implements CommonError<T> {
  const _$CommonError(this.failedValue);

  @override
  final String? failedValue;

  @override
  String toString() {
    return 'DataFailures<$T>.error(failedValue: $failedValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonError<T> &&
            (identical(other.failedValue, failedValue) ||
                other.failedValue == failedValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failedValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonErrorCopyWith<T, _$CommonError<T>> get copyWith =>
      __$$CommonErrorCopyWithImpl<T, _$CommonError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? failedValue) error,
  }) {
    return error(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? failedValue)? error,
  }) {
    return error?.call(failedValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? failedValue)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failedValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommonError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommonError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommonError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CommonError<T> implements DataFailures<T> {
  const factory CommonError(final String? failedValue) = _$CommonError<T>;

  @override
  String? get failedValue;
  @override
  @JsonKey(ignore: true)
  _$$CommonErrorCopyWith<T, _$CommonError<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
