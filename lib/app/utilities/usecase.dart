import 'package:bouldee/app/utilities/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();

  Future<Either<Failure, Type>> call(Params params);
}

abstract class UsecaseWithoutParams<Type> {
  const UsecaseWithoutParams();

  Future<Either<Failure, Type>> call();
}
