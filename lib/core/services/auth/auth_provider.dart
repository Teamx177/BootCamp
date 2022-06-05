import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required BuildContext context,
    required String email,
    required String password,
    required String phoneNumber,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset({
    required String email,
  });
  Future<User?> phoneLogin({
    required String phoneNumber,
    required BuildContext context,
  });
  Future<User?> phoneSingUp({
    required String phoneNumber,
    required BuildContext context,
  });
  Future<User?> updatePhone(String phoneNumber, BuildContext context);
  Future<void> updateDisplayName(String displayName, BuildContext context);
  Future<void> updateEmail(BuildContext context, String newEmail,
      String currentEmail, String currentPassword);
  Future<void> updatePassword(BuildContext context, String email,
      String currentPassword, String newPassword);
}
