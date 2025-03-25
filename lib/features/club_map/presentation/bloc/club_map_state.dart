part of 'club_map_bloc.dart';

sealed class ClubMapState extends Equatable {
  const ClubMapState();

  @override
  List<Object> get props => [];
}

final class ClubMapInitial extends ClubMapState {}

final class ClubMapLoading extends ClubMapState {}

final class ClubMapLoaded extends ClubMapState {
  const ClubMapLoaded({
    required this.areas,
    required this.boulders,
  });
  final List<AreaEntity> areas;
  final List<BoulderEntity> boulders;

  @override
  List<Object> get props => [areas, boulders];
}

final class AreaError extends ClubMapState {
  const AreaError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
