import 'package:flutter/material.dart';
import 'package:hrms/core/services/auth/auth_provider.dart';
import 'package:hrms/core/services/auth/auth_user.dart';
import 'package:hrms/core/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthprovider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordReset({
    required String email,
  }) =>
      provider.sendPasswordReset(
        email: email,
      );

  @override
  Future<void> phoneSignUp({
    required String phoneNumber,
    required BuildContext context,
  }) =>
      provider.phoneSignUp(
        phoneNumber: phoneNumber,
        context: context,
      );
}
