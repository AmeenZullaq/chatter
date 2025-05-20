import 'package:bloc/bloc.dart';
import 'package:chatter/features/auth/data/repos/auth_repo.dart';
import 'package:flutter/material.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.login(
      email: email,
      password: password,
    );
    result.fold(
      (errorModel) => emit(
        AuthFailure(errorModel.errorMessage),
      ),
      (user) => emit(AuthSuccess()),
    );
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.signUp(
      username: username,
      email: email,
      password: password,
    );
    result.fold(
      (errorModel) => emit(
        AuthFailure(errorModel.errorMessage),
      ),
      (user) => emit(AuthSuccess()),
    );
  }
}
