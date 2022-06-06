// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/themes/padding.dart';

import '../details_view.dart';

class AppliedsView extends StatefulWidget {
  const AppliedsView({
    Key? key,
  }) : super(key: key);

  @override
  State<AppliedsView> createState() => _AppliedsViewState();
}

class _AppliedsViewState extends State<AppliedsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Başvurularım'),
      ),
      body: Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('jobAdverts')
                .where("applications",
                    arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .snapshots()
                .map((snapshot) => snapshot),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no_result.png'),
                          const Text('Herhangi bir başvuru bulunamadı.'),
                        ],
                      ),
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
                          var data =
                              snapshot.data?.docs[index].data() as Map<String, dynamic>;
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
                                        "${data['description'].toString().substring(0, data['description'].toString().substring(0, 60).lastIndexOf(" "))}...")),
                                TextButton(
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
                                        MaterialStateProperty.all(Colors.red),
                                  ),
                                  child: const Text(
                                    'Detay Sayfası',
                                    style: TextStyle(color: Colors.white),
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
          )),
    );
  }
}
