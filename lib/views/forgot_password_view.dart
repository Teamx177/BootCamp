import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/strings.dart';
import 'package:hrms/static_storage/texts.dart';
import 'package:hrms/themes/padding.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({Key? key}) : super(key: key);

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();
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
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    AuthStatusTexts.forgotPassword,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  _emailInput(),
                  const SizedBox(
                    height: 20,
                  ),
                  _sendButton(context)
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _emailInput() {
    return TextFormField(
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
    );
  }

  ElevatedButton _sendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        try {
          if (_formKey.currentState!.validate()) {
            await AuthService.firebase().sendPasswordReset(
              email: email,
            );
          }
        } on UserNotFoundAuthException {
          showErrorDialog(
            context,
            ErrorTexts.userNotFound,
          );
        } on GenericAuthException {
          showErrorDialog(
            context,
            ErrorTexts.error,
          );
        }
      },
      child: Text(AuthStatusTexts.send),
    );
  }
}
