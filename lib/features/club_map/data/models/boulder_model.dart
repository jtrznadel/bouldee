import 'package:bouldee/app/extensions/object_extensions.dart';
import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';

class BoulderModel extends BoulderEntity {
  const BoulderModel({
    required super.id,
    required super.grade,
    required super.x,
    required super.y,
  });

  factory BoulderModel.fromJson(Map<String, dynamic> json) {
    return BoulderModel(
      id: json['_id'].toString(),
      grade: json['grade'] as String,
      x: (json['x'] as Object).toDouble(),
      y: (json['y'] as Object).toDouble(),
    );
  }
}
