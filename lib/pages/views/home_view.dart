import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/models/user.dart';
import 'package:hrms/core/themes/padding.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, currentUserType}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String currentUserType;
  late String currentUserName;
  late bool isFavorite;

  @override
  void initState() {
    currentUserType = '';
    currentUserName = '';
    isFavorite = false;
    super.initState();
  }

  Stream<UserModel> getUser(String? uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDocuments(snapshot));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: ProjectPadding.pagePaddingAll,
        child: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              return (!snapshot.hasData)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: 'Hoşgeldin ',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            TextSpan(
                              text: '\n${snapshot.data?.get('name')}'
                                  .split(' ')[0],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ])),
                          const SizedBox(
                            height: 10,
                          ),
                          for (var i = 0; i < 5; i++)
                            Card(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.topic),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isFavorite = !isFavorite;
                                        });
                                      },
                                      icon: isFavorite
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    title: const Text('İlan Başlığı'),
                                    subtitle: const Text(
                                      'Maaş ve Tarih',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'İlan Detayı',
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        child: const Text(
                                          'Başvuru Yap',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const Text("Ad soyad"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
            },
          ),
        ),
        //     }
        // default:
        // if (snapshot.hasError) {
        // return Text('Error: ${snapshot.error}');
        // } else {
        // return Text('Result: ${snapshot.data}');
        // }
        // }
      ),
    );
  }
}
