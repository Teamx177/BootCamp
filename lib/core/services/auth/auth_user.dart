import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  const AuthUser(this.uid, this.email, this.displayName, this.phoneNumber);

  factory AuthUser.fromFirebase(user) =>
      AuthUser(user.uid, user.email, user.displayName, user.phoneNumber);
}
