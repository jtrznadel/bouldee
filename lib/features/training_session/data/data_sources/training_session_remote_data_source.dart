import 'dart:io';

import 'package:bouldee/features/training_session/data/models/training_session_model.dart';
import 'package:bouldee/features/training_session/domain/entities/training_session_entity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TrainingSessionRemoteDataSource {
  Future<TrainingSessionModel> startSession();
  Future<void> endSession(String sessionId);
  Future<TrainingSessionModel> addBoulder({
    required String sessionId,
    required String boulderId,
  });
  Future<TrainingSessionModel> updateBoulder({
    required String sessionId,
    required BoulderModel boulder,
  });
  Future<TrainingSessionModel?> getActiveSession();
  Future<TrainingSessionModel> getSessionById(String sessionId);
  Future<void> createSession(TrainingSessionModel session);
  Future<void> updateSession(TrainingSessionModel session);
}

@Injectable(as: TrainingSessionRemoteDataSource)
class TrainingSessionRemoteDataSourceImpl
    implements TrainingSessionRemoteDataSource {
  TrainingSessionRemoteDataSourceImpl(this._supabaseClient);
  final SupabaseClient _supabaseClient;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> _getDeviceId() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return info.id;
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return info.identifierForVendor ?? 'unknown_ios';
    }
    return 'unknown_device';
  }

  @override
  Future<TrainingSessionModel> startSession() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final deviceId = await _getDeviceId();
    final utcNow = DateTime.now().toUtc();

    final response = await _supabaseClient
        .from('sessions')
        .insert({
          'user_id': userId,
          'device_id': deviceId,
          'is_active': true,
          'pending_sync': false,
          'start_time': utcNow.toIso8601String(),
        })
        .select()
        .single();
    print('Response: $response');
    return TrainingSessionModel.fromJson(response);
  }

  @override
  Future<void> endSession(String sessionId) async {
    await _supabaseClient.from('sessions').update({
      'is_active': false,
      'end_time': DateTime.now().toUtc().toIso8601String(), // UTC czas
    }).eq('_id', sessionId);
  }

  @override
  Future<TrainingSessionModel> addBoulder({
    required String sessionId,
    required String boulderId,
  }) async {
    await _supabaseClient.from('session_boulders').insert({
      'session_id': sessionId,
      'boulder_id': boulderId,
      'status': BoulderStatus.project.toString().split('.').last,
      'attempts': 1,
      'pending_sync': false,
    });

    return getSessionById(sessionId);
  }

  @override
  Future<TrainingSessionModel> updateBoulder({
    required String sessionId,
    required BoulderModel boulder,
  }) async {
    await _supabaseClient.from('session_boulders').update({
      'status': boulder.status.toString().split('.').last,
      'attempts': boulder.attempts,
      'notes': boulder.notes,
    }).eq('id', boulder.id);

    return getSessionById(sessionId);
  }

  @override
  Future<TrainingSessionModel?> getActiveSession() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabaseClient
        .from('sessions')
        .select('*, session_boulders!inner(*)')
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('start_time', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    return TrainingSessionModel.fromJson(response);
  }

  @override
  Future<TrainingSessionModel> getSessionById(String sessionId) async {
    final response = await _supabaseClient
        .from('sessions')
        .select('*, session_boulders(*)')
        .eq('_id', sessionId)
        .single();

    return TrainingSessionModel.fromJson(response);
  }

  @override
  Future<void> createSession(TrainingSessionModel session) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _supabaseClient.from('sessions').insert({
      '_id': session.id,
      'user_id': userId,
      'start_time': session.startTime.toUtc().toIso8601String(), // UTC
      'end_time': session.endTime?.toUtc().toIso8601String(), // UTC
      'is_active': session.isActive,
      'device_id': session.deviceId,
      'pending_sync': false,
    });

    for (final boulder in session.boulders) {
      final boulderModel = boulder as BoulderModel;
      await _supabaseClient.from('session_boulders').insert({
        '_id': boulderModel.id,
        'session_id': session.id,
        'boulder_id': boulderModel.boulderId,
        'status': boulderModel.status.toString().split('.').last,
        'attempts': boulderModel.attempts,
        'notes': boulderModel.notes,
        'created_at': boulderModel.addedAt.toIso8601String(),
        'pending_sync': false,
      });
    }
  }

  @override
  Future<void> updateSession(TrainingSessionModel session) async {
    await _supabaseClient.from('sessions').update({
      'start_time': session.startTime.toUtc().toIso8601String(), // UTC
      'end_time': session.endTime?.toUtc().toIso8601String(), // UTC
      'is_active': session.isActive,
      'device_id': session.deviceId,
      'pending_sync': false,
    }).eq('_id', session.id);

    for (final boulder in session.boulders) {
      final boulderModel = boulder as BoulderModel;

      final existingBoulder = await _supabaseClient
          .from('session_boulders')
          .select()
          .eq('id', boulderModel.id)
          .maybeSingle();

      if (existingBoulder != null) {
        await _supabaseClient.from('session_boulders').update({
          'status': boulderModel.status.toString().split('.').last,
          'attempts': boulderModel.attempts,
          'notes': boulderModel.notes,
          'pending_sync': false,
        }).eq('_id', boulderModel.id);
      } else {
        await _supabaseClient.from('session_boulders').insert({
          '_id': boulderModel.id,
          'session_id': session.id,
          'boulder_id': boulderModel.boulderId,
          'status': boulderModel.status.toString().split('.').last,
          'attempts': boulderModel.attempts,
          'notes': boulderModel.notes,
          'created_at': boulderModel.addedAt.toIso8601String(),
          'pending_sync': false,
        });
      }
    }
  }
}
