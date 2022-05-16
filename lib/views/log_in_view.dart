import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrms/main.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/storage/dialog_storage.dart';
import 'package:hrms/storage/string_storage.dart';
import 'package:hrms/storage/validation_storage.dart';
import 'package:hrms/themes/padding.dart';

import '../storage/text_storage.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool _isPasswordVisible;
  String? value;
  bool isChecked = false;
  late Box box1;

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _isPasswordVisible = false;
    createOpenBox();
    super.initState();
  }

  void isVisable() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void getdata() async {
    if (box1.get('email') != null) {
      _emailController.text = box1.get('email');
      isChecked = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Text(
                      AuthStatusTexts.signIn,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    _emailInput(),
                    _passwordInput(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: ThemeMode.dark == Hrms.themeNotifier.value
                              ? Colors.deepOrangeAccent.shade200
                              : Colors.blueAccent.shade100,
                          value: isChecked,
                          onChanged: (value) {
                            isChecked = !isChecked;
                            setState(() {});
                          },
                        ),
                        TextButton(
                            child: const Text(
                              "Beni hatırla",
                            ),
                            onPressed: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        _goToSingUp(context),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            await Navigator.pushNamed(context, '/forgot');
                          },
                          child: Text(AuthStatusTexts.forgotPassword),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _loginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;
        if (_formKey.currentState!.validate()) {
          Future.delayed(
            const Duration(seconds: 2),
          );
          try {
            await AuthService.firebase().logIn(
              email: email,
              password: password,
            );
            const Center(child: CircularProgressIndicator());
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/main');
            }
            if (isChecked) {
              box1.put('email', _emailController.text);
            } else {
              box1.delete('email');
            }
          } on UserNotFoundAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.userNotFound,
            );
          } on WrongPasswordAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.wrongPassword,
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
      child: Text(AuthStatusTexts.signIn),

      // hoverColor: Colors.blue,
    );
  }

  TextButton _goToSingUp(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/singup');
      },
      child: Text(
        AuthStatusTexts.noAccount,
      ),
    );
  }

  Padding _passwordInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: HintTexts.passwordHint,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              isVisable();
            },
          ),
        ),
        validator: ValidationConstants.loginPassowrdValidator,
        onChanged: (value) => userPassword = value,
      ),
    );
  }

  Padding _emailInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        autofillHints: const [AutofillHints.email],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: _emailController,
        decoration: InputDecoration(
          hintText: HintTexts.emailHint,
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        validator: ValidationConstants.emailValidator,
        onChanged: (value) => userMail = value,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
