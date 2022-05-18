import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/storage/dialog_storage.dart';
import 'package:hrms/storage/string_storage.dart';
import 'package:hrms/storage/validation_storage.dart';
import 'package:hrms/themes/padding.dart';

import '../storage/firebase.dart';
import '../storage/text_storage.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({Key? key}) : super(key: key);

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  final _employeeFormKey = GlobalKey<FormState>();
  final _employerFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  late bool _isPasswordVisible;
  late bool _isPasswordConfirmVisible;
  late bool _isEmployer;
  late bool _isButtonEnabled;
  late int _index;
  late String _selectedGender;
  late String _city;
  late List<String> _cities;

  @override
  void initState() {
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _isPasswordVisible = false;
    _isPasswordConfirmVisible = false;
    _isEmployer = false; // default employee
    _isButtonEnabled = false;
    _index = 0;
    _selectedGender = 'male';
    _city = 'Ankara';
    _cities = ['Ankara', 'İstanbul', 'İzmir'];
    isButtonEnabledListener();
    super.initState();
  }

  void isButtonEnabledListener() {
    _nameController.addListener(() {
      inputListener();
    });

    _phoneNumberController.addListener(() {
      inputListener();
    });
  }

  void inputListener() {
    var name = _nameController.text;
    var phoneNumber = _phoneNumberController.text;
    if (name.trim().isNotEmpty &&
        phoneNumber.trim().isNotEmpty &&
        RegExp(r'^5(?:9)?[0-9]{9}$').hasMatch(phoneNumber)) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  void isVisible() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void isVisibleConfirm() {
    setState(() {
      _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
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
              AnimatedToggleSwitch<bool>.dual(
                current: _isEmployer,
                first: true,
                second: false,
                dif: 50.0,
                borderColor: const Color.fromARGB(255, 99, 121, 146),
                borderWidth: 2,
                height: 55,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  ),
                ],
                onChanged: (b) => setState(() => _isEmployer = b),
                colorBuilder: (b) => b ? Colors.red : Colors.green,
                iconBuilder: (value) =>
                    value ? const Icon(Icons.work) : const Icon(Icons.person),
                textBuilder: (value) => value
                    ? const Center(child: Text('İş veren'))
                    : const Center(child: Text('İş arayan')),
              ),
              SingleChildScrollView(
                child: _isEmployer ? employer(context) : employee(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column employee(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _employeeFormKey,
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
                height: 30,
              ),
              _emailInput(),
              _passwordInput(),
              _passwordControlInput(),
              _alreadyHaveAccountButton(),
              const SizedBox(
                height: 20,
              ),
              _registerButton("employee"),
            ],
          ),
        ),
      ],
    );
  }

  Column employer(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _employerFormKey,
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  employerTextButton1(),
                  employerTextButton2(),
                ],
              ),
              employerColumn(),
              const SizedBox(
                height: 20,
              ),
              _index == 0 ? employerElevatedButton() : _registerButton("employer"),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton employerElevatedButton() {
    return ElevatedButton(
        onPressed: _isButtonEnabled
            ? () {
                setState(() {
                  _index = 1;
                });
              }
            : null,
        child: const Text("Devam"));
  }

  Column employerColumn() {
    return Column(
      children: _index == 0
          ? [
              _nameInput(),
              _phoneNumberInput(),
              _cityDropDownButton(),
              _genderRadioButton(),
            ]
          : [
              _emailInput(),
              _passwordInput(),
              _passwordControlInput(),
              _alreadyHaveAccountButton(),
            ],
    );
  }

  TextButton employerTextButton1() {
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

  TextButton employerTextButton2() {
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
          color: _index == 1 || _isButtonEnabled
              ? const Color.fromARGB(255, 244, 67, 54)
              : Colors.grey,
          fontSize: _index == 1 ? 27 : 16,
        ),
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
          prefixText: "Şehir: ",
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          constraints: BoxConstraints(maxWidth: 300),
        ),
        items: _cities.map((String items) {
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
      child: TextFormField(
        controller: _nameController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: HintTexts.nameHint,
          prefixIcon: const Icon(Icons.person_outlined),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return ValidateTexts.emptyName;
          }
          return null;
        },
        onChanged: (value) => userName = value,
      ),
    );
  }

  Padding _emailInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: HintTexts.emailHint,
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return ValidateTexts.emptyEmail;
          }
          // Mail adresinin geçerli formatında olup olmadığını kontrol ediyoruz.
          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return ValidateTexts.emailNotValid;
          }
          return null;
        },
        onChanged: (value) => userMail = value,
      ),
    );
  }

  Padding _phoneNumberInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        controller: _phoneNumberController,
        decoration: InputDecoration(
          hintText: HintTexts.phoneNumberHint,
          prefixIcon: const Icon(Icons.phone),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return ValidateTexts.emptyPhoneNumber;
          }
          if (!RegExp(r'^5(?:9)?[0-9]{9}$').hasMatch(value)) {
            return ValidateTexts.phoneNumberNotValid;
          }
          return null;
        },
        onChanged: (value) => userPhoneNumber = value,
      ),
    );
  }

  Padding _passwordInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        controller: _passwordController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: HintTexts.passwordHint,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(
                () {
                  isVisible();
                },
              );
            },
          ),
        ),
        obscureText: !_isPasswordVisible,
        validator: ValidationConstants.singUpPasswordValidator,
        onChanged: (value) => userPassword = value,
      ),
    );
  }

  Padding _passwordControlInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        controller: _passwordConfirmController,
        obscureText: !_isPasswordConfirmVisible,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: HintTexts.passwordControlHint,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _isPasswordConfirmVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                isVisibleConfirm();
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ValidateTexts.emptyPasswordControl;
          }

          if (value != userPassword) {
            return ValidateTexts.passwordNotMatch;
          }

          return null;
        },
        onChanged: (value) => userPasswordConfirm = value,
      ),
    );
  }

  TextButton _alreadyHaveAccountButton() => TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        child: Text(AuthStatusTexts.hasAccount),
      );

  ElevatedButton _registerButton(type) {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;
        final name = _nameController.text;
        final phoneNumber = _phoneNumberController.text;
        if (_isEmployer
            ? _employerFormKey.currentState!.validate()
            : _employeeFormKey.currentState!.validate()) {
          try {
            var employer = await AuthService.firebase().createUser(
              email: email,
              password: password,
            );
            await firestore.collection("users").doc(employer.uid).set({
              "name": name,
              "email": email,
              "phone": phoneNumber,
              "gender": _selectedGender,
              "city": _city,
              "type": type,
            });
            await AuthService.firebase().sendEmailVerification();
            await showSuccessDialog(
              context,
              AuthStatusTexts.successRegister,
            );
            await Navigator.pushNamed(context, '/login');
          } on EmailAlreadyInUseAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.emailAlreadyUse,
            );
          } on GenericAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.error,
            );
          }
        }
      },
      child: Text(AuthStatusTexts.signUp),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
}
