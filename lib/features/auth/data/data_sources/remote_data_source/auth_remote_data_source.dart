import 'package:chatter/core/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUp({
    required String email,
    required String password,
  });
  Future<User> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService firebaseAuthService;

  AuthRemoteDataSourceImpl(this.firebaseAuthService);
  @override
  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuthService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await firebaseAuthService.singInwithEmailAndPassword(
      email: email,
      password: password,
    );
    return user;
  }
}
