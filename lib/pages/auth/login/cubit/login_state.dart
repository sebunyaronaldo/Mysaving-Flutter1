part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error, passwordResetSuccess }
// Enum LoginStatus definiuje możliwe stany logowania: initial (początkowy), submitting (w trakcie wysyłania), success (sukces), error (błąd).

@immutable
class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
// Klasa LoginState definiuje stan logowania. Zawiera pola email, password i status.

  const LoginState(
      {required this.email, required this.password, required this.status});
// Konstruktor LoginState inicjalizuje obiekt stanu logowania przyjmując wymagane wartości dla pól email, password i status.

  factory LoginState.initial() {
    return const LoginState(
        email: '', password: '', status: LoginStatus.initial);
  }
// Factory constructor initial() zwraca instancję LoginState z domyślnymi wartościami pól: pusty email, puste hasło i status LoginStatus.initial.

  LoginState copyWith({String? email, String? password, LoginStatus? status}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status);
  }
// Metoda copyWith() tworzy nową instancję LoginState na podstawie istniejącej instancji, z możliwością zaktualizowania wartości pól. Jeśli wartość argumentu email, password lub status nie jest podana (null), zostanie zachowana obecna wartość z istniejącej instancji.

  @override
  List<Object?> get props => [email, password, status];
}
// Metoda props zwraca listę pól, które są brane pod uwagę podczas porównywania dwóch instancji LoginState.