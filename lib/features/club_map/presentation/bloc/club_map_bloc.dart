import 'package:bloc/bloc.dart';
import 'package:bouldee/features/club_map/domain/entities/area_entity.dart';
import 'package:bouldee/features/club_map/domain/entities/boulder_entity.dart';
import 'package:bouldee/features/club_map/domain/usecases/get_club_map_data.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'club_map_event.dart';
part 'club_map_state.dart';

@injectable
class ClubMapBloc extends Bloc<ClubMapEvent, ClubMapState> {
  ClubMapBloc(this._getClubMapDataUseCase) : super(ClubMapInitial()) {
    on<LoadClubMapData>(_onLoadAreas);
  }
  final GetClubMapDataUseCase _getClubMapDataUseCase;

  Future<void> _onLoadAreas(
    LoadClubMapData event,
    Emitter<ClubMapState> emit,
  ) async {
    emit(ClubMapLoading());
    final result = await _getClubMapDataUseCase(event.clubId);
    result.fold(
      (error) => emit(AreaError(message: error)),
      (mapData) => emit(
        ClubMapLoaded(
          areas: mapData.areas,
          boulders: mapData.boulders,
        ),
      ),
    );
  }
}
