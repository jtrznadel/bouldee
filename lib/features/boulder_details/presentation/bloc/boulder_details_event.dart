part of 'boulder_details_bloc.dart';

sealed class BoulderDetailsEvent extends Equatable {
  const BoulderDetailsEvent();

  @override
  List<Object> get props => [];
}

final class GetBoulderDetailsEvent extends BoulderDetailsEvent {
  const GetBoulderDetailsEvent({
    required this.boulderId,
  });

  final String boulderId;

  @override
  List<Object> get props => [boulderId];
}
