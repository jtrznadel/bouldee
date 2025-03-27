import 'package:bouldee/features/club_map/domain/entities/club_map_data_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ClubMapRepository {
  Future<Either<String, ClubMapDataEntity>> getClubMapData(String clubId);
}
