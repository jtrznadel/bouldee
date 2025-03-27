import 'package:bouldee/app/extensions/dynamic_extensions.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';

class TrainingSessionModel extends TrainingSessionEntity {
  const TrainingSessionModel({
    required super.id,
    required super.startTime,
    super.endTime,
    super.isActive,
    super.boulders,
    super.deviceId,
    super.pendingSync,
  });

  factory TrainingSessionModel.fromMap(Map<String, dynamic> map) {
    return TrainingSessionModel(
      id: map['id'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: map['end_time'] != null
          ? DateTime.parse(map['end_time'] as String)
          : null,
      isActive: map['is_active'] == 1,
      deviceId: map['device_id'] as String?,
      pendingSync: map['pending_sync'] == 1,
    );
  }

  factory TrainingSessionModel.fromJson(Map<String, dynamic> json) {
    return TrainingSessionModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      isActive: json['is_active'] as bool,
      deviceId: json['device_id'] as String?,
      pendingSync: json['pending_sync'] as bool? ?? false,
      boulders: json['session_boulders'] != null
          ? (json['session_boulders'] as List)
              .map(
                (boulder) =>
                    BoulderModel.fromJson(boulder as Map<String, dynamic>),
              )
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'is_active': isActive,
      'device_id': deviceId,
      'pending_sync': pendingSync,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'device_id': deviceId,
      'pending_sync': pendingSync ? 1 : 0,
    };
  }
}

class BoulderModel extends BoulderEntity {
  const BoulderModel({
    required super.id,
    required super.sessionId,
    required super.boulderId,
    required super.addedAt,
    super.status,
    super.attempts,
    super.notes,
    super.pendingSync,
  });

  factory BoulderModel.fromMap(Map<String, dynamic> map) {
    return BoulderModel(
      id: map['id'] as String,
      sessionId: map['session_id'] as String,
      boulderId: map['boulder_id'] as String,
      addedAt: DateTime.parse(map['created_at'] as String),
      status: (map['status'] as Object).toEnum(BoulderStatus.values),
      attempts: map['attempts'] as int,
      notes: map['notes'] as String?,
      pendingSync: map['pending_sync'] == 1,
    );
  }

  factory BoulderModel.fromJson(Map<String, dynamic> json) {
    return BoulderModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      boulderId: json['boulder_id'] as String,
      addedAt: DateTime.parse(json['created_at'] as String),
      status: (json['status'] as Object).toEnum(BoulderStatus.values),
      attempts: json['attempts'] as int,
      notes: json['notes'] as String?,
      pendingSync: json['pending_sync'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'boulder_id': boulderId,
      'created_at': addedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'attempts': attempts,
      'notes': notes,
      'pending_sync': pendingSync,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'boulder_id': boulderId,
      'created_at': addedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'attempts': attempts,
      'notes': notes,
      'pending_sync': pendingSync ? 1 : 0,
    };
  }
}
