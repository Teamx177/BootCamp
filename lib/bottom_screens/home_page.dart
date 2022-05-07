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

  //provider ile giriş yap butonuna basıldığında çalışıp buraya değeri gönderecek.
  //tek tek sayfadan sayfaya göndermek istemediğim için providera geçene kadar böyle bıraktım.
  getUserById() async {
    final User? user = _auth.currentUser;
    userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
      setState(() {
        currentUserType = userType!['type'].toString();
      });
    });
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
      body: currentUserType == "employee"
          ? Column(
              children: const [
                Image(image: NetworkImage("https://cdn-icons-png.flaticon.com/128/1308/1308491.png")),
                Text("Hoşgeldin Employee"),
              ],
            )
          : Column(
              children: const [
                Image(image: NetworkImage("https://cdn-icons-png.flaticon.com/128/1869/1869679.png")),
                Text("Hoşgeldin Employer"),
              ],
            ),
    );
  }
}
