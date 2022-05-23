import 'package:flutter/material.dart';
import 'package:hrms/core/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> phoneSignUp(
      {required String phoneNumber, required BuildContext context});
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({
    required String email,
  });
}
