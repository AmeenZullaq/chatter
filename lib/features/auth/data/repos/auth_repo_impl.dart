import 'package:chatter/core/constants/app_endpoints.dart';
import 'package:chatter/core/constants/boxes.dart';
import 'package:chatter/core/errors/error_model.dart';
import 'package:chatter/core/errors/firebase_error_handler.dart';
import 'package:chatter/features/auth/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:chatter/features/auth/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:chatter/features/auth/data/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepoImpl(
    this.authLocalDataSource,
    this.authRemoteDataSource,
  );

  @override
  Future<Either<ErrorModel, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    User? userCred;
    try {
      userCred = await authRemoteDataSource.signUp(
        email: email,
        password: password,
      );
      final user = UserModel.fromAuthUser(userCred).copyWith(
        username: username,
      );
      await authRemoteDataSource.saveUser(user: user);
      await authLocalDataSource.saveUser(user: user);
      return right(user);
    } catch (e) {
      if (userCred != null) {
        deleteUser(documentId: userCred.uid);
      }
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await authRemoteDataSource.login(
        email: email,
        password: password,
      );
      final user = await authRemoteDataSource.getUser(
        path: AppEndpoints.users,
        documentId: userCred.uid,
      );
      await authLocalDataSource.saveUser(user: user);
      return right(user);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> logOut() async {
    try {
      await authRemoteDataSource.logout();
      await authLocalDataSource.deleteUser(boxName: Boxes.users);
      return right(unit);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> deleteUser({
    required String documentId,
  }) async {
    try {
      await authRemoteDataSource.deleteUser(
        path: AppEndpoints.users,
        documentId: documentId,
      );
      await authLocalDataSource.deleteUser(boxName: Boxes.users);
      return right(unit);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }
}
