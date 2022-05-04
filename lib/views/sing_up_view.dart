import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/strings.dart';
import 'package:hrms/static_storage/texts.dart';
import 'package:hrms/themes/padding.dart';
import 'package:hrms/views/log_in_view.dart';

class SingUpView extends StatefulWidget {
  const SingUpView({Key? key}) : super(key: key);

  @override
  State<SingUpView> createState() => _SingUpViewState();
}

class _SingUpViewState extends State<SingUpView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  late bool isPasswordVisible;
  late bool isPasswordConfirmVisible;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    isPasswordVisible = false;
    isPasswordConfirmVisible = false;
    super.initState();
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      AuthStatusTexts.createAnAccount,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _nameInput(),
                    _emailInput(),
                    _passwordInput(),
                    _passwordControlInput(),
                    _alreadyHaveAccountButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    _registerButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
        obscureText: !isPasswordVisible,
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

  Padding _passwordControlInput() {
    return Padding(
      padding: ProjectPadding.inputPaddingVertical,
      child: TextFormField(
        controller: _passwordConfirmController,
        obscureText: !isPasswordConfirmVisible,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            hintText: HintTexts.passwordControlHint,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                isPasswordConfirmVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  isPasswordConfirmVisible = !isPasswordConfirmVisible;
                });
              },
            )),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
          );
        },
        child: Text(AuthStatusTexts.hasAccount),
      );

  ElevatedButton _registerButton() {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        final password = _passwordController.text;
        if (_formKey.currentState!.validate()) {
          try {
            await AuthService.firebase().createUser(
              email: email,
              password: password,
            );
            await AuthService.firebase().sendEmailVerification();
            await showSuccessDialog(
              context,
              AuthStatusTexts.successRegister,
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ),
            );
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
