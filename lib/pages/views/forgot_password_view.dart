import 'package:flutter/material.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/widgets/forgot_password_view_widgets.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({Key? key}) : super(key: key);

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: BackgroundImage(
        child: const Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: SingleChildScrollView(
            child: ForgotPasswordForm(),
          ),
        ),
      ),
    );
  }
}
