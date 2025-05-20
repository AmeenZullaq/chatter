import 'dart:convert';

import 'package:chatter/core/constants/app_endpoints.dart';
import 'package:chatter/core/constants/app_keys.dart';
import 'package:chatter/core/errors/error_model.dart';
import 'package:chatter/core/errors/firebase_error_handler.dart';
import 'package:chatter/core/services/firebase_auth_service.dart';
import 'package:chatter/core/services/remote_database_service.dart';
import 'package:chatter/core/services/shared_preferences.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:chatter/features/auth/data/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final RemoteDatabaseService remoteDatabaseService;

  AuthRepoImpl(this.firebaseAuthService, this.remoteDatabaseService);
  @override
  Future<Either<ErrorModel, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await firebaseAuthService.singInwithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await getUserData(userId: userCred.uid);
      await saveUserDataLocally(user);
      return right(user);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    User? userCred;
    try {
      userCred = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel(
        id: userCred.uid,
        username: username,
        email: userCred.email!,
      );
      addUserData(user);
      saveUserDataLocally(user);
      return right(user);
    } catch (e) {
      if (userCred != null) {
        deleteUser(userCred.uid);
      }
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> deleteUser(String userId) async {
    try {
      await firebaseAuthService.deleteUser();
      await remoteDatabaseService.deleteData(
        path: AppEndpoints.users,
        documentId: userId,
      );
      await SharedPrefs.remove(AppKeys.userData);
      return right(unit);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> logOut() async {
    try {
      await firebaseAuthService.logOut();
      return right(unit);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<void> addUserData(UserModel user) async {
    await remoteDatabaseService.addData(
      path: AppEndpoints.users,
      documentId: user.id,
      data: user.toJson(),
    );
  }

  @override
  Future<void> saveUserDataLocally(UserModel user) async {
    await SharedPrefs.setString(
      AppKeys.userData,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel> getUserData({required String userId}) async {
    final userData = await remoteDatabaseService.getData(
      path: AppEndpoints.users,
      documentId: userId,
    );
    return UserModel.fromJson(userData);
  }
}
