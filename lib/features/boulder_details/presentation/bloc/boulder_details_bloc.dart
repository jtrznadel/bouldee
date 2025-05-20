import 'package:bloc/bloc.dart';
import 'package:bouldee/features/boulder_details/domain/entities/boulder_details_entity.dart';
import 'package:bouldee/features/boulder_details/domain/usecases/get_boulder_details_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'boulder_details_event.dart';
part 'boulder_details_state.dart';

@injectable
class BoulderDetailsBloc
    extends Bloc<BoulderDetailsEvent, BoulderDetailsState> {
  BoulderDetailsBloc(this.getBoulderDetails) : super(BoulderDetailsInitial()) {
    on<GetBoulderDetailsEvent>(_onGetBoulderDetails);
  }
  final GetBoulderDetailsUsecase getBoulderDetails;

  Future<void> _onGetBoulderDetails(
    GetBoulderDetailsEvent event,
    Emitter<BoulderDetailsState> emit,
  ) async {
    emit(BoulderDetailsLoading());
    final result = await getBoulderDetails(event.boulderId);

    result.fold(
      (failure) => emit(BoulderDetailsError(failure.message)),
      (boulderDetails) => emit(BoulderDetailsLoaded(boulderDetails)),
    );
  }
}
