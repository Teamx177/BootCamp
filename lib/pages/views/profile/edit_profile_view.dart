import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/models/user.dart';
import 'package:hrms/core/services/auth/auth_exceptions.dart';
import 'package:hrms/core/services/auth/auth_service.dart';
import 'package:hrms/core/storage/dialog_storage.dart';
import 'package:hrms/core/storage/firebase.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/storage/validation_storage.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/views/auth/widgets/form_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _newEmailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _newPasswordController;

  late String _city = "Ankara";
  late bool updatePhone;
  late String name;

  Stream<UserModel> getUser(String? uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDocuments(snapshot));
  }

  @override
  void initState() {
    getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _newEmailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    updatePhone = false;
    super.initState();
  }

  void editPhone() {
    setState(() {
      updatePhone = !updatePhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    _emailController.value = _emailController.value
                        .copyWith(text: snapshot.data?.get('email'));
                    return !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : Card(
                            borderOnForeground: true,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Profil Bilgileri',
                                    style: GoogleFonts.rubik(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      height: ProjectPadding.inputBoxHeight),
                                  _updateName(snapshot, context),
                                  SizedBox(
                                      height: ProjectPadding.inputBoxHeight),
                                  _updateEmail(snapshot, context),
                                  SizedBox(
                                      height: ProjectPadding.inputBoxHeight),
                                  _updatePhone(snapshot, context),
                                  SizedBox(
                                      height: ProjectPadding.inputBoxHeight),
                                  _updatePassword(context),
                                  SizedBox(
                                      height: ProjectPadding.inputBoxHeight),
                                  _updateCity(snapshot, context),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      router.pop();
                                    },
                                    child: const Text('Geriye Dön'),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Padding _updatePassword(BuildContext context) {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: PasswordFormField(
              enabled: false,
              initialValue: ('************'),
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(UpdateTexts.passwordUpdate),
                        content: Form(
                          key: _passwordKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PasswordFormField(
                                hintText: HintTexts.currentPassword,
                                controller: _passwordController,
                                validator:
                                    ValidationConstants.loginPasswordValidator,
                              ),
                              PasswordFormField(
                                hintText: HintTexts.newPassword,
                                controller: _newPasswordController,
                                validator:
                                    ValidationConstants.loginPasswordValidator,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AuthStatusTexts.cancel),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (_passwordKey.currentState!.validate()) {
                                  final email = _emailController.value.text;
                                  final currentPassword =
                                      _passwordController.text;
                                  final newPassword =
                                      _newPasswordController.text;

                                  try {
                                    await AuthService.firebase()
                                        .updatePassword(
                                          email,
                                          currentPassword,
                                          newPassword,
                                        )
                                        .then((_) => showSuccessDialog(
                                                context,
                                                UpdateTexts
                                                    .passwordUpdateSuccess)
                                            .then(
                                                (_) => Navigator.pop(context)));
                                  } on WrongPasswordAuthException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.wrongPassword,
                                    );
                                  } on WeakPasswordAuthException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.weakPassword,
                                    );
                                  } on UserNotFoundAuthException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.userNotFound,
                                    );
                                  } on InvalidEmailAuthException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.invalidEmail,
                                    );
                                  } on InvalidVerificationCode {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.invalidVerificationCode,
                                    );
                                  } on TooManyRequestsAuthException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.tooManyRequests,
                                    );
                                  } on InternalErrorException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.internalError,
                                    );
                                  } on NetworkErrorException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.networkError,
                                    );
                                  } on InvalidVerificationId {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.invalidVerificationId,
                                    );
                                  } on GenericAuthException {
                                    await showErrorDialog(
                                      context,
                                      ErrorTexts.error,
                                    );
                                  }
                                }
                              },
                              child: Text(AuthStatusTexts.confirm)),
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _updateName(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot, BuildContext context) {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: NameFormField(
              hintText: snapshot.data?.get('name') ?? '',
              enabled: false,
              onChanged: (value) {
                setState(() {
                  _nameController.text = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(UpdateTexts.nameUpdate),
                      content: Form(
                        key: _emailKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NameFormField(
                              controller: _nameController,
                              hintText: HintTexts.nameHint,
                              onChanged: (value) {
                                setState(() {
                                  _nameController.text = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AuthStatusTexts.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_nameController.text.isNotEmpty) {
                              try {
                                await AuthService.firebase()
                                    .updateDisplayName(
                                        _nameController.text, context)
                                    .then((_) => showSuccessDialog(context,
                                            UpdateTexts.nameUpdateSuccess)
                                        .then((_) => Navigator.pop(context))
                                        .then((_) => user?.reload()));
                              } on InternalErrorException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.internalError,
                                );
                              } on NetworkErrorException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.networkError,
                                );
                              } on GenericAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.error,
                                );
                              }
                            } else {
                              await showErrorDialog(
                                context,
                                ErrorTexts.nameEmpty,
                              );
                            }
                          },
                          child: Text(AuthStatusTexts.confirm),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _updateEmail(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot, BuildContext context) {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: EmailFormField(
              enabled: false,
              hintText: snapshot.data?.get('email') ?? '',
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(UpdateTexts.emailUpdate),
                      content: Form(
                        key: _emailKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            EmailFormField(
                              controller: _newEmailController,
                              hintText: HintTexts.newEmail,
                            ),
                            PasswordFormField(
                              controller: _passwordController,
                              obscureText: true,
                              hintText: HintTexts.passwordHint,
                              validator:
                                  ValidationConstants.loginPasswordValidator,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AuthStatusTexts.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            final email = _emailController.text;
                            final newEmail = _newEmailController.text;
                            final password = _passwordController.text;
                            if (_emailKey.currentState!.validate()) {
                              try {
                                AuthService.firebase()
                                    .updateEmail(newEmail, email, password)
                                    .then((_) => showSuccessDialog(context,
                                            UpdateTexts.emailUpdateSuccess)
                                        .then((_) => Navigator.pop(context)));
                              } on WrongPasswordAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.wrongPassword,
                                );
                              } on WeakPasswordAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.weakPassword,
                                );
                              } on UserNotFoundAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.userNotFound,
                                );
                              } on InvalidEmailAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.invalidEmail,
                                );
                              } on InvalidVerificationCode {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.invalidVerificationCode,
                                );
                              } on TooManyRequestsAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.tooManyRequests,
                                );
                              } on InternalErrorException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.internalError,
                                );
                              } on EmailAlreadyInUseAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.emailAlreadyUse,
                                );
                              } on NetworkErrorException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.networkError,
                                );
                              } on InvalidVerificationId {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.invalidVerificationId,
                                );
                              } on GenericAuthException {
                                await showErrorDialog(
                                  context,
                                  ErrorTexts.error,
                                );
                              }
                            }
                          },
                          child: Text(AuthStatusTexts.confirm),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _updateCity(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot, BuildContext context) {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: CityFormField(
              enabled: false,
              hintText: snapshot.data?.get('city') ?? '',
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Şehirinizi seçiniz"),
                      content: Form(
                        key: _emailKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField(
                              value: snapshot.data?.get('city').toString(),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.location_on),
                                prefixText: "Şehir: ",
                                constraints: BoxConstraints(maxWidth: 300),
                              ),
                              items: DropdownTexts.cities.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _city = value!;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AuthStatusTexts.cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(snapshot.data?.id)
                                .update({'city': _city}).then((_) =>
                                    showSuccessDialog(context,
                                            UpdateTexts.cityUpdateSuccess)
                                        .then((_) => Navigator.pop(context)));
                            setState(() {});
                          },
                          child: Text(AuthStatusTexts.confirm),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _updatePhone(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot, BuildContext context) {
    String phone = '${snapshot.data?.get('phone')}';
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: PhoneFormField(
              enabled: updatePhone,
              hintText: phone.substring(3),
              onChanged: (value) {
                setState(() {
                  _phoneController.text = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: !updatePhone
                  ? const Icon(Icons.edit_outlined)
                  : const Icon(Icons.save_as_outlined),
              onPressed: () async {
                setState(() {
                  editPhone();
                });
                if (_phoneController.text.length == 10 && updatePhone) {
                  try {
                    await AuthService.firebase()
                        .updatePhone(('+90${_phoneController.text}'), context);
                  } on InvalidVerificationId {
                    await showErrorDialog(
                      context,
                      ErrorTexts.invalidVerificationId,
                    );
                  } on InvalidVerificationCode {
                    await showErrorDialog(
                      context,
                      ErrorTexts.invalidVerificationCode,
                    );
                  } on TooManyRequestsAuthException {
                    await showErrorDialog(
                      context,
                      ErrorTexts.tooManyRequests,
                    );
                  } on InternalErrorException {
                    await showErrorDialog(
                      context,
                      ErrorTexts.internalError,
                    );
                  } on NetworkErrorException {
                    await showErrorDialog(
                      context,
                      ErrorTexts.networkError,
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      ErrorTexts.error,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _newEmailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
