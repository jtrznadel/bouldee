import 'package:bouldee/features/boulder_details/data/models/boulder_details_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BoulderDetailsRemoteDataSource {
  Future<BoulderDetailsModel> getBoulderDetails({
    required String boulderId,
  });
}

@Injectable(as: BoulderDetailsRemoteDataSource)
class BoulderDetailsRemoteDataSourceImpl
    implements BoulderDetailsRemoteDataSource {
  BoulderDetailsRemoteDataSourceImpl(this._supabase);
  final SupabaseClient _supabase;
  @override
  Future<BoulderDetailsModel> getBoulderDetails({
    required String boulderId,
  }) async {
    try {
      final response = await _supabase.from('boulders').select('''
      *, details:boulder_details!inner(*)
''').eq('id', boulderId).single();
      return BoulderDetailsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
