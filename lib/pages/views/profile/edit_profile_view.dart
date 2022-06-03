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

  final List<String> _cities = ['Ankara', 'İstanbul', 'İzmir'];
  late final String _city = 'Ankara';
  late bool updateEmail;
  late bool updateName;
  late bool updatePhone;
  late bool updatePassword;
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
    updateName = false;
    updateEmail = false;
    updatePhone = false;
    updatePassword = false;
    super.initState();
  }

  void editEmail() {
    setState(() {
      updateEmail = !updateEmail;
    });
  }

  void editName() {
    setState(() {
      updateName = !updateName;
    });
  }

  void editPhone() {
    setState(() {
      updatePhone = !updatePhone;
    });
  }

  void editPassword() {
    setState(() {
      updatePassword = !updatePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    var city1 = snapshot.data?.get('city');
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
                                  _updatePassword(context),
                                  SizedBox(
                                      height: ProjectPadding.inputBoxHeight),
                                  _updatePhone(snapshot, context),
                                  //did'n look for it
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 85,
                                        child: Padding(
                                          padding: ProjectPadding
                                              .inputPaddingVertical,
                                          child: DropdownButtonFormField(
                                            value: city1,
                                            decoration: const InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.location_on),
                                              prefixText: "Şehir: ",
                                              constraints:
                                                  BoxConstraints(maxWidth: 300),
                                            ),
                                            items: _cities.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                city1 = value;
                                                print(city1);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 15,
                                        child: IconButton(
                                          onPressed: () async {
                                            final userDoc = FirebaseFirestore
                                                .instance
                                                .collection('users')
                                                .doc(user?.uid);
                                            await userDoc.update({
                                              'city': city1,
                                            });
                                          },
                                          icon: const Icon(Icons.save),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                      onPressed: () {
                                        router.pop();
                                      },
                                      child: const Text('Geriye Dön')),
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
              enabled: updatePassword,
              initialValue: '************',
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: !updatePassword
                  ? const Icon(Icons.edit_outlined)
                  : const Icon(Icons.save_as_outlined),
              onPressed: () async {
                setState(() {
                  editPassword();
                });
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
                              EmailFormField(
                                controller: _emailController,
                                hintText: HintTexts.emailHint,
                              ),
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
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                editPassword();
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(AuthStatusTexts.cancel),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  editPassword();
                                });
                                if (_passwordKey.currentState!.validate()) {
                                  final email = _emailController.value.text;
                                  final currentPassword =
                                      _passwordController.text;
                                  final newPassword =
                                      _newPasswordController.text;

                                  try {
                                    await AuthService.firebase().updatePassword(
                                      email,
                                      currentPassword,
                                      newPassword,
                                    );
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
              initialValue: snapshot.data?.get('name'),
              enabled: updateName,
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
              icon: !updateName
                  ? const Icon(Icons.edit_outlined)
                  : const Icon(Icons.save_as_outlined),
              onPressed: () async {
                setState(() {
                  editName();
                });
                if (_nameController.text.isNotEmpty && !updateName) {
                  try {
                    await AuthService.firebase()
                        .updateDisplayName(_nameController.text, context);
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

  Padding _updateEmail(
      AsyncSnapshot<DocumentSnapshot<Object?>> snapshot, BuildContext context) {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: EmailFormField(
              enabled: updateEmail,
              initialValue: snapshot.data?.get('email'),
              onChanged: (value) {
                setState(() {
                  _emailController.text = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 15,
            child: IconButton(
              icon: !updateEmail
                  ? const Icon(Icons.edit_outlined)
                  : const Icon(Icons.save_as_outlined),
              onPressed: () async {
                setState(() {
                  editEmail();
                });
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
                              controller: _emailController,
                              hintText: HintTexts.currentMail,
                            ),
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
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              editEmail();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(AuthStatusTexts.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final email = _emailController.text;
                            final newEmail = _newEmailController.text;
                            final password = _passwordController.text;
                            if (_emailKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  editEmail();
                                });
                                try {
                                  AuthService.firebase()
                                      .updateEmail(newEmail, email, password)
                                      .then((_) => showSuccessDialog(context,
                                          UpdateTexts.emailUpdateSuccess));
                                } on FirebaseAuthException catch (e) {
                                  await showErrorDialog(context, e.toString());
                                }
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
    String phone = '${snapshot.data?.get('phone') ?? ''}';
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: Row(
        children: [
          Expanded(
            flex: 85,
            child: PhoneFormField(
              enabled: updatePhone,
              initialValue: phone.substring(3),
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
                if (_phoneController.text.length == 10 && !updatePhone) {
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
