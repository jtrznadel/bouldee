import 'package:bouldee/app/utilities/failure.dart';
import 'package:bouldee/app/utilities/usecase.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:bouldee/features/training_session/domain/repositories/training_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddBoulderUsecase
    implements UsecaseWithParams<TrainingSessionEntity, AddBoulderParams> {
  AddBoulderUsecase(this._repository);
  final TrainingSessionRepository _repository;

  @override
  Future<Either<Failure, TrainingSessionEntity>> call(AddBoulderParams params) {
    return _repository.addBoulder(
      sessionId: params.sessionId,
      boulderId: params.boulderId,
    );
  }
}

class AddBoulderParams extends Equatable {
  const AddBoulderParams({
    required this.sessionId,
    required this.boulderId,
  });

  final String sessionId;
  final String boulderId;

  @override
  List<Object?> get props => [sessionId, boulderId];
}
