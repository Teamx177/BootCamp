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
  late List jobAdverts = [];

  @override
  void initState() {
    getJobAdverts();
    super.initState();
  }

  Stream<UserModel> getUser(String? uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDocuments(snapshot));
  }

  final CollectionReference _jobAdvertReference =
      FirebaseFirestore.instance.collection('jobAdverts');

  getJobAdverts() {
    _jobAdvertReference.get().then((value) {
      for (var data in value.docs) {
        if (mounted){
         setState(() {
          jobAdverts.add(data);
        });
        }
      }
    });
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
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                              text: '\n${snapshot.data?.get('name')}'.split(' ')[0],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ])),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: jobAdverts.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.topic),
                                        trailing: Text(jobAdverts[index].data()['date']),
                                        title: Text(jobAdverts[index]['title']),
                                        subtitle: Text(
                                          "Maaş : ${jobAdverts[index]['minSalary']} TL - "
                                          "${jobAdverts[index]['maxSalary']} TL",
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          jobAdverts[index]['description'],
                                        ),
                                      ),
                                      ButtonBar(
                                        alignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text("Kategori:"),
                                              Text(
                                                jobAdverts[index]['category'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          Text(jobAdverts[index]['userName']),
                                        ],
                                      ),
                                       TextButton(
                                            onPressed: () {
                                              print(jobAdverts[index].id);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(Colors.red),
                                            ),
                                            child: const Text(
                                              'Başvuru Yap',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                );
                              }),
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
