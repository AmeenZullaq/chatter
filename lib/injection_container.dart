import 'package:chatter/core/services/firebase_auth_service.dart';
import 'package:chatter/core/services/firestore_service.dart';
import 'package:chatter/core/services/remote_database_service.dart';
import 'package:chatter/features/auth/data/repos/auth_repo.dart';
import 'package:chatter/features/auth/data/repos/auth_repo_impl.dart';
import 'package:chatter/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

class InjectionContainer {
  static GetIt getIt = GetIt.instance;

  static Future<void> initDependency() async {
    await authDependencyInit();
  }

  static Future<void> authDependencyInit() async {
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
    getIt.registerLazySingleton<AuthRepo>(
      () {
        return AuthRepoImpl(
          getIt.get<FirebaseAuthService>(),
          getIt.get<RemoteDatabaseService>(),
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
}
