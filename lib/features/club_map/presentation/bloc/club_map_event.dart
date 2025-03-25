part of 'club_map_bloc.dart';

sealed class ClubMapEvent extends Equatable {
  const ClubMapEvent();

  @override
  List<Object> get props => [];
}

class LoadClubMapData extends ClubMapEvent {
  const LoadClubMapData({required this.clubId});
  final String clubId;

  @override
  List<Object> get props => [clubId];
}
