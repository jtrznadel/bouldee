import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/app/utilities/usecase.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:bouldee/features/training_session/domain/repositories/training_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class StartSessionUsecase
    implements UsecaseWithoutParams<TrainingSessionEntity> {
  StartSessionUsecase(this._repository);
  final TrainingSessionRepository _repository;

  @override
  Future<Either<Failure, TrainingSessionEntity>> call() {
    return _repository.startSession();
  }
}
