class User {
  final String id;
  final String? email;
  final String? password;
  final String? name;
  final int? gender;
  final DateTime? date;

  const User({
    required this.id,
    this.email,
    this.password,
    this.name,
    this.gender,
    this.date,
  });

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  List<Object?> get props => [id, email, password, name, gender, date];
}
