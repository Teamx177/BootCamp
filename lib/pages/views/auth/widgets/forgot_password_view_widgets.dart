import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hireme/core/services/auth/auth_exceptions.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/storage/dialog_storage.dart';
import 'package:hireme/core/storage/text_storage.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/core/themes/text_theme.dart';
import 'package:hireme/pages/views/auth/widgets/form_field.dart';

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
                style: textThemes.headline5,
              ),
              const SizedBox(
                height: 30,
              ),
              EmailFormField(
                controller: _emailController,
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
                      showOkToast(
                          text:
                              'Şifrenizi sıfırlamanız için mail gönderildi. Lütfen mailinizi ve spam klasörünü kontrol ediniz.');
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
