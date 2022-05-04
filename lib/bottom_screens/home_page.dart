import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/texts.dart';
import 'package:hrms/views/log_in_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              try {
                AuthService.firebase().logOut();
              } on UserNotFoundAuthException {
                showErrorDialog(
                  context,
                  ErrorTexts.errorOnExit,
                );
              }
              final user = AuthService.firebase().currentUser;
              if (user == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              } else {
                showErrorDialog(
                  context,
                  ErrorTexts.errorOnExit,
                );
              }
            },
          ),
        ],
      ),
      body: Text(WelcomeTexts.welcome),
    );
  }
}
