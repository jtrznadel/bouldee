part of 'premium_bloc.dart';

sealed class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object> get props => [];
}

final class PremiumSubscriptionTypeChanged extends PremiumEvent {
  const PremiumSubscriptionTypeChanged(this.subscriptionType);

  final SubscriptionType subscriptionType;

  @override
  List<Object> get props => [subscriptionType];
}
