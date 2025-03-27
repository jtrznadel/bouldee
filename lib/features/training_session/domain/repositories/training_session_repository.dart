import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TrainingSessionRepository {
  Future<Either<Failure, TrainingSessionEntity>> startSession();
  Future<Either<Failure, Unit>> endSession(String sessionId);
  Future<Either<Failure, TrainingSessionEntity>> addBoulder({
    required String sessionId,
    required String boulderId,
  });
  Future<Either<Failure, TrainingSessionEntity>> updateBoulder({
    required String sessionId,
    required BoulderEntity boulder,
  });
  Future<Either<Failure, TrainingSessionEntity?>> getActiveSession();
}
