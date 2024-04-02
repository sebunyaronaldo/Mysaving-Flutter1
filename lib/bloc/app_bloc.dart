import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mysavingapp/data/models/user_model.dart';
import 'package:mysavingapp/data/repositories/auth_repository.dart';

import '../common/theme/theme_constants.dart';
import '../config/services/user_manager.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  StreamSubscription<User>? _userSubscription;

  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(authRepository.currentUser.isNotEmpty
            ? AppState.authenticated(authRepository.currentUser)
            : const AppState.unauthenticated()) {
    on<AppUserChangedEvent>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription =
        _authRepository.user.listen((user) => add(AppUserChangedEvent(user)));
  }

  void _onUserChanged(AppUserChangedEvent event, Emitter<AppState> emit) {
    if (event.user.isNotEmpty) {
      emit(AppState.authenticated(event.user));
    } else {
      emit(const AppState.unauthenticated());
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    _authRepository.logOut();
    UserManager().clearUID();
    DarkModeSwitch.resetDarkMode();
    emit(const AppState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
