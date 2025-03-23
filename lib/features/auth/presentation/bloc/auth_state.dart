part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthUserAuthenticated extends AuthState {
  final User user;

  AuthUserAuthenticated(this.user);
}

final class AuthUserUnauthenticated extends AuthState {}
