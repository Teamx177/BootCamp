import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isAnon;
  const AuthUser(this.isAnon);
  factory AuthUser.fromFirebase(User user) => AuthUser(user.isAnonymous);
}
