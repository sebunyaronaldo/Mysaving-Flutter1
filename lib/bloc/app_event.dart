part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent(); // Konstruktor klasy AppEvent bez parametrów

  @override
  List<Object?> get props => []; // Zwraca listę właściwości eventu
}

class AppLogoutRequested extends AppEvent {}

class AppUserChangedEvent extends AppEvent {
  final User user;

  AppUserChangedEvent(
      this.user); // Konstruktor klasy AppUserChangedEvent z parametrem 'user'

  @override
  List<Object?> get props =>
      [user]; // Zwraca listę właściwości eventu, w tym przypadku tylko 'user'
}
