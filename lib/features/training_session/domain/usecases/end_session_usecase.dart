import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/app/utilities/usecase.dart';
import 'package:bouldee/features/training_session/domain/repositories/training_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class EndSessionUsecase implements UsecaseWithParams<Unit, String> {
  EndSessionUsecase(this._repository);
  final TrainingSessionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String sessionId) {
    return _repository.endSession(sessionId);
  }
}
