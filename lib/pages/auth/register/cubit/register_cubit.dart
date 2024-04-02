import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mysavingapp/data/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  RegisterCubit(this._authRepository) : super(RegisterState.initial());
  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: RegisterStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: RegisterStatus.initial));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: RegisterStatus.initial));
  }

  Future<void> signUpFormSubmitted() async {
    if (state.status == RegisterStatus.submitting) return;
    emit(state.copyWith(status: RegisterStatus.submitting));
    try {
      await _authRepository.signUp(
        name: state.name,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (_) {}
  }
}
