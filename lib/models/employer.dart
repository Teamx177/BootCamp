import 'package:hrms/models/user.dart';

class Employer implements User {
  String? name;

  @override
  String? email;

  @override
  String? password;

  @override
  String? phoneNumber;
}
