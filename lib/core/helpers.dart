import 'package:belks_tube/domain/data_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

Either<DataFailures, R> safeToDomain<R>(
  Either<DataFailures, R> Function() callback, {
  required final Map<String, dynamic>? errors,
  required dynamic items,
}) {
  try {
    if (items == null) {
      return const Left(DataFailures.error('items is null'));
    }
    if (errors == null) {
      return Left(DataFailures.error('errors: ${errors.toString()}'));
    }
    final r = callback.call();
    return r;
  } on Error catch (e) {
    return left(DataFailures.error(e.toString()));
  } on CheckedFromJsonException catch (e) {
    return left(DataFailures.error(e.toString()));
  } on Exception catch (e) {
    return left(DataFailures.error(e.toString()));
  }
}
