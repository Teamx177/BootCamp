import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/services/auth/auth_exceptions.dart';
import 'package:hrms/core/services/auth/auth_service.dart';
import 'package:hrms/core/storage/dialog_storage.dart';
import 'package:hrms/core/storage/string_storage.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/themes/dark_theme.dart';
import 'package:hrms/core/themes/light_theme.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/views/auth/widgets/form_field.dart';

// class BackgroundImage extends StatelessWidget {
//   Widget child;

//   BackgroundImage({Key? key, required this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/d.png'),
//         ),
//       ),
//       child: child,
//     );
//   }
// }

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                AuthStatusTexts.forgotPassword,
                style: darkMode
                    ? DarkTheme().theme.textTheme.headline5
                    : LightTheme().theme.textTheme.headline5,
              ),
              const SizedBox(
                height: 30,
              ),
              EmailFormField(
                controller: _emailController,
                onChanged: (value) => userMail = value,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text(AuthStatusTexts.goToLogin),
              ),
              SizedBox(
                height: ProjectPadding.inputBoxHeight,
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  if (_formKey.currentState!.validate()) {
                    try {
                      await AuthService.firebase().sendPasswordReset(
                        email: email,
                      );
                      await showSuccessDialog(
                        context,
                        AuthStatusTexts.forgotPassword,
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
                child: Text(AuthStatusTexts.send),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
