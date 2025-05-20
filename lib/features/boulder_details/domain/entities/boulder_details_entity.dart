import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';

class BoulderDetailsEntity extends BoulderEntity {
  const BoulderDetailsEntity({
    required this.name,
    required this.setter,
    required this.flash,
    required this.top,
    required this.attemptsAvg,
    required super.id,
    required super.grade,
    required super.x,
    required super.y,
    this.imageUrl,
    this.rating,
    this.description,
  });

  final String name;
  final String setter;
  final double flash;
  final double top;
  final double attemptsAvg;
  final String? imageUrl;
  final double? rating;
  final String? description;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        setter,
        flash,
        top,
        attemptsAvg,
        imageUrl,
        rating,
        description,
      ];
}
