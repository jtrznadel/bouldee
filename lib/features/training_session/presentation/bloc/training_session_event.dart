part of 'training_session_bloc.dart';

abstract class TrainingSessionEvent extends Equatable {
  const TrainingSessionEvent();

  @override
  List<Object?> get props => [];
}

class LoadActiveSessionEvent extends TrainingSessionEvent {
  const LoadActiveSessionEvent();
}

class StartSessionEvent extends TrainingSessionEvent {
  const StartSessionEvent();
}

class EndSessionEvent extends TrainingSessionEvent {
  const EndSessionEvent(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => [sessionId];
}

class AddBoulderEvent extends TrainingSessionEvent {
  const AddBoulderEvent({
    required this.sessionId,
    required this.boulderId,
  });

  final String sessionId;
  final String boulderId;

  @override
  List<Object?> get props => [sessionId, boulderId];
}

class UpdateBoulderEvent extends TrainingSessionEvent {
  const UpdateBoulderEvent({
    required this.sessionId,
    required this.boulder,
  });

  final String sessionId;
  final BoulderEntity boulder;

  @override
  List<Object?> get props => [sessionId, boulder];
}
