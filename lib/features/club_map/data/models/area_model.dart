import 'package:bouldee/features/club_map/domain/entities/area_entity.dart';

class AreaModel extends AreaEntity {
  const AreaModel({
    required super.id,
    required super.clubId,
    required super.label,
    required super.points,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'].toString(),
      clubId: json['club_id'].toString(),
      label: json['label'].toString(),
      points: (json['points'] as List<dynamic>)
          .map(
            (point) => (point as List<dynamic>)
                .map((coord) => (coord as num).toDouble())
                .toList(),
          )
          .toList(),
    );
  }
}
