// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show EmailAuthProvider, FirebaseAuth, FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:hireme/core/services/auth/auth_exceptions.dart';
import 'package:hireme/core/services/auth/auth_provider.dart';
import 'package:hireme/core/services/auth/auth_user.dart';
import 'package:hireme/core/storage/dialog_storage.dart';
import 'package:hireme/core/storage/text_storage.dart';

class FirebaseAuthprovider implements AuthProvider {
  // String? verificationId;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => showOkToast(text: AuthStatusTexts.successRegister));
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'operation-not-allowed') {
        throw InvalidEmailAuthException();
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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => showOkToast(text: AuthStatusTexts.loginSucces));

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
      return await FirebaseAuth.instance.signOut().then((value) => showOkToast(text: 'Başarıyla çıkış yapıldı'));
    } else {
      showOkToast(text: "Çıkış yapılırken bir sorunla karşılaşıldı");
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
            email: email,
          )
          .then((value) => showOkToast(text: AuthStatusTexts.passwordResetSend));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    }
  }
// Its buggy we tryed
  // @override
  // Future<User?> phoneLogin({
  //   required String phoneNumber,
  //   required BuildContext context,
  // }) async {
  //   //Web can't be good for use
  //   TextEditingController codeController = TextEditingController();
  //   if (kIsWeb) {
  //     ConfirmationResult result = await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
  //     showOTPDialog(
  //       codeController: codeController,
  //       context: context,
  //       onPressed: () async {
  //         PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //           verificationId: result.verificationId,
  //           smsCode: codeController.text.trim(),
  //         );
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //         Navigator.of(context).pop();
  //       },
  //     );
  //   } else {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       timeout: const Duration(seconds: 60),
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) {},
  //       verificationFailed: (FirebaseAuthException e) {
  //         showErrorDialog(context, e.message.toString());
  //       },
  //       codeSent: ((
  //         String verificationId,
  //         int? resendToken,
  //       ) async {
  //         showOTPDialog(
  //           codeController: codeController,
  //           context: context,
  //           onPressed: () async {
  //             PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //               verificationId: verificationId,
  //               smsCode: codeController.text.trim(),
  //             );
  //             try {
  //               await FirebaseAuth.instance
  //                   .signInWithCredential(credential)
  //                   .then((value) => showOkToast(text: AuthStatusTexts.loginSucces));
  //               router.pop();
  //             } on FirebaseAuthException catch (e) {
  //               if (e.code == 'invalid-verification-id') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.invalidVerificationId,
  //                 );
  //               } else if (e.code == 'provider-already-linked') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.credentialAlreadyLinked,
  //                 );
  //               } else if (e.code == 'email-already-in-use') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.emailAlreadyUse,
  //                 );
  //               } else if (e.code == 'invalid-verification-code') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.invalidVerificationCode,
  //                 );
  //               } else if (e.code == 'credential-already-in-use') {
  //                 await showErrorDialog(context, ErrorTexts.credentialAlreadyUse);
  //               } else if (e.code == 'too-many-requests') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.tooManyRequests,
  //                 );
  //               } else if (e.code == 'internal-error') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.internalError,
  //                 );
  //               } else if (e.code == 'network-request-failed') {
  //                 await showErrorDialog(
  //                   context,
  //                   ErrorTexts.networkError,
  //                 );
  //               } else {
  //                 await showErrorDialog(
  //                   context,
  //                   (e.toString()),
  //                 );
  //               }
  //             }
  //             final user = FirebaseAuth.instance.currentUser;
  //             if (user != null) {
  //               router.go('/home');
  //             }
  //             showOkToast(text: 'Giriş yapıldı');
  //           },
  //         );
  //       }),
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         verificationId = verificationId;
  //       },
  //     );
  //   }
  //   var user = FirebaseAuth.instance.currentUser;
  //   await user?.reload();
  //   return user;
  // }

  // @override
  // Future<User?> updatePhone(String phoneNumber, BuildContext context) async {
  //   TextEditingController codeController = TextEditingController();
  //   var user = FirebaseAuth.instance.currentUser;
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       timeout: const Duration(seconds: 120),
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (credential) async {},
  //       verificationFailed: (FirebaseAuthException e) {
  //         showErrorDialog(context, e.message.toString());
  //       },
  //       codeSent: ((
  //         String verificationId,
  //         int? resendToken,
  //       ) async {
  //         showOTPDialog(
  //             codeController: codeController,
  //             context: context,
  //             onPressed: () async {
  //               try {
  //                 PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //                   verificationId: verificationId,
  //                   smsCode: codeController.text.trim(),
  //                 );
  //                 await user
  //                     ?.updatePhoneNumber(credential)
  //                     .then((value) => showOkToast(text: UpdateTexts.phoneNumberUpdateSuccess));
  //                 final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
  //                 await userDoc.update({
  //                   'phone': phoneNumber,
  //                 });
  //                 Navigator.pop(context);
  //               } on FirebaseAuthException catch (e) {
  //                 if (e.code == 'invalid-verification-id') {
  //                   await showErrorDialog(
  //                     context,
  //                     ErrorTexts.invalidVerificationId,
  //                   );
  //                 } else if (e.code == 'invalid-verification-code') {
  //                   await showErrorDialog(
  //                     context,
  //                     ErrorTexts.invalidVerificationCode,
  //                   );
  //                 } else if (e.code == 'credential-already-in-use') {
  //                   await showErrorDialog(context, ErrorTexts.credentialAlreadyUse);
  //                 } else if (e.code == 'too-many-requests') {
  //                   await showErrorDialog(
  //                     context,
  //                     ErrorTexts.tooManyRequests,
  //                   );
  //                 } else if (e.code == 'internal-error') {
  //                   await showErrorDialog(
  //                     context,
  //                     ErrorTexts.internalError,
  //                   );
  //                 } else if (e.code == 'network-request-failed') {
  //                   await showErrorDialog(
  //                     context,
  //                     ErrorTexts.networkError,
  //                   );
  //                 } else {
  //                   await showErrorDialog(
  //                     context,
  //                     (e.toString()),
  //                   );
  //                 }
  //               }
  //             });
  //       }),
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         verificationId = verificationId;
  //       });

  //   await user?.reload();
  //   return user;
  // }

  @override
  Future<void> updateDisplayName(String displayName, BuildContext context) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(displayName).then((value) => showOkToast(text: UpdateTexts.nameUpdateSuccess));
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);
      return await documentReference.update({
        'name': displayName,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        await showErrorDialog(context, ErrorTexts.tooManyRequests);
      } else if (e.code == 'internal-error') {
        await showErrorDialog(
          context,
          ErrorTexts.internalError,
        );
      } else if (e.code == 'network-request-failed') {
        await showErrorDialog(
          context,
          ErrorTexts.networkError,
        );
      } else {
        await showErrorDialog(
          context,
          ErrorTexts.error,
        );
      }
    }
  }

  @override
  Future<void> updateEmail(BuildContext context, String newEmail, String currentEmail, String currentPassword) async {
    try {
      final credential = EmailAuthProvider.credential(email: currentEmail, password: currentPassword);
      final authResult = await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
      final user = authResult?.user;
      await user?.updateEmail(newEmail).then((value) => showOkToast(text: UpdateTexts.emailUpdateSuccess));
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
      await userDoc.update({'email': newEmail});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        await showErrorDialog(
          context,
          ErrorTexts.wrongPassword,
        );
      } else if (e.code == 'email-already-in-use') {
        await showErrorDialog(
          context,
          ErrorTexts.emailAlreadyUse,
        );
      } else if (e.code == 'user-not-found') {
        await showErrorDialog(context, ErrorTexts.userNotFound);
      } else if (e.code == 'invalid-email') {
        await showErrorDialog(context, ErrorTexts.invalidEmail);
      } else if (e.code == 'invalid-verification-code') {
        await showErrorDialog(
          context,
          ErrorTexts.invalidVerificationCode,
        );
      } else if (e.code == 'too-many-requests') {
        await showErrorDialog(
          context,
          ErrorTexts.tooManyRequests,
        );
      } else if (e.code == 'internal-error') {
        await showErrorDialog(
          context,
          ErrorTexts.internalError,
        );
      } else if (e.code == 'network-request-failed') {
        await showErrorDialog(
          context,
          ErrorTexts.networkError,
        );
      } else if (e.code == 'invalid-verification-code') {
        await showErrorDialog(
          context,
          ErrorTexts.invalidVerificationId,
        );
      } else {
        await showErrorDialog(
          context,
          ErrorTexts.error,
        );
      }
    }
  }

  @override
  Future<void> updatePassword(BuildContext context, String email, String currentPassword, String newPassword) async {
    try {
      final credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      final authResult = await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
      final user = authResult?.user;
      await user?.updatePassword(newPassword).then((value) => showOkToast(text: UpdateTexts.passwordUpdateSuccess));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        await showErrorDialog(
          context,
          ErrorTexts.wrongPassword,
        );
      } else if (e.code == 'weak-password') {
        await showErrorDialog(
          context,
          ErrorTexts.weakPassword,
        );
      } else if (e.code == 'user-not-found') {
        await showErrorDialog(
          context,
          ErrorTexts.userNotFound,
        );
      } else if (e.code == 'invalid-email') {
        await showErrorDialog(
          context,
          ErrorTexts.invalidEmail,
        );
      } else if (e.code == 'invalid-verification-code') {
        await showErrorDialog(
          context,
          ErrorTexts.invalidVerificationCode,
        );
      } else if (e.code == 'too-many-requests') {
        await showErrorDialog(
          context,
          ErrorTexts.tooManyRequests,
        );
      } else if (e.code == 'internal-error') {
        await showErrorDialog(
          context,
          ErrorTexts.internalError,
        );
      } else if (e.code == 'network-request-failed') {
        await showErrorDialog(
          context,
          ErrorTexts.networkError,
        );
      } else if (e.code == 'invalid-verification-code') {
        await showErrorDialog(
          context,
          ErrorTexts.invalidVerificationId,
        );
      } else {
        await showErrorDialog(
          context,
          ErrorTexts.error,
        );
      }
    }
  }
}
