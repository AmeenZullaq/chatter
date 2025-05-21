import 'package:chatter/core/constants/app_keys.dart';
import 'package:chatter/core/constants/boxes.dart';
import 'package:chatter/core/services/hive_database.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:chatter/injection_container.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser({required UserModel user});
  Future<void> deleteUser({required String boxName});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveDatabase hiveDatabase;

  AuthLocalDataSourceImpl(this.hiveDatabase);
  @override
  Future<void> saveUser({required UserModel user}) async {
    await hiveDatabase.save<UserModel>(
      boxName: Boxes.users,
      key: AppKeys.userData,
      value: user,
    );
  }

  @override
  Future<void> deleteUser({required String boxName}) async {
    await getIt<HiveDatabase>().deleteBox(boxName: Boxes.users);
  }
}
