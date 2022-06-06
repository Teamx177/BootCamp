// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/themes/padding.dart';

import '../../core/services/auth/auth_service.dart';
import '../../core/storage/dialog_storage.dart';

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
      body: SingleChildScrollView(
        child: Padding(
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
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/no_result.png'),
                              const Text('Herhangi bir bildirim bulunamadı.'),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = snapshot.data?.docs[index].data() as Map<String, dynamic>;
                          return Card(
                            color: Colors.blueGrey.shade200,
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
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF139A2F),
                                          size: 40,
                                        )
                                      : const Icon(
                                          Icons.cancel_rounded,
                                          color: Color(0xFFDF2935),
                                          size: 40,
                                        ),
                                  title: Text(
                                    "${data['jobTitle']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                    ),
                                  ),
                                  subtitle: Text("${data['jobCity']} / ${data['jobCategory']}",style: TextStyle(
                                      color: Colors.black
                                    ),),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("İsim: ${data['employerName']}\n"
                                        "Telefon: ${data['employerPhone'].toString().substring(3, 13)}\n"
                                        "E-posta: ${data['employerEmail']}\n\n"
                                        "${data['isApproved'] ? 'Başvurunuz Onaylandı.' : 'Başvurunuz Reddedildi.'}",style: TextStyle(
                                      color: Colors.black
                                    ),)),
                                Align(
                                  alignment: const Alignment(0.85, 0),
                                  child: TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('employeeNotifications')
                                          .doc(snapshot.data?.docs[index].id)
                                          .delete()
                                          .then((_) => showOkToast(text: 'Bildirim kaldırıldı.'));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade300),
                                    ),
                                    child: const Text(
                                      'Bildirimi Kaldır',
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
                      );
              },
            )),
      ),
    );
  }
}
