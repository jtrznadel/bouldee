part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

class SignInEmailChanged extends SignInEvent {
  SignInEmailChanged({required this.email});

  final String email;
}

class SignInPasswordChanged extends SignInEvent {
  SignInPasswordChanged({required this.password});

  final String password;
}

final class SignInSubmitted extends SignInEvent {}

final class SignInResetForm extends SignInEvent {}
