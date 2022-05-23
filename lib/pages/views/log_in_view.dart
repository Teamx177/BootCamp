import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hrms/core/services/auth/auth_exceptions.dart';
import 'package:hrms/core/services/auth/auth_service.dart';
import 'package:hrms/core/storage/dialog_storage.dart';
import 'package:hrms/core/storage/string_storage.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/storage/validation_storage.dart';
import 'package:hrms/core/themes/light_theme.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/widgets/form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  // final TextEditingController _phoneController = TextEditingController();
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

  void isVisible() {
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
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      AuthStatusTexts.signIn,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Card(
                      borderOnForeground: true,
                      color: LightTheme().theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            _emailInput(),
                            SizedBox(height: ProjectPadding.inputBoxHeight),
                            _passwordInput(),
                            // const Text('Or Sign In With'),
                            // _phoneInput(),
                            SizedBox(height: ProjectPadding.inputBoxHeight),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: darkMode
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
                                    context.push('/forgot');
                                  },
                                  child: Text(AuthStatusTexts.forgotPassword),
                                ),
                              ],
                            ),

                            _loginButton(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextButton _goToSingUp(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push('/singup');
      },
      child: Text(
        AuthStatusTexts.noAccount,
      ),
    );
  }

  PasswordFormField _passwordInput() {
    return PasswordFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      validator: ValidationConstants.loginPassowrdValidator,
      onChanged: (value) => userPassword = value,
      textInputAction: TextInputAction.done,
    );
  }

  EmailFormField _emailInput() {
    return EmailFormField(
      controller: _emailController,
      onChanged: (value) => userMail = value,
    );
  }

// Will added on next update
  // Padding _phoneInput() {
  //   return Padding(
  //       padding: ProjectPadding.inputPaddingVertical,
  //       child: PhoneFormField(
  //         controller: _phoneController,
  //         onChanged: (value) => userPhoneNumber = value,
  //       ));
  // }

  Padding _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () async {
          final email = _emailController.text;
          final password = _passwordController.text;
          // final phoneNumber = _phoneController.text;
          if (_formKey.currentState!.validate()) {
            try {
              await AuthService.firebase().logIn(
                email: email,
                password: password,
              );
              // Still in progress
              // var credentinal =
              //     EmailAuthProvider.credential(email: email, password: password);
              // await FirebaseAuth.instance.currentUser
              //     ?.linkWithCredential(credentinal);
              // await AuthService.firebase().phoneSignUp(
              //   phoneNumber: phoneNumber,
              //   context: context,
              // );
              const Center(child: CircularProgressIndicator());
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                context.go('/home');
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
