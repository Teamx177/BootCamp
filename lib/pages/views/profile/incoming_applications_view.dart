// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/storage/dialog_storage.dart';
import 'package:hireme/core/storage/firebase.dart';
import 'package:hireme/core/themes/padding.dart';

class IncomingApplicationsView extends StatefulWidget {
  const IncomingApplicationsView({
    Key? key,
  }) : super(key: key);

  @override
  State<IncomingApplicationsView> createState() => _IncomingApplicationsViewState();
}

class _IncomingApplicationsViewState extends State<IncomingApplicationsView> {
  String? _employerName;
  String? _employerEmail;
  String? _employerPhone;

  @override
  initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    await userRef.doc(AuthService.firebase().currentUser?.uid).get().then((doc) {
      var data = doc.data();
      setState(() {
        _employerName = data?['name'];
        _employerEmail = data?['email'];
        _employerPhone = data?['phone'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Gelen Başvurularım'),
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
                                        "İsim: ${data['userName']}\nŞehir: ${data['userCity']}\nTelefon: ${data['userPhone'].toString().substring(3, 13)}\nEmail: ${data['userEmail']}")),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        style: ButtonStyle(
                                          minimumSize: MaterialStateProperty.all(
                                            const Size(120, 0),
                                          ),
                                          backgroundColor: MaterialStateProperty.all(Colors.green),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection("employeeNotifications").doc().set({
                                            "employerId": AuthService.firebase().currentUser?.uid,
                                            "employeeId": data['userId'],
                                            "jobAdvertId": data['jobAdvertId'],
                                            "jobTitle": data['title'],
                                            "jobCategory": data['category'],
                                            "jobCity": data['userCity'],
                                            "employerName": _employerName,
                                            "employerEmail": _employerEmail,
                                            "employerPhone": _employerPhone,
                                            "isApproved": true,
                                          }).then((_) {
                                            FirebaseFirestore.instance
                                                .collection('applications')
                                                .doc(snapshot.data?.docs[index].id)
                                                .delete();
                                          }).then((_) {
                                            FirebaseFirestore.instance
                                                .collection('jobAdverts')
                                                .doc(data['jobAdvertId'])
                                                .update(
                                              {
                                                'applications': FieldValue.arrayRemove([data['userId']])
                                              },
                                            );
                                          }).then((_) => showSuccessDialog(context, "Başvuru onylandı."));
                                        },
                                        child: const Text(
                                          "Onayla",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    TextButton(
                                        style: ButtonStyle(
                                          minimumSize: MaterialStateProperty.all(
                                            const Size(120, 0),
                                          ),
                                          backgroundColor: MaterialStateProperty.all(Colors.red),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection("employeeNotifications").doc().set({
                                            "employerId": AuthService.firebase().currentUser?.uid,
                                            "employeeId": data['userId'],
                                            "jobAdvertId": data['jobAdvertId'],
                                            "jobTitle": data['title'],
                                            "jobCategory": data['category'],
                                            "jobCity": data['userCity'],
                                            "employerName": _employerName,
                                            "employerEmail": _employerEmail,
                                            "employerPhone": _employerPhone,
                                            "isApproved": false,
                                          }).then((_) {
                                            FirebaseFirestore.instance
                                                .collection('applications')
                                                .doc(snapshot.data?.docs[index].id)
                                                .delete();
                                          }).then((_) {
                                            FirebaseFirestore.instance
                                                .collection('jobAdverts')
                                                .doc(data['jobAdvertId'])
                                                .update(
                                              {
                                                'applications': FieldValue.arrayRemove([data['userId']])
                                              },
                                            );
                                          }).then((_) => showSuccessDialog(context, "Başvuru reddedildi."));
                                        },
                                        child: const Text(
                                          "Reddet",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
