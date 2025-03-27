import 'dart:async';
import 'package:bouldee/app/utilities/failure.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bouldee/features/training_session/data/data_sources/training_session_local_data_source.dart';
import 'package:bouldee/features/training_session/data/data_sources/training_session_remote_data_source.dart';
import 'package:bouldee/features/training_session/data/models/training_session_model.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:bouldee/features/training_session/domain/repositories/training_session_repository.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: TrainingSessionRepository)
class TrainingSessionRepositoryImpl implements TrainingSessionRepository {
  TrainingSessionRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  ) {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _isOnline = results.any((result) => result != ConnectivityResult.none);

      if (_isOnline) {
        _syncPendingSessions();
      }
    });

    _connectivity.checkConnectivity().then((List<ConnectivityResult> results) {
      _isOnline = results.any((result) => result != ConnectivityResult.none);

      if (_isOnline) {
        _syncPendingSessions();
      }
    });
  }
  final TrainingSessionRemoteDataSource _remoteDataSource;
  final TrainingSessionLocalDataSource _localDataSource;
  final Connectivity _connectivity;
  final Uuid _uuid = const Uuid();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;

  Future<void> _syncPendingSessions() async {
    try {
      final pendingSessions = await _localDataSource.getPendingSyncSessions();

      for (var session in pendingSessions) {
        try {
          final sessionExists = await _checkSessionExists(session.id);

          if (sessionExists) {
            await _remoteDataSource.updateSession(session);
          } else {
            await _remoteDataSource.createSession(session);
          }

          session = TrainingSessionModel(
            id: session.id,
            startTime: session.startTime,
            endTime: session.endTime,
            isActive: session.isActive,
            deviceId: session.deviceId,
            boulders: session.boulders.map((b) {
              final boulder = b as BoulderModel;
              return BoulderModel(
                id: boulder.id,
                sessionId: boulder.sessionId,
                boulderId: boulder.boulderId,
                addedAt: boulder.addedAt,
                status: boulder.status,
                attempts: boulder.attempts,
                notes: boulder.notes,
              );
            }).toList(),
          );

          await _localDataSource.cacheSession(session);
        } catch (e) {
          print('Error syncing session ${session.id}: $e');
        }
      }
    } catch (e) {
      print('Error during sync: $e');
    }
  }

  Future<bool> _checkSessionExists(String sessionId) async {
    try {
      await _remoteDataSource.getSessionById(sessionId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<ServerFailure, TrainingSessionEntity>> startSession() async {
    try {
      if (_isOnline) {
        final remoteSession = await _remoteDataSource.startSession();
        print('Remote session: $remoteSession');
        await _localDataSource.cacheSession(remoteSession);
        return Right(remoteSession);
      } else {
        final sessionId = _uuid.v4();
        final now = DateTime.now();
        final deviceId =
            'device_local_${DateTime.now().microsecondsSinceEpoch}';

        final newSession = TrainingSessionModel(
          id: sessionId,
          startTime: now,
          deviceId: deviceId,
          pendingSync: true,
        );

        await _localDataSource.cacheSession(newSession);
        return Right(newSession);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to start session: $e'));
    }
  }

  @override
  Future<Either<ServerFailure, Unit>> endSession(String sessionId) async {
    try {
      final session = await _localDataSource.getSessionById(sessionId);

      final updatedSession = TrainingSessionModel(
        id: session.id,
        startTime: session.startTime,
        endTime: DateTime.now(),
        isActive: false,
        deviceId: session.deviceId,
        pendingSync: !_isOnline || session.pendingSync,
        boulders: session.boulders,
      );

      await _localDataSource.cacheSession(updatedSession);

      if (_isOnline) {
        await _remoteDataSource.endSession(sessionId);
      }

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure('Failed to end session: $e'));
    }
  }

  @override
  Future<Either<ServerFailure, TrainingSessionEntity>> addBoulder({
    required String sessionId,
    required String boulderId,
  }) async {
    try {
      if (_isOnline) {
        final updatedSession = await _remoteDataSource.addBoulder(
          sessionId: sessionId,
          boulderId: boulderId,
        );
        await _localDataSource.cacheSession(updatedSession);
        return Right(updatedSession);
      } else {
        final session = await _localDataSource.getSessionById(sessionId);

        final newBoulderId = _uuid.v4();
        final now = DateTime.now();

        final newBoulder = BoulderModel(
          id: newBoulderId,
          sessionId: sessionId,
          boulderId: boulderId,
          addedAt: now,
          pendingSync: true,
        );

        final updatedBoulders = [...session.boulders, newBoulder];

        final updatedSession = TrainingSessionModel(
          id: session.id,
          startTime: session.startTime,
          endTime: session.endTime,
          isActive: session.isActive,
          deviceId: session.deviceId,
          pendingSync: true,
          boulders: updatedBoulders,
        );

        await _localDataSource.cacheSession(updatedSession);
        return Right(updatedSession);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to add boulder: $e'));
    }
  }

  @override
  Future<Either<ServerFailure, TrainingSessionEntity>> updateBoulder({
    required String sessionId,
    required BoulderEntity boulder,
  }) async {
    try {
      if (_isOnline) {
        final updatedSession = await _remoteDataSource.updateBoulder(
          sessionId: sessionId,
          boulder: boulder as BoulderModel,
        );
        await _localDataSource.cacheSession(updatedSession);
        return Right(updatedSession);
      } else {
        final session = await _localDataSource.getSessionById(sessionId);

        final updatedBoulders = session.boulders.map((b) {
          if (b.id == boulder.id) {
            return BoulderModel(
              id: boulder.id,
              sessionId: boulder.sessionId,
              boulderId: boulder.boulderId,
              addedAt: boulder.addedAt,
              status: boulder.status,
              attempts: boulder.attempts,
              notes: boulder.notes,
              pendingSync: true,
            );
          }
          return b;
        }).toList();

        final updatedSession = TrainingSessionModel(
          id: session.id,
          startTime: session.startTime,
          endTime: session.endTime,
          isActive: session.isActive,
          deviceId: session.deviceId,
          pendingSync: true,
          boulders: updatedBoulders,
        );

        await _localDataSource.cacheSession(updatedSession);
        return Right(updatedSession);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to update boulder: $e'));
    }
  }

  @override
  Future<Either<ServerFailure, TrainingSessionEntity?>>
      getActiveSession() async {
    try {
      TrainingSessionModel? session;

      session = await _localDataSource.getActiveSession();

      if (_isOnline) {
        try {
          final remoteSession = await _remoteDataSource.getActiveSession();

          if (remoteSession != null) {
            await _localDataSource.cacheSession(remoteSession);
            session = remoteSession;
          }
        } catch (e) {
          print('Failed to get remote session: $e');
        }
      }

      return Right(session);
    } catch (e) {
      return Left(ServerFailure('Failed to get active session: $e'));
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
