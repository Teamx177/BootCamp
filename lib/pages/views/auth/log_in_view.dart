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
import 'package:hive_flutter/hive_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String? value;
  late bool isChecked;
  late Box box1;
  late bool _isLoading;

  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
    getdata();
  }

  void _load() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    isChecked = false;
    _isLoading = false;
    createOpenBox();
    super.initState();
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
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _key,
                  child: Center(
                    child: Card(
                      borderOnForeground: true,
                      child: Padding(
                        padding: ProjectPadding.cardPadding,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              AuthStatusTexts.signIn,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            _emailInput(),
                            SizedBox(height: ProjectPadding.inputBoxHeight),
                            _passwordInput(),
                            SizedBox(height: ProjectPadding.inputBoxHeight),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
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
                                _goToForgot(context),
                                const Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    context.push('/forgotPassword');
                                  },
                                  child: Text(AuthStatusTexts.forgotPassword),
                                ),
                              ],
                            ),
                            _loginButton(context),
                            SizedBox(
                              height: ProjectPadding.inputBoxHeight,
                            ),
                            const Text('- YA DA -'),
                            SizedBox(
                              height: ProjectPadding.inputBoxHeight,
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                context.push('/phoneLogin');
                              },
                              child: const Icon(Icons.phone_iphone_outlined),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton _goToForgot(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push('/register');
      },
      child: Text(
        AuthStatusTexts.noAccount,
      ),
    );
  }

  PasswordFormField _passwordInput() {
    return PasswordFormField(
      controller: _passwordController,
      hintText: HintTexts.passwordHint,
      validator: ValidationConstants.loginPasswordValidator,
      // onChanged: (value) => _passwordController.text = value,
      textInputAction: TextInputAction.done,
    );
  }

  EmailFormField _emailInput() {
    return EmailFormField(
      controller: _emailController,
      hintText: HintTexts.emailHint,
    );
  }

  Padding _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () async {
          final email = _emailController.text;
          final password = _passwordController.text;
          if (_key.currentState!.validate()) {
            try {
              await AuthService.firebase()
                  .logIn(
                    email: email,
                    password: password,
                  )
                  .then((value) => _load());
              const Center(child: CircularProgressIndicator());
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                router.go('/home');
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
        child: _isLoading
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
            : Text(AuthStatusTexts.signIn),
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
