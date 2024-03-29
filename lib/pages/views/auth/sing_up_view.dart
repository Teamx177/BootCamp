import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hireme/core/managers/route_manager.dart';
import 'package:hireme/core/services/auth/auth_exceptions.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/storage/dialog_storage.dart';
import 'package:hireme/core/storage/text_storage.dart';
import 'package:hireme/core/storage/validation_storage.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/pages/views/auth/widgets/form_field.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({Key? key}) : super(key: key);

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  final _userFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  late bool _isButtonEnabled;
  late int _index;
  late String _selectedGender;
  late String _city;
  late String _userType;
  late List<String> _userTypes;
  Random random = Random();
  int? randomNumber;
  late bool _isLoading;

  void _load() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    randomNumber = random.nextInt(16);
    _userType = 'İş Arayan';
    _isLoading = false;
    _isButtonEnabled = false;
    _index = 0;
    _selectedGender = 'male';
    _city = 'Ankara';
    _userTypes = ['İş Arayan', 'İş Veren'];
    isButtonEnabledListener();
    super.initState();
  }

  void isButtonEnabledListener() {
    _nameController.addListener(() {
      var name = _nameController.text;
      if (name.trim().isNotEmpty) {
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _isButtonEnabled = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  borderOnForeground: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: userForm(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form userForm(BuildContext context) {
    return Form(
      key: _userFormKey,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            AuthStatusTexts.createAnAccount,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              userTextButton1(),
              userTextButton2(),
            ],
          ),
          userColumn(),
          const SizedBox(
            height: 10,
          ),
          _index == 0 ? userElevatedButton() : _registerButton(),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  ElevatedButton userElevatedButton() {
    return ElevatedButton(
      onPressed: _isButtonEnabled
          ? () {
              setState(() {
                _index = 1;
              });
            }
          : null,
      child: const Text("Devam"),
    );
  }

  Column userColumn() {
    return Column(
      children: _index == 0
          ? [
              _nameInput(),
              _userTypeDropDown(),
              _cityDropDownButton(),
              _genderRadioButton(),
              _alreadyHaveAccountButton(),
            ]
          : [
              _emailInput(),
              _phoneNumberInput(),
              _passwordInput(),
              _passwordControlInput(),
              _alreadyHaveAccountButton(),
            ],
    );
  }

  TextButton userTextButton1() {
    return TextButton(
      onPressed: _index == 1
          ? () {
              setState(() {
                _index = 0;
              });
            }
          : null,
      child: RichText(
        text: TextSpan(
            style: TextStyle(
              color: _index == 0 ? const Color.fromARGB(255, 244, 67, 54) : Colors.grey,
              fontSize: _index == 0 ? 27 : 16,
            ),
            children: [
              _index == 0
                  ? const TextSpan(
                      text: "1",
                    )
                  : const WidgetSpan(
                      child: Icon(
                        Icons.arrow_back,
                        size: 19,
                        color: Color.fromARGB(255, 244, 67, 54),
                      ),
                    ),
            ]),
      ),
    );
  }

  TextButton userTextButton2() {
    return TextButton(
      onPressed: _isButtonEnabled && _index == 0
          ? () {
              setState(() {
                _index = 1;
              });
            }
          : null,
      child: Text(
        "2",
        style: TextStyle(
          color: _index == 1 || _isButtonEnabled ? const Color.fromARGB(255, 244, 67, 54) : Colors.grey,
          fontSize: _index == 1 ? 27 : 16,
        ),
      ),
    );
  }

  Padding _userTypeDropDown() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: DropdownButtonFormField(
        value: _userType,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.supervised_user_circle_rounded),
          labelText: 'Kullanıcı Tipi',
        ),
        items: _userTypes.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _userType = value!;
          });
        },
      ),
    );
  }

  Padding _cityDropDownButton() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: DropdownButtonFormField(
        value: _city,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.location_on),
          labelText: 'Şehir',
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
      ),
    );
  }

  Padding _genderRadioButton() {
    return Padding(
        padding: ProjectPadding.inputPaddingVertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Lütfen Cinsiyetinizi Belirtiniz:'),
            ListTile(
              leading: Radio<String>(
                value: 'male',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              title: const Text('Erkek'),
            ),
            ListTile(
              leading: Radio<String>(
                value: 'female',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    // (((())))) {{{}}}} [[]]
                    _selectedGender = value!;
                  });
                },
              ),
              title: const Text('Kadın'),
            ),
          ],
        ));
  }

  Padding _nameInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: NameFormField(
        controller: _nameController,
      ),
    );
  }

  Padding _emailInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: EmailFormField(
        hintText: HintTexts.emailHint,
        controller: _emailController,
      ),
    );
  }

  Padding _phoneNumberInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: PhoneFormField(
        controller: _phoneNumberController,
      ),
    );
  }

  Padding _passwordInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: PasswordFormField(
        hintText: HintTexts.passwordHint,
        controller: _passwordController,
        validator: ValidationConstants.singUpPasswordValidator,
      ),
    );
  }

  Padding _passwordControlInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: ConfirmPasswordFormField(
        controller: _passwordConfirmController,
        hintText: HintTexts.passwordControlHint,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ValidateTexts.emptyPasswordControl;
          }
          if (value != _passwordController.text) {
            return ValidateTexts.passwordNotMatch;
          }
          return null;
        },
      ),
    );
  }

  TextButton _alreadyHaveAccountButton() => TextButton(
        onPressed: () {
          context.push('/login');
        },
        child: Text(AuthStatusTexts.hasAccount),
      );

  ElevatedButton _registerButton() {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;
        final name = _nameController.text;
        final phoneNumber = ('+90${_phoneNumberController.text}');
        var type = _userType == 'İş Veren' ? 'employer' : 'employee';
        if (_userFormKey.currentState!.validate()) {
          try {
            await AuthService.firebase()
                .createUser(
                  email: email,
                  password: password,
                )
                .then((value) => _load());
            await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).set({
              'id': FirebaseAuth.instance.currentUser?.uid,
              "name": name,
              "email": email,
              "phone": phoneNumber,
              "gender": _selectedGender,
              "city": _city,
              "type": type,
              "picture": "assets/images/userPics/user$randomNumber.png"
            });
            await AuthService.firebase().sendEmailVerification();
            if (FirebaseAuth.instance.currentUser != null) {
              router.go('/home');
            }
          } on EmailAlreadyInUseAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.emailAlreadyUse,
            );
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
          } on CredentialAlreadyUse {
            await showErrorDialog(
              context,
              ErrorTexts.credentialAlreadyLinked,
            );
          } on GenericAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.error,
            );
          }
        }
      },
      child: _isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          : Text(
              AuthStatusTexts.signUp,
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
