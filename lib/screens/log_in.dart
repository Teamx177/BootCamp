import 'package:flutter/material.dart';
import 'package:hrms/bottom_screens/home_page.dart';
import 'package:hrms/screens/sing_up.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/strings.dart';
import 'package:hrms/themes/padding.dart';

import '../static_storage/texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      height: 120,
                    ),
                    _emailInput(),
                    const SizedBox(
                      height: 10,
                    ),
                    _passwordInput(),
                    const SizedBox(
                      height: 25,
                    ),
                    _goToSingUp(context),
                    const SizedBox(
                      height: 10,
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
          try {
            await AuthService.firebase().logIn(
              email: email,
              password: password,
            );
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            }
          } on UserNotFoundAuthException {
            await showErrorDialog(
              context,
              'Kullanıcı Bulunamadı',
            );
          } on WrongPasswordAuthException {
            await showErrorDialog(
              context,
              'Şifre Hatalı',
            );
          } on GenericAuthException {
            await showErrorDialog(
              context,
              'Bilinmeyen bir hata oluştu',
            );
          }
        }
      },
      child: Text(AuthStatusTexts.signIn),
    );
  }

  TextButton _goToSingUp(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SingUp(),
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
            hintText: 'Şifre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            )),
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
          hintText: 'example@gmail.com',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(Icons.email_outlined),
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
