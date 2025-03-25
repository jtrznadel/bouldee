import 'package:bouldee/features/club_map/domain/entities/area_entity.dart';
import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';
import 'package:equatable/equatable.dart';

class ClubMapDataEntity extends Equatable {
  const ClubMapDataEntity({
    required this.areas,
    required this.boulders,
  });

  final List<AreaEntity> areas;
  final List<BoulderEntity> boulders;

  @override
  List<Object> get props => [areas, boulders];
}
