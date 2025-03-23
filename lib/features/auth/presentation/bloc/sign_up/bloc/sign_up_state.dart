part of 'sign_up_bloc.dart';

@immutable
class SignUpState {
  const SignUpState({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.username,
    required this.status,
    required this.errorMessage,
  });

  factory SignUpState.initial() {
    return const SignUpState(
      email: '',
      password: '',
      confirmPassword: '',
      phoneNumber: '',
      username: '',
      status: Status.initial,
      errorMessage: '',
    );
  }

  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final String username;
  final Status status;
  final String errorMessage;

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? phoneNumber,
    String? username,
    Status? status,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  

}
