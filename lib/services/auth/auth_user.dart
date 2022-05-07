import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String uid;
  const AuthUser(this.uid);
  factory AuthUser.fromFirebase(User user) => AuthUser(user.uid);
}
