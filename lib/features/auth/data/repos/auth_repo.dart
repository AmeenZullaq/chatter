import 'package:chatter/core/errors/error_model.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<ErrorModel, UserModel>> login({
    required String email,
    required String password,
  });
  Future<Either<ErrorModel, UserModel>> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<Either<ErrorModel, Unit>> logOut();

  Future<void> addUserData(UserModel user);

  Future<void> saveUserDataLocally(UserModel user);

  Future<UserModel> getUserData({required String userId});

  Future<Either<ErrorModel, Unit>> deleteUser(String userId);
}
