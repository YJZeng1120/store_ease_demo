import '../../constants.dart';
import '../user.dart';

class UserDto {
  const UserDto({
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

  factory UserDto.fromModel(
    User user,
  ) {
    return UserDto(
      emailAddress: user.emailAddress,
      password: user.password,
      firstName: user.firstName,
      lastName: user.lastName,
      languageId: user.languageId,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      "email": emailAddress,
      "password": password,
      "userType": userType,
      "firstName": firstName,
      "lastName": lastName,
      "languageId": languageId
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "languageId": languageId,
    };
  }

  Map<String, dynamic> toResetPasswordJson(String userId) {
    return {
      "userId": userId,
      "password": password,
    };
  }

  factory UserDto.fromJson(
    Map<String, dynamic> map,
  ) {
    return UserDto(
      emailAddress: map['email'] ?? '', // Update時email為空
      password: map['password'] ?? '', // Update時password為空
      firstName: map['firstName'],
      lastName: map['lastName'],
      languageId: map['languageId'],
    );
  }

  User toModel() {
    return User(
      emailAddress: emailAddress,
      password: password,
      firstName: firstName,
      lastName: lastName,
      languageId: languageId,
    );
  }
}
