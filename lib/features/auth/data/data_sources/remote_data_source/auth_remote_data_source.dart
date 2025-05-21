import 'package:chatter/core/constants/app_endpoints.dart';
import 'package:chatter/core/services/firebase_auth_service.dart';
import 'package:chatter/core/services/remote_database_service.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
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

  Future<void> logout();
  Future<void> deleteUser({
    required String path,
    required String documentId,
  });

  Future<void> saveUser({
    required UserModel user,
  });

  Future<UserModel> getUser({
    required String path,
    required String documentId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService firebaseAuthService;
  final RemoteDatabaseService remoteDatabaseService;

  AuthRemoteDataSourceImpl(
    this.firebaseAuthService,
    this.remoteDatabaseService,
  );
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

  @override
  Future<void> logout() async {
    await firebaseAuthService.logOut();
  }

  @override
  Future<void> deleteUser({
    required String path,
    required String documentId,
  }) async {
    await firebaseAuthService.deleteUser();
    await remoteDatabaseService.deleteData(
      path: AppEndpoints.users,
      documentId: documentId,
    );
  }

  @override
  Future<void> saveUser({
    required UserModel user,
  }) async {
    await remoteDatabaseService.addData(
      path: AppEndpoints.users,
      documentId: user.id,
      data: user.toJson(),
    );
  }

  @override
  Future<UserModel> getUser({
    required String documentId,
    required String path,
  }) async {
    final userData = await remoteDatabaseService.getData(
      path: AppEndpoints.users,
      documentId: documentId,
    );
    return UserModel.fromJson(userData);
  }
}
