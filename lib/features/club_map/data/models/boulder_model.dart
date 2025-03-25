import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';

class BoulderModel extends BoulderEntity {
  const BoulderModel({
    required super.id,
    required super.name,
    required super.grade,
    required super.setter,
    required super.x,
    required super.y,
    required super.flash,
    required super.top,
    required super.attemptsAvg,
  });

  factory BoulderModel.fromJson(Map<String, dynamic> json) {
    return BoulderModel(
      id: json['_id'].toString(),
      name: json['name'] as String,
      grade: json['grade'] as String,
      setter: json['setter_id'] as String,
      x: (json['x'] is int)
          ? (json['x'] as int).toDouble()
          : json['x'] as double,
      y: (json['y'] is int)
          ? (json['y'] as int).toDouble()
          : json['y'] as double,
      flash: json['flash'] as int,
      top: json['top'] as int,
      attemptsAvg: (json['attempts_avg'] is int)
          ? (json['attempts_avg'] as int).toDouble()
          : json['attempts_avg'] as double,
    );
  }
}
