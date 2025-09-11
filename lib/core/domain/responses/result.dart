import 'package:bingo/core/domain/responses/failure.dart';

class Result<T> {
  final T? value;
  final Failure? error;

  bool get isSuccess => value != null;
  bool get isFailure => error != null;

  Result._({this.value, this.error});

  factory Result.success(T value) => Result._(value: value);
  factory Result.failure(Failure error) => Result._(error: error);
}