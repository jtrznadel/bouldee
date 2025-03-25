import 'package:bouldee/features/club_map/domain/entities/club_map_data_entity.dart';
import 'package:bouldee/features/club_map/domain/repositories/club_map_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetClubMapDataUseCase {
  GetClubMapDataUseCase(this._repository);
  final ClubMapRepository _repository;

  Future<Either<String, ClubMapDataEntity>> call(String clubId) {
    return _repository.getClubMapData(clubId);
  }
}
