part of 'boulder_details_bloc.dart';

sealed class BoulderDetailsState extends Equatable {
  const BoulderDetailsState();

  @override
  List<Object> get props => [];
}

final class BoulderDetailsInitial extends BoulderDetailsState {}

final class BoulderDetailsLoading extends BoulderDetailsState {}

final class BoulderDetailsLoaded extends BoulderDetailsState {
  const BoulderDetailsLoaded(this.boulderDetails);

  final BoulderDetailsEntity boulderDetails;

  @override
  List<Object> get props => [boulderDetails];
}

final class BoulderDetailsError extends BoulderDetailsState {
  const BoulderDetailsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
