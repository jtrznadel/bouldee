part of 'premium_bloc.dart';

sealed class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object> get props => [];
}

final class PremiumInitial extends PremiumState {}

final class PremiumLoading extends PremiumState {}

final class PremiumLoaded extends PremiumState {
  const PremiumLoaded({required this.selectedSubscriptionType});

  final SubscriptionType selectedSubscriptionType;

  @override
  List<Object> get props => [selectedSubscriptionType];

  PremiumLoaded copyWith({SubscriptionType? selectedSubscriptionType}) {
    return PremiumLoaded(
      selectedSubscriptionType:
          selectedSubscriptionType ?? this.selectedSubscriptionType,
    );
  }
}
