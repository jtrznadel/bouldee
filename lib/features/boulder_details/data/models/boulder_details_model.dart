import 'package:bouldee/app/extensions/object_extensions.dart';
import 'package:bouldee/features/boulder_details/domain/entities/boulder_details_entity.dart';

class BoulderDetailsModel extends BoulderDetailsEntity {
  const BoulderDetailsModel({
    required super.id,
    required super.grade,
    required super.x,
    required super.y,
    required super.name,
    required super.setter,
    required super.flash,
    required super.top,
    required super.attemptsAvg,
    super.imageUrl,
    super.rating,
    super.description,
  });

  factory BoulderDetailsModel.fromJson(Map<String, dynamic> json) {
    return BoulderDetailsModel(
      id: json['_id'] as String,
      grade: json['grade'] as String,
      x: (json['x'] as Object).toDouble(),
      y: (json['y'] as Object).toDouble(),
      name: json['name'] as String,
      setter: json['setter_id'] as String,
      flash: (json['flash'] as Object).toDouble(),
      top: (json['top'] as Object).toDouble(),
      attemptsAvg: (json['attempts_avg'] as Object).toDouble(),
      imageUrl: json['image_url'] as String?,
      rating: (json['rating'] as Object?)?.toDouble(),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grade': grade,
      'x': x,
      'y': y,
      'name': name,
      'setter': setter,
      'flash': flash,
      'top': top,
      'attemptsAvg': attemptsAvg,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
    };
  }
}
