import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms/storage/firebase.dart';
import 'package:hrms/themes/padding.dart';

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
    final User? user = auth.currentUser;
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
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingAll,
        child: FutureBuilder<String>(
          future: userType, // async work
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return Column(
                  children: [
                    currentUserType == "employer"
                        ? Text(
                            "Hoşgeldin: " + currentUserType,
                            style: TextStyle(
                              fontFamily: GoogleFonts.mavenPro().fontFamily,
                            ),
                          )
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
      ),
    );
  }
}
