// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/themes/padding.dart';

import '../../core/services/auth/auth_service.dart';

class EmployeeNotifyView extends StatefulWidget {
  const EmployeeNotifyView({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeNotifyView> createState() => _EmployeeNotifyViewState();
}

class _EmployeeNotifyViewState extends State<EmployeeNotifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text('Bildirimler'),
      ),
      body: Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('employeeNotifications')
                .where('employeeId', isEqualTo: AuthService.firebase().currentUser?.uid)
                .snapshots()
                .map((snapshot) => snapshot),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no_result.png'),
                          const Text('Herhangi bir bildirim bulunamadı.'),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                ListTile(
                                  leading: data['isApproved']
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                  title: Text(
                                    "${data['jobTitle']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle:
                                      Text("${data['jobCity']} / ${data['jobCategory']}"),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("İsim: ${data['employerName']}\n"
                                        "Telefon: ${data['employerPhone'].toString().substring(3, 13)}\n"
                                        "E-posta: ${data['employerEmail']}\n\n"
                                        "${data['isApproved'] ? 'Başvurunuz Onaylandı.' : 'Başvurunuz Reddedildi.'}")),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('employeeNotifications')
                                        .doc(snapshot.data?.docs[index].id)
                                        .delete();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.deepOrangeAccent),
                                  ),
                                  child: const Text(
                                    'Bildirimi Sil',
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
