import 'package:bloc/bloc.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:bouldee/features/training_session/domain/usecases/add_boulder_usecase.dart';
import 'package:bouldee/features/training_session/domain/usecases/end_session_usecase.dart';
import 'package:bouldee/features/training_session/domain/usecases/get_active_session_usecase.dart';
import 'package:bouldee/features/training_session/domain/usecases/start_session_usecase.dart';
import 'package:bouldee/features/training_session/domain/usecases/update_boulder_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'training_session_event.dart';
part 'training_session_state.dart';

@injectable
class TrainingSessionBloc
    extends Bloc<TrainingSessionEvent, TrainingSessionState> {
  TrainingSessionBloc(
    this._startSession,
    this._endSession,
    this._addBoulder,
    this._updateBoulder,
    this._getActiveSession,
  ) : super(const TrainingSessionInitial()) {
    on<LoadActiveSessionEvent>(_onLoadActiveSession);
    on<StartSessionEvent>(_onStartSession);
    on<EndSessionEvent>(_onEndSession);
    on<AddBoulderEvent>(_onAddBoulder);
    on<UpdateBoulderEvent>(_onUpdateBoulder);
  }

  final StartSessionUsecase _startSession;
  final EndSessionUsecase _endSession;
  final AddBoulderUsecase _addBoulder;
  final UpdateBoulderUsecase _updateBoulder;
  final GetActiveSessionUsecase _getActiveSession;

  Future<void> _onLoadActiveSession(
    LoadActiveSessionEvent event,
    Emitter<TrainingSessionState> emit,
  ) async {
    emit(const TrainingSessionLoading());

    final result = await _getActiveSession();

    result.fold(
      (failure) => emit(TrainingSessionError(failure.message)),
      (session) {
        if (session != null && session.isActive) {
          emit(TrainingSessionActive(session));
        } else {
          emit(const TrainingSessionInactive());
        }
      },
    );
  }

  Future<void> _onStartSession(
    StartSessionEvent event,
    Emitter<TrainingSessionState> emit,
  ) async {
    emit(const TrainingSessionLoading());

    final result = await _startSession();

    result.fold(
      (failure) => emit(TrainingSessionError(failure.message)),
      (session) => emit(TrainingSessionActive(session)),
    );
  }

  Future<void> _onEndSession(
    EndSessionEvent event,
    Emitter<TrainingSessionState> emit,
  ) async {
    emit(const TrainingSessionLoading());

    final result = await _endSession(event.sessionId);

    result.fold(
      (failure) => emit(TrainingSessionError(failure.message)),
      (_) => emit(const TrainingSessionInactive()),
    );
  }

  Future<void> _onAddBoulder(
    AddBoulderEvent event,
    Emitter<TrainingSessionState> emit,
  ) async {
    emit(const TrainingSessionLoading());

    final params = AddBoulderParams(
      sessionId: event.sessionId,
      boulderId: event.boulderId,
    );

    final result = await _addBoulder(params);

    result.fold(
      (failure) => emit(TrainingSessionError(failure.message)),
      (session) => emit(TrainingSessionActive(session)),
    );
  }

  Future<void> _onUpdateBoulder(
    UpdateBoulderEvent event,
    Emitter<TrainingSessionState> emit,
  ) async {
    emit(const TrainingSessionLoading());

    final params = UpdateBoulderParams(
      sessionId: event.sessionId,
      boulder: event.boulder,
    );

    final result = await _updateBoulder(params);

    result.fold(
      (failure) => emit(TrainingSessionError(failure.message)),
      (session) => emit(TrainingSessionActive(session)),
    );
  }
}
