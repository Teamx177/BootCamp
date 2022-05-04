import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
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
            onPressed: () async {
              try {
                await AuthService.firebase().logOut();
              } on UserNotFoundAuthException {
                return showErrorDialog(
                  context,
                  'Çıkış yapılırken bir sorun oluştu.',
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
                await showErrorDialog(
                  context,
                  'Çıkış yapılırken bir sorun oluştu.',
                );
              }
            },
          ),
        ],
      ),
      body: const Text('Welcome'),
    );
  }
}
