import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/firebase.dart';
import 'package:hrms/static_storage/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, currentUserType}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> userType;
  String currentUserType = "";

  @override
  void initState() {
    userType = getUserById();
    super.initState();
  }

  Future<String> getUserById() async {
    await Future.delayed(const Duration(seconds: 1));
    await userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
      currentUserType = userType?['type'];
    });
    return currentUserType;
  }

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
                await FirebaseAuth.instance.signOut();
              } on UserNotFoundAuthException {
                showErrorDialog(
                  context,
                  ErrorTexts.errorOnExit,
                );
              }
              final user = AuthService.firebase().currentUser;
              if (user == null) {
                Navigator.pushNamed(context, '/login');
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
      body: FutureBuilder<String>(
        future: userType, // async work
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return Column(
                children: [
                  currentUserType == "employer"
                      ? Text("Hoşgeldin: " + currentUserType)
                      : Text(
                          "Hg: " + currentUserType,
                        )
                ],
              );
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Result: ${snapshot.data}');
              }
          }
        },
      ),
    );
  }
}
