part of 'training_session_bloc.dart';

abstract class TrainingSessionState extends Equatable {
  const TrainingSessionState();

  @override
  List<Object?> get props => [];
}

class TrainingSessionInitial extends TrainingSessionState {
  const TrainingSessionInitial();
}

class TrainingSessionLoading extends TrainingSessionState {
  const TrainingSessionLoading();
}

class TrainingSessionError extends TrainingSessionState {
  const TrainingSessionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TrainingSessionInactive extends TrainingSessionState {
  const TrainingSessionInactive();
}

class TrainingSessionActive extends TrainingSessionState {
  const TrainingSessionActive(this.session);

  final TrainingSessionEntity session;

  @override
  List<Object?> get props => [session];
}
