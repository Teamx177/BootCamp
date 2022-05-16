import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/storage/text_storage.dart';
import 'package:hrms/themes/lib_color_schemes.g.dart';

class backgroundImage extends StatelessWidget {
  Widget child;

  backgroundImage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/forgott.png'),
        ),
      ),
      child: child,
    );
  }
}

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
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.dst,
              color: lightColorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              AuthStatusTexts.forgotPassword,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            controller: _emailController,
            decoration: InputDecoration(
              hintText: HintTexts.emailHint,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: ValidationConstants.emailValidator,
            onChanged: (value) => userMail = value,
          ),
          const SizedBox(
            height: 20,
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
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    ErrorTexts.error,
                  );
                }
              }
            },
            child: Text(AuthStatusTexts.send),
          )
        ],
      ),
    );
  }
}
