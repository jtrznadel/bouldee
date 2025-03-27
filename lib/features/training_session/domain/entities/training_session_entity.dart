import 'package:equatable/equatable.dart';

enum BoulderStatus { flash, top, project }

class TrainingSessionEntity extends Equatable {
  const TrainingSessionEntity({
    required this.id,
    required this.startTime,
    this.endTime,
    this.isActive = true,
    this.boulders = const [],
    this.deviceId,
    this.pendingSync = false,
  });

  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isActive;
  final List<BoulderEntity> boulders;
  final String? deviceId;
  final bool pendingSync;

  Duration get duration => endTime != null
      ? endTime!.difference(startTime)
      : DateTime.now().difference(startTime);

  @override
  List<Object?> get props =>
      [id, startTime, endTime, isActive, boulders, deviceId, pendingSync];
}

class BoulderEntity extends Equatable {
  const BoulderEntity({
    required this.id,
    required this.sessionId,
    required this.boulderId,
    required this.addedAt,
    this.status = BoulderStatus.project,
    this.attempts = 1,
    this.notes,
    this.pendingSync = false,
  });

  final String id;
  final String sessionId;
  final String boulderId;
  final BoulderStatus status;
  final int attempts;
  final String? notes;
  final DateTime addedAt;
  final bool pendingSync;

  @override
  List<Object?> get props =>
      [id, sessionId, boulderId, status, attempts, notes, addedAt, pendingSync];
}
