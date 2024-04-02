import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../theme_constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(DarkModeInitial()) {
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
  }

  void _onToggleDarkMode(
      ToggleDarkModeEvent event, Emitter<DarkModeState> emit) {
    DarkModeSwitch.toggleDarkMode();

    emit(DarkModeChanged(DarkModeSwitch.isDarkMode));
  }
}
