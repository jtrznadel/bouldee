import 'package:equatable/equatable.dart';

class BoulderEntity extends Equatable {
  const BoulderEntity({
    required this.id,
    required this.grade,
    required this.x,
    required this.y,
  });

  final String id;
  final String grade;
  final double x;
  final double y;

  @override
  List<Object?> get props => [id, grade, x, y];
}
