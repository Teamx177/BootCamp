import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/models/user.dart';
import 'package:hrms/core/services/auth/auth_service.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/views/details_view.dart';
import 'package:hrms/pages/views/form_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, currentUserType}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _orderBy = 'date';
  late final _userData;
  late String userName = '';
  late bool _isEmployee;

  Stream<UserModel> getUser(String? uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDocuments(snapshot));
  }

  @override
  void initState() {
    _userData = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    userName = '';
    _isEmployee = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _userData,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              userName = '\n ${snapshot.data?.get('name')}';
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
                          Row(
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: 'Hoşgeldin ',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                TextSpan(
                                  text: userName,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ])),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return const JobFormView();
                                        },
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_isEmployee =
                              snapshot.data?.get('type') == 'employee')
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('jobAdverts')
                                  .orderBy(_orderBy, descending: true)
                                  .snapshots()
                                  .map((snapshot) => snapshot),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return (!snapshot.hasData)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                        },
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var data = snapshot
                                                .data?.docs[index]
                                                .data() as Map<String, dynamic>;
                                            return Card(
                                              clipBehavior: Clip.antiAlias,
                                              margin:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading:
                                                        const Icon(Icons.topic),
                                                    trailing: Text(data['date']
                                                        .toString()
                                                        .substring(0, 10)),
                                                    title: Text(data['title']),
                                                    subtitle: Text(
                                                      "Maaş : ${data['minSalary']} TL - "
                                                      "${data['maxSalary']} TL",
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Text(
                                                      data['description'],
                                                    ),
                                                  ),
                                                  ButtonBar(
                                                    alignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "Kategori:"),
                                                          Text(
                                                            data['category'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        ],
                                                      ),
                                                      Text(data['userName']),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'jobAdverts')
                                                          .doc(data['id']);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              DetailsView(
                                                            docID: snapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    child: const Text(
                                                      'Başvuru Yap',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                              },
                            )
                          else
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('jobAdverts')
                                  .where('userId',
                                      isEqualTo: AuthService.firebase()
                                          .currentUser
                                          ?.uid)
                                  .snapshots()
                                  .map((snapshot) => snapshot),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                return (!snapshot.hasData)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var data = snapshot.data?.docs[index]
                                              .data() as Map<String, dynamic>;
                                          return Card(
                                            clipBehavior: Clip.antiAlias,
                                            margin: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.topic),
                                                  trailing: Text(data['date']
                                                      .toString()
                                                      .substring(0, 10)),
                                                  title: Text(data['title']),
                                                  subtitle: Text(
                                                    "Maaş : ${data['minSalary']} TL - "
                                                    "${data['maxSalary']} TL",
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text(
                                                    data['description'],
                                                  ),
                                                ),
                                                ButtonBar(
                                                  alignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text("Kategori:"),
                                                        Text(
                                                          data['category'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      ],
                                                    ),
                                                    Text(data['userName']),
                                                  ],
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'jobAdverts')
                                                        .doc(data['id']);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            DetailsView(
                                                          docID: snapshot.data
                                                              ?.docs[index].id,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                  ),
                                                  child: const Text(
                                                    'Ilanı Düzenle',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          );
                                        });
                              },
                            )
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
