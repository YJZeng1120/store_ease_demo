class User {
  const User({
    required this.emailAddress,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.languageId,
  });
  final String emailAddress;
  final String password;
  final String firstName;
  final String lastName;
  final int languageId;

  factory User.empty() {
    return const User(
      emailAddress: '',
      password: '',
      firstName: '',
      lastName: '',
      languageId: 1,
    );
  }

  User copyWith({
    String? emailAddress,
    String? password,
    String? firstName,
    String? lastName,
    int? languageId,
  }) {
    return User(
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      languageId: languageId ?? this.languageId,
    );
  }
}
