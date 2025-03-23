part of 'sign_in_bloc.dart';

@immutable
class SignInState {
  final String email;
  final String password;
  final Status status;
  final String errorMessage;

  const SignInState({
    required this.email,
    required this.password,
    required this.status,
    required this.errorMessage,
  });

  SignInState copyWith({
    String? email,
    String? password,
    Status? status,
    String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SignInState.initial() {
    return const SignInState(
      email: '',
      password: '',
      status: Status.initial,
      errorMessage: '',
    );
  }
}
