import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/app/utilities/usecase.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:bouldee/features/training_session/domain/repositories/training_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateBoulderUsecase
    implements UsecaseWithParams<TrainingSessionEntity, UpdateBoulderParams> {
  UpdateBoulderUsecase(this._repository);
  final TrainingSessionRepository _repository;

  @override
  Future<Either<Failure, TrainingSessionEntity>> call(
    UpdateBoulderParams params,
  ) {
    return _repository.updateBoulder(
      sessionId: params.sessionId,
      boulder: params.boulder,
    );
  }
}

class UpdateBoulderParams extends Equatable {
  const UpdateBoulderParams({
    required this.sessionId,
    required this.boulder,
  });

  final String sessionId;
  final BoulderEntity boulder;

  @override
  List<Object?> get props => [sessionId, boulder];
}
