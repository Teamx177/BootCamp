import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/models/user.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/core/themes/text_theme.dart';
import 'package:hireme/pages/views/details_view.dart';
import 'package:hireme/pages/views/edit_form_view.dart';
import 'package:hireme/pages/views/form_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, currentUserType}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    _userData = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots();
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
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              userName = '\n ${snapshot.data?.get('name')}';
              _isEmployee = snapshot.data?.get('type') == 'employee';
              return (!snapshot.hasData)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no_result.png'),
                          const Text('Herhangi bir başvuru bulunamadı.'),
                        ],
                      ),
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
                              snapshot.data?.get('type') == 'employee'
                                  ? const SizedBox.shrink()
                                  : IconButton(
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
                                      icon: const Icon(Icons.add))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _isEmployee
                              ? Text('Güncel İlanlar', style: textThemes.headline6)
                              : Text(
                                  'Yayınladığım ilanlar',
                                  style: textThemes.headline6,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_isEmployee = snapshot.data?.get('type') == 'employee')
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('jobAdverts')
                                  .orderBy('date', descending: true)
                                  .snapshots()
                                  .map((snapshot) => snapshot),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                return (!snapshot.hasData)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          await Future.delayed(const Duration(seconds: 1));
                                        },
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            var data = snapshot.data?.docs[index].data() as Map<String, dynamic>;
                                            return Card(
                                              clipBehavior: Clip.antiAlias,
                                              margin: const EdgeInsets.only(bottom: 16.0, top: 12.0),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(Icons.topic),
                                                    title: Text(
                                                      data['title'],
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                        "Kategori: ${data['category']}\n${data['date'].toString().substring(0, 10)}"),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Text(
                                                        "${data['description'].toString().substring(0, data['description'].toString().substring(0, 60).lastIndexOf(" "))}..."),
                                                  ),
                                                  data['applications']
                                                          .toString()
                                                          .contains((FirebaseAuth.instance.currentUser?.uid).toString())
                                                      ? Align(
                                                          alignment: const Alignment(0.9, 0.0),
                                                          child: TextButton(
                                                            onPressed: null,
                                                            style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all(Colors.grey),
                                                            ),
                                                            child: const Text(
                                                              'Başvuru Yapıldı',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                        )
                                                      : Align(
                                                          alignment: const Alignment(0.9, 0.0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              FirebaseFirestore.instance
                                                                  .collection('jobAdverts')
                                                                  .doc(data['id']);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) => DetailsView(
                                                                    docID: snapshot.data?.docs[index].id,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all(Colors.deepPurple[300]),
                                                            ),
                                                            child: const Text(
                                                              'Detay Sayfası',
                                                              style: TextStyle(color: Colors.white),
                                                            ),
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
                                  .where('userId', isEqualTo: AuthService.firebase().currentUser?.uid)
                                  .orderBy('date', descending: true)
                                  .snapshots()
                                  .map((snapshot) => snapshot),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                return (!snapshot.hasData)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          var data = snapshot.data?.docs[index].data() as Map<String, dynamic>;
                                          return Card(
                                            clipBehavior: Clip.antiAlias,
                                            margin: const EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 12.0,
                                            ),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: const Icon(Icons.topic),
                                                  title: Text(
                                                    data['title'],
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                      "Kategori: ${data['category']}\n${data['date'].toString().substring(0, 10)}"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Text(
                                                      "${data['description'].toString().substring(0, data['description'].toString().substring(0, 60).lastIndexOf(" "))}..."),
                                                ),
                                                Align(
                                                  alignment: const Alignment(0.9, 0.0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('jobAdverts')
                                                          .doc(data['id']);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => EditFormView(
                                                            docID: snapshot.data?.docs[index].id,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(Colors.deepPurple[300]),
                                                    ),
                                                    child: const Text(
                                                      'Ilanı Düzenle',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
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
