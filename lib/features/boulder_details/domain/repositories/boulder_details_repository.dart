import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/features/boulder_details/domain/entities/boulder_details_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BoulderDetailsRepository {
  Future<Either<Failure, BoulderDetailsEntity>> getBoulderDetails({
    required String boulderId,
  });
}
