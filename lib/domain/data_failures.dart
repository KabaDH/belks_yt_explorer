import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_failures.freezed.dart';

@freezed
class DataFailures<T> with _$DataFailures<T> {
  const factory DataFailures.error(String? failedValue) =
      CommonError<T>;
}
