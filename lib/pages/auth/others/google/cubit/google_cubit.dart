// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:mysavingapp/data/repositories/google_repository.dart';

// part 'google_state.dart';

// class GoogleCubit extends Cubit<GoogleState> {
//   final GoogleRepository _googleRepository;
//   bool isFirstLogin = true; // Add this property

//   GoogleCubit(this._googleRepository) : super(GoogleState.initial());

//   Future<void> signUpFormSubmitted() async {
//     if (state.status == GoogleStatus.submitting) return;
//     emit(state.copyWith(status: GoogleStatus.submitting));
//     try {
//       await _googleRepository.signInWithGoogle();
//       emit(state.copyWith(status: GoogleStatus.success));
//     } catch (_) {}
//   }
// }
