import 'package:bloc/bloc.dart';
import 'package:bouldee/app/constants/enums.dart';
import 'package:equatable/equatable.dart';

part 'premium_event.dart';
part 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  PremiumBloc()
      : super(
          const PremiumLoaded(
            selectedSubscriptionType: SubscriptionType.monthly,
          ),
        ) {
    on<PremiumSubscriptionTypeChanged>(_onSubscriptionTypeChanged);
  }

  Future<void> _onSubscriptionTypeChanged(
    PremiumSubscriptionTypeChanged event,
    Emitter<PremiumState> emit,
  ) async {
    if (state is PremiumLoaded) {
      final currentState = state as PremiumLoaded;
      emit(
        currentState.copyWith(
          selectedSubscriptionType: event.subscriptionType,
        ),
      );
    } else {
      emit(
        PremiumLoaded(selectedSubscriptionType: event.subscriptionType),
      );
    }
  }
}
