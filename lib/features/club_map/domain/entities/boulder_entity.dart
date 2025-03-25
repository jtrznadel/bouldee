import 'package:equatable/equatable.dart';

class BoulderEntity extends Equatable {
  const BoulderEntity({
    required this.id,
    required this.name,
    required this.grade,
    required this.setter,
    required this.x,
    required this.y,
    required this.flash,
    required this.top,
    required this.attemptsAvg,
  });

  final String id;
  final String name;
  final String grade;
  final String setter;
  final double x;
  final double y;
  final int flash;
  final int top;
  final double attemptsAvg;

  @override
  List<Object?> get props =>
      [id, name, grade, setter, x, y, flash, top, attemptsAvg];
}
