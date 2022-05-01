import 'package:flutter/material.dart';
import 'package:hrms/screens/log_in.dart';
import 'package:hrms/services/auth/auth_service.dart';

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
              } catch (e) {}
              setState(() {});
              final user = AuthService.firebase().currentUser;
              if (user == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
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
