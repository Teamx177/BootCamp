import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/strings.dart';
import 'package:hrms/static_storage/texts.dart';
import 'package:hrms/static_storage/validate.dart';
import 'package:hrms/themes/lib_color_schemes.g.dart';
import 'package:hrms/themes/padding.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({Key? key}) : super(key: key);

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            // fit: BoxFit.contain,
            image: AssetImage('assets/images/forgott.png'),
          ),
        ),
        child: Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
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
      validator: ValidationConstants.emailValidator,
      onChanged: (value) => userMail = value,
    );
  }

  ElevatedButton _sendButton(BuildContext context) {
    return ElevatedButton(
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
    );
  }
}
