import 'package:hrms/models/user.dart';

class Employer implements User {
  @override
  String? city;

  @override
  String? email;

  @override
  String? gender;

  @override
  String? name;

  @override
  String? password;

  @override
  String? phoneNumber;

  @override
  String? userType;
}