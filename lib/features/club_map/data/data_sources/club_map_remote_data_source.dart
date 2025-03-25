import 'package:bouldee/features/club_map/data/models/area_model.dart';
import 'package:bouldee/features/club_map/data/models/boulder_model.dart';
import 'package:bouldee/features/club_map/domain/entities/club_map_data_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ClubMapRemoteDataSource {
  Future<Either<String, ClubMapDataEntity>> getClubMapData(String clubId);
}

@Injectable(as: ClubMapRemoteDataSource)
class ClubMapRemoteDataSourceImpl implements ClubMapRemoteDataSource {
  ClubMapRemoteDataSourceImpl(this._supabase);
  final SupabaseClient _supabase;

  @override
  Future<Either<String, ClubMapDataEntity>> getClubMapData(
    String clubId,
  ) async {
    try {
      final areasResponseFuture =
          _supabase.from('areas').select().eq('club_id', clubId);
      final bouldersResponseFuture =
          _supabase.from('boulders').select().eq('club_id', clubId);

      final responses =
          await Future.wait([areasResponseFuture, bouldersResponseFuture]);

      final List<dynamic> areasData = responses[0];
      final areas = areasData
          .map((json) => AreaModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final List<dynamic> bouldersData = responses[1];
      final boulders = bouldersData
          .map((json) => BoulderModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(
        ClubMapDataEntity(
          areas: areas,
          boulders: boulders,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
