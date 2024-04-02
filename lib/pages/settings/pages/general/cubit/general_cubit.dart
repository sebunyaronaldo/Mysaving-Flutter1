import 'package:bloc/bloc.dart';
import 'package:mysavingapp/data/repositories/interfaces/ISettingsRepository.dart';
import 'package:mysavingapp/data/repositories/settings_repository.dart';

import '../../../../../data/models/settings_model.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit({ISettingsRepository? profileRepository})
      : _profileRepository = profileRepository ?? SettingsRepository(),
        super(GeneralInitial());
  final ISettingsRepository _profileRepository;
  Future<void> fetchGeneral() async {
    emit(GeneralLoading());
    final results = await _profileRepository.getGeneral();
    emit(GeneralLoaded(profiles: results));
  }

  Future<void> updateLanguage(String newLanguage) async {
    emit(GeneralLoading());
    try {
      await _profileRepository.updateLanguage(newLanguage);
      emit(GeneralUpdated('Email updated successfully.'));
      await fetchGeneral(); // Fetch profile again after the update
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      print(e.toString());
      emit(GeneralError('Failed to update email.'));
    }
  }
}
