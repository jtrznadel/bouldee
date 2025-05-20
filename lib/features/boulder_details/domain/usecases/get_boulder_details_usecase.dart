import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/app/utilities/usecase.dart';
import 'package:bouldee/features/boulder_details/domain/entities/boulder_details_entity.dart';
import 'package:bouldee/features/boulder_details/domain/repositories/boulder_details_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBoulderDetailsUsecase
    implements UsecaseWithParams<BoulderDetailsEntity, String> {
  GetBoulderDetailsUsecase(this._repository);
  final BoulderDetailsRepository _repository;

  @override
  Future<Either<Failure, BoulderDetailsEntity>> call(String params) {
    return _repository.getBoulderDetails(boulderId: params);
  }
}
