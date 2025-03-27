import 'package:bouldee/features/club_map/data/data_sources/club_map_remote_data_source.dart';
import 'package:bouldee/features/club_map/domain/entities/club_map_data_entity.dart';
import 'package:bouldee/features/club_map/domain/repositories/club_map_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ClubMapRepository)
class ClubMapRepositoryImpl implements ClubMapRepository {
  ClubMapRepositoryImpl(this._remoteDataSource);
  final ClubMapRemoteDataSource _remoteDataSource;

  @override
  Future<Either<String, ClubMapDataEntity>> getClubMapData(String clubId) {
    return _remoteDataSource.getClubMapData(clubId);
  }
}
