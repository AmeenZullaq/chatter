import 'package:chatter/core/constants/app_keys.dart';
import 'package:chatter/core/constants/boxes.dart';
import 'package:chatter/core/services/hive_database.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserLocally(UserModel user);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveDatabase hiveDatabase;

  AuthLocalDataSourceImpl(this.hiveDatabase);
  @override
  Future<void> saveUserLocally(UserModel user) async {
    await hiveDatabase.save<UserModel>(
      boxName: Boxes.users,
      key: AppKeys.userData,
      value: user,
    );
  }
}
