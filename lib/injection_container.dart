import 'package:chatter/core/services/firebase_auth_service.dart';
import 'package:chatter/core/services/firestore_service.dart';
import 'package:chatter/core/services/hive_database.dart';
import 'package:chatter/core/services/remote_database_service.dart';
import 'package:chatter/features/auth/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:chatter/features/auth/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:chatter/features/auth/data/repos/auth_repo.dart';
import 'package:chatter/features/auth/data/repos/auth_repo_impl.dart';
import 'package:chatter/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

GetIt getIt = GetIt.instance;

Future<void> initDependency() async {
  await authDependencyInit();
  await hiveDatabaseInit();
}

Future<void> authDependencyInit() async {
  getIt.registerLazySingleton<FirebaseAuthService>(
    () {
      return FirebaseAuthService();
    },
  );
  getIt.registerLazySingleton<RemoteDatabaseService>(
    () {
      return FirestoreService();
    },
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () {
      return AuthLocalDataSourceImpl(
        getIt.get<HiveDatabase>(),
      );
    },
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () {
      return AuthRemoteDataSourceImpl(
        getIt.get<FirebaseAuthService>(),
        getIt.get<RemoteDatabaseService>(),
      );
    },
  );
  getIt.registerLazySingleton<AuthRepo>(
    () {
      return AuthRepoImpl(
        getIt.get<AuthLocalDataSource>(),
        getIt.get<AuthRemoteDataSource>(),
      );
    },
  );
  getIt.registerLazySingleton<AuthCubit>(
    () {
      return AuthCubit(
        getIt.get<AuthRepo>(),
      );
    },
  );
}

Future<void> hiveDatabaseInit() async {
  getIt.registerLazySingleton(
    () => HiveDatabase(),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(
    UserModelAdapter(),
  );
}
