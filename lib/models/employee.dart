import 'package:hrms/models/user.dart';

class Employee implements User {
  String? city;

  @override
  String? email;

  @override
  String? password;

  @override
  String? phoneNumber;
}
