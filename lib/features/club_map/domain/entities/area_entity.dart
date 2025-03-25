import 'package:equatable/equatable.dart';

class AreaEntity extends Equatable {
  const AreaEntity({
    required this.id,
    required this.clubId,
    required this.label,
    required this.points,
  });
  final String id;
  final String clubId;
  final String label;
  final List<List<double>> points;

  @override
  List<Object?> get props => [id, clubId, label, points];
}
