import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:mysavingapp/data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  Future<void> singInFormSubmitted() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));

    try {
      await _authRepository.singIn(
          email: state.email, password: state.password);

      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(status: LoginStatus.error));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(status: LoginStatus.error));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(status: LoginStatus.error));
      }
    } on PlatformException catch (e) {
      if (e.message == 'ERROR_WRONG_PASSWORD') {
        emit(state.copyWith(status: LoginStatus.error));
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        emit(state.copyWith(status: LoginStatus.error));
      }
    } catch (e) {
      // Handle any other exceptions that might occur during the login process
      // For example, network errors or unexpected errorsemit(
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(state.copyWith(status: LoginStatus.passwordResetSuccess));
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
