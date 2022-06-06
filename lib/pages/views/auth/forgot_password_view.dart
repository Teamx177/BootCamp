import 'package:flutter/material.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/pages/views/auth/widgets/forgot_password_view_widgets.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({Key? key}) : super(key: key);

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ForgotPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
