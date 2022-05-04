import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/strings.dart';
import 'package:hrms/themes/padding.dart';
import 'package:hrms/views/main_screen_view.dart';
import 'package:hrms/views/sing_up_view.dart';

import '../static_storage/texts.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool isPasswordVisible;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    isPasswordVisible = false;
    super.initState();
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
                      height: 100,
                    ),
                    Text(
                      AuthStatusTexts.signIn,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    _emailInput(),
                    _passwordInput(),
                    Row(
                      children: [
                        _goToSingUp(context),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot');
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
    return ElevatedButton.icon(
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;
        if (_formKey.currentState!.validate()) {
          try {
            await AuthService.firebase().logIn(
              email: email,
              password: password,
            );
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainView(),
                ),
              );
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
          } on GenericAuthException {
            await showErrorDialog(
              context,
              ErrorTexts.error,
            );
          }
        }
      },
      label: Text(AuthStatusTexts.signIn),
      icon: const Icon(Icons.arrow_forward_sharp),
      // hoverColor: Colors.blue,
    );
  }

  TextButton _goToSingUp(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SingUpView(),
          ),
        );
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
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          hintText: HintTexts.passwordHint,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(
                () {
                  isPasswordVisible = !isPasswordVisible;
                },
              );
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return ValidateTexts.emptyPassword;
          }
          // Şifre en az 8 karakter gerektiriyor değişebilir.
          if (value.trim().length < 8) {
            return ValidateTexts.passwordLenght;
          }
          return null;
        },
        onChanged: (value) => userPassword = value,
      ),
    );
  }

  Padding _emailInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    print('dispose');
    super.dispose();
  }
}
