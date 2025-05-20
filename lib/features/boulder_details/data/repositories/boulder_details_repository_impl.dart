import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/features/boulder_details/data/data_sources/boulder_details_remote_data_source.dart';
import 'package:bouldee/features/boulder_details/domain/entities/boulder_details_entity.dart';
import 'package:bouldee/features/boulder_details/domain/repositories/boulder_details_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BoulderDetailsRepository)
class BoulderDetailsRepositoryImpl implements BoulderDetailsRepository {
  BoulderDetailsRepositoryImpl(this._remoteDataSource);
  final BoulderDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, BoulderDetailsEntity>> getBoulderDetails({
    required String boulderId,
  }) async {
    try {
      final boulderDetails = await _remoteDataSource.getBoulderDetails(
        boulderId: boulderId,
      );
      return Right(boulderDetails);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
