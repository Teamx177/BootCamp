import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/dialogs.dart';
import 'package:hrms/static_storage/texts.dart';
import 'package:hrms/views/log_in_view.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final userRef = _firestore.collection('users');
final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentUserType = "";

  @override
  void initState() {
    getUserById();
    super.initState();
  }

  Future<String> getUserById() async {
    final User? user = _auth.currentUser;
    await userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
      currentUserType = userType!['type'].toString();
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
      body: FutureBuilder<String>(
        future: getUserById(), // async work
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return Column(
                children: [
                  currentUserType == "employer"
                      ? Text("Hoşgeldin: " + currentUserType)
                      : Text("Hg: " + currentUserType),
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
