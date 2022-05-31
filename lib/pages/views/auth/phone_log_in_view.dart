import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/services/auth/auth_exceptions.dart';
import 'package:hrms/core/services/auth/auth_service.dart';
import 'package:hrms/core/storage/dialog_storage.dart';
import 'package:hrms/core/storage/string_storage.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/views/auth/widgets/form_field.dart';

class PhoneLoginView extends StatefulWidget {
  const PhoneLoginView({Key? key}) : super(key: key);

  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
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
                            SizedBox(height: ProjectPadding.inputBoxHeight),
                            _phoneInput(),
                            SizedBox(height: ProjectPadding.inputBoxHeight),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [],
                            ),
                            Row(
                              children: [
                                _goToSingUp(context),
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

  TextButton _goToSingUp(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push('/register');
      },
      child: Text(
        AuthStatusTexts.noAccount,
      ),
    );
  }

// Will added on next update
  Padding _phoneInput() {
    return Padding(
        padding: ProjectPadding.inputPaddingVertical,
        child: PhoneFormField(
          controller: _phoneController,
          onChanged: (value) => userPhoneNumber = value,
        ));
  }

  Padding _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () async {
          final phoneNumber = ('+90${_phoneController.text}');
          if (_formKey.currentState!.validate()) {
            try {
              await AuthService.firebase()
                  .phoneLogin(phoneNumber: phoneNumber, context: context);
              const Center(child: CircularProgressIndicator());
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                router.go('/home');
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
            } on TooManyRequestsAuthException {
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
}
