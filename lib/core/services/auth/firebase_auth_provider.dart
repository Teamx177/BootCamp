// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show
        ConfirmationResult,
        EmailAuthProvider,
        FirebaseAuth,
        FirebaseAuthException,
        PhoneAuthCredential,
        PhoneAuthProvider,
        User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/services/auth/auth_exceptions.dart';
import 'package:hrms/core/services/auth/auth_provider.dart';
import 'package:hrms/core/services/auth/auth_user.dart';
import 'package:hrms/core/storage/dialog_storage.dart';

class FirebaseAuthprovider implements AuthProvider {
  String? verificationId;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final users = currentUser;
      if (users != null) {
        return users;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else if (e.code == 'internal-error') {
        throw InternalErrorException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkErrorException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendPasswordReset({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> phoneLogin({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    //Web can't be good for use
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      ConfirmationResult result =
          await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.of(context).pop();
        },
      );
    } else {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            showErrorDialog(context, e.message.toString());
          },
          codeSent: ((
            String verificationId,
            int? resendToken,
          ) async {
            showOTPDialog(
              codeController: codeController,
              context: context,
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: codeController.text.trim(),
                );
                if (FirebaseAuth.instance.currentUser != null) {
                  await FirebaseAuth.instance.currentUser
                      ?.linkWithCredential(credential);
                  router.pop();
                } else {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  router.pop();
                }
                if (FirebaseAuth.instance.currentUser == null) {
                  showErrorDialog(context, 'Hata oluştu');
                } else {
                  router.go('/home');
                }
              },
            );
          }),
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-verification-id') {
          throw InvalidVerificationId();
        } else if (e.code == 'invalid-verification-code') {
          throw InvalidVerificationCode();
        } else if (e.code == 'invalid-email') {
          throw InvalidEmailAuthException();
        } else if (e.code == 'provider-already-linked') {
          throw UserAlreadyLinked();
        } else if (e.code == 'email-already-in-use') {
          throw EmailAlreadyInUseAuthException();
        } else if (e.code == 'too-many-requests') {
          throw TooManyRequestsAuthException();
        } else if (e.code == 'internal-error') {
          throw InternalErrorException();
        } else if (e.code == 'network-request-failed') {
          throw NetworkErrorException();
        } else {
          throw GenericAuthException();
        }
      }
    }
  }

  @override
  Future<User?> updatePhone(String phoneNumber, BuildContext context) async {
    try {
      TextEditingController codeController = TextEditingController();
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.verifyPhoneNumber(
          timeout: const Duration(seconds: 120),
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            showErrorDialog(context, e.message.toString());
          },
          codeSent: ((
            String verificationId,
            int? resendToken,
          ) async {
            showOTPDialog(
                codeController: codeController,
                context: context,
                onPressed: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: codeController.text.trim(),
                  );
                  await user?.updatePhoneNumber(credential);
                  final userDoc = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid);
                  await userDoc.update({
                    'phoneNumber': phoneNumber,
                  });
                  Navigator.pop(context);
                });
          }),
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationId = verificationId;
          });

      await user?.reload();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-id') {
        throw InvalidVerificationId();
      } else if (e.code == 'invalid-verification-code') {
        throw InvalidVerificationCode();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else if (e.code == 'internal-error') {
        throw InternalErrorException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkErrorException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> updateDisplayName(
      String displayName, BuildContext context) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(displayName);
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid);
      return await documentReference.update({
        'name': displayName,
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Future<void> updateEmail(
      String newEmail, String currentEmail, String currentPassword) async {
    try {
      final credential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword);
      final authResult = await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);

      final user = authResult?.user;
      await user?.updateEmail(newEmail);
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user?.uid);
      await userDoc.update({'email': newEmail});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-email') {
        throw GenericAuthException();
      } else if (e.code == 'invalid-verification-code') {
        throw InvalidVerificationCode();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else if (e.code == 'internal-error') {
        throw InternalErrorException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkErrorException();
      } else if (e.code == 'invalid-verification-code') {
        throw InvalidVerificationId();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> updatePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      final authResult = await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);
      final user = authResult?.user;
      await user?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'invalid-email') {
        throw GenericAuthException();
      } else if (e.code == 'invalid-verification-code') {
        throw InvalidVerificationCode();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else if (e.code == 'internal-error') {
        throw InternalErrorException();
      } else if (e.code == 'network-request-failed') {
        throw NetworkErrorException();
      } else if (e.code == 'invalid-verification-code') {
        throw InvalidVerificationId();
      } else {
        throw GenericAuthException();
      }
    }
  }
}
