// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/core/themes/text_theme.dart';

class IncomingApplicationsView extends StatefulWidget {
  const IncomingApplicationsView({
    Key? key,
  }) : super(key: key);

  @override
  State<IncomingApplicationsView> createState() => _IncomingApplicationsViewState();
}

class _IncomingApplicationsViewState extends State<IncomingApplicationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Gelen Başvurularım', style: textThemes.headline5),
      ),
      body: Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('applications')
                .where("employerId", isEqualTo: AuthService.firebase().currentUser?.uid)
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
                                  subtitle: Text("Kategori: ${data['category']}"),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        "İsim: ${data['userName']}\nTelefon: ${data['userPhone']}\nŞehir: ${data['userCity']}")),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(onPressed: () {}, child: const Text("Onayla")),
                                    TextButton(onPressed: () {}, child: const Text("Reddet")),
                                  ],
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
