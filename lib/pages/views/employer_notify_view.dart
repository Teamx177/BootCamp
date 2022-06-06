// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/themes/padding.dart';

import '../../core/services/auth/auth_service.dart';
import '../../core/storage/dialog_storage.dart';

class EmployerNotifyView extends StatefulWidget {
  const EmployerNotifyView({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployerNotifyView> createState() => _EmployerNotifyViewState();
}

class _EmployerNotifyViewState extends State<EmployerNotifyView> {
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
                  .collection('employerNotifications')
                  .where('employerId', isEqualTo: AuthService.firebase().currentUser?.uid)
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
                                  const ListTile(
                                    title: Icon(
                                      Icons.notification_important_rounded,
                                      size: 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "${data['employeeName']} adlı kullanıcı, ${data['jobCategory']} kategorisinde yer alan ${data['jobTitle']} başlıklı ilanınıza başvuru yaptı.",
                                    ),
                                  ),
                                  Align(
                                    alignment: const Alignment(0.85, 0),
                                    child: TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('employerNotifications')
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
                        ),
                      );
              },
            )),
      ),
    );
  }
}
