part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthInitialCheck extends AuthEvent {}

class AuthChangeCurrentUser extends AuthEvent {
  final User? user;

  AuthChangeCurrentUser(this.user);
}

class AuthLogout extends AuthEvent {}
