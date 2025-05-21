import 'package:chatter/core/constants/app_endpoints.dart';
import 'package:chatter/core/constants/app_keys.dart';
import 'package:chatter/core/constants/boxes.dart';
import 'package:chatter/core/errors/error_model.dart';
import 'package:chatter/core/errors/firebase_error_handler.dart';
import 'package:chatter/core/services/firebase_auth_service.dart';
import 'package:chatter/core/services/hive_database.dart';
import 'package:chatter/core/services/remote_database_service.dart';
import 'package:chatter/core/services/shared_preferences.dart';
import 'package:chatter/features/auth/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:chatter/features/auth/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:chatter/features/auth/data/repos/auth_repo.dart';
import 'package:chatter/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final RemoteDatabaseService remoteDatabaseService;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepoImpl(
    this.authLocalDataSource,
    this.firebaseAuthService,
    this.remoteDatabaseService,
    this.authRemoteDataSource,
  );
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
      final user = await getUserDataRemotlly(userId: userCred.uid);
      await authLocalDataSource.saveUserLocally(user);
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
      userCred = await authRemoteDataSource.signUp(
        email: email,
        password: password,
      );
      final user = UserModel.fromAuthUser(userCred).copyWith(
        username: username,
      );
      saveUserDataRemotlly(user);
      await authLocalDataSource.saveUserLocally(user);

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
      await getIt<HiveDatabase>().deleteBox(boxName: Boxes.users);
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
      await getIt<HiveDatabase>().deleteBox(boxName: Boxes.users);
      return right(unit);
    } catch (e) {
      return left(
        FirebaseErrorHandler().handle(e),
      );
    }
  }

  @override
  Future<void> saveUserDataRemotlly(UserModel user) async {
    await remoteDatabaseService.addData(
      path: AppEndpoints.users,
      documentId: user.id,
      data: user.toJson(),
    );
  }

  @override
  Future<UserModel> getUserDataRemotlly({required String userId}) async {
    final userData = await remoteDatabaseService.getData(
      path: AppEndpoints.users,
      documentId: userId,
    );
    return UserModel.fromJson(userData);
  }
}
