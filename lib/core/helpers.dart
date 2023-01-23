import 'package:belks_tube/domain/data_failures/data_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
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
    if (errors != null) {
      return Left(DataFailures.error('errors: ${errors.toString()}'));
    }
    final r = callback.call();
    return r;
  } on Error catch (e) {
    return left(DataFailures.error('Error: ${e.toString()}'));
  } on CheckedFromJsonException catch (e) {
    return left(
        DataFailures.error('CheckedFromJsonException: ${e.toString()}'));
  } on Exception catch (e) {
    return left(DataFailures.error('Exception: ${e.toString()}'));
  }
}

mixin RepositoryImplMixin {
  Future<Either<DataFailures, R>> safeFunc<R>(
      Future<Either<DataFailures, R>> Function() f) async {
    try {
      final r = await f.call();
      return r;
    } on Error catch (e) {
      return left(DataFailures.error('safeFunc Error ${e.toString()}'));
    } on Exception catch (e) {
      return left(DataFailures.error('safeFunc Exception ${e.toString()}'));
    }
  }
}

void printError(String method, String variable, DataFailures l) {
  debugPrint('💡$method :: $variable is Left :'
      ' ${l.failedValue}');
}
