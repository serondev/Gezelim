class User {
  final String email;
  final String password;
  final String name;
  final String surname;
  final String? phoneNumber;
  final String? birthDate;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
    this.phoneNumber,
    this.birthDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      name: map['name'],
      surname: map['surname'],
      phoneNumber: map['phoneNumber'],
      birthDate: map['birthDate'],
    );
  }
}
