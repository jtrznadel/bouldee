part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUpEmailChanged extends SignUpEvent {
  SignUpEmailChanged({required this.email});

  final String email;
}

class SignUpPasswordChanged extends SignUpEvent {
  SignUpPasswordChanged({required this.password});

  final String password;
}

class SignUpConfirmPasswordChanged extends SignUpEvent {
  SignUpConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;
}

class SignUpPhoneNumberChanged extends SignUpEvent {
  SignUpPhoneNumberChanged({required this.phoneNumber});

  final String phoneNumber;
}

class SignUpUsernameChanged extends SignUpEvent {
  SignUpUsernameChanged({required this.username});

  final String username;
}

class SignUpSubmitted extends SignUpEvent {}

class SignUpResetForm extends SignUpEvent {}
