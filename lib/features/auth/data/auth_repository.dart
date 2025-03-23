import 'package:bouldee/features/auth/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._supabaseAuth);
  final GoTrueClient _supabaseAuth;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabaseAuth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    final response = await _supabaseAuth.signUp(
      password: password,
      email: email,
      data: {
        'username': username,
      },
    );
    print(response);
  }

  @override
  Future<void> signOut() async => _supabaseAuth.signOut();

  @override
  Stream<User?> getCurrentUser() {
    return _supabaseAuth.onAuthStateChange.map((event) => event.session?.user);
  }

  @override
  User? getSignedInUser() => _supabaseAuth.currentUser;
}
