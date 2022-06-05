import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/themes/padding.dart';

import '../../core/storage/dialog_storage.dart';
import '../../core/storage/firebase.dart';

class DetailsView extends StatefulWidget {
  final String? docID;

  const DetailsView({Key? key, this.docID}) : super(key: key);

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late int _selectedIndex;
  String? _userType;
  String? _userGender;
  String? _userEmail;
  String? _userPhone;
  String? _userName;
  String? _userCity;

  @override
  void initState() {
    _selectedIndex = 0;
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    final User? user = auth.currentUser;
    await userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
     setState((){
        _userType = userType?['type'];
        _userGender = userType?['gender'];
        _userEmail = userType?['email'];
        _userPhone = userType?['phone'];
        _userName = userType?['name'];
        _userCity = userType?['city'];
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobAdverts')
            .doc(widget.docID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: ProjectPadding.pagePaddingHorizontal,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data?.get('userName')),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data?.get('title')),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(snapshot.data?.get('category')),
                            Text(snapshot.data?.get('city')),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    autofocus: true,
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            _selectedIndex == 0 ? Colors.green : null),
                                    onPressed: () async {
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                    },
                                    child: const Text('Açıklaması'))),
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            _selectedIndex == 1 ? Colors.green : null),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 1;
                                      });
                                    },
                                    child: const Text('Özellikler'))),
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            _selectedIndex == 2 ? Colors.green : null),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 2;
                                      });
                                    },
                                    child: const Text('Iletişim'))),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.33,
                          child: Align(
                            alignment: Alignment.center,
                            child: (_selectedIndex == 0)
                                ? Text(snapshot.data?.get('description'))
                                : (_selectedIndex == 1)
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "Ücret",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "${snapshot.data?.get('minSalary')} TL - ${snapshot.data?.get('maxSalary')} TL"),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                "Aranan Cinsiyet",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text("${snapshot.data?.get('gender')}"),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Açık Adres",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("${snapshot.data?.get('fullAddress')}"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Telefon Numarası",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "${snapshot.data?.get('phone').toString().substring(3, 13)}"),
                                        ],
                                      ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        _userType == "employee" &&
                                !snapshot.data!.get('applications').toString().contains(
                                    (FirebaseAuth.instance.currentUser!.uid).toString())
                            ? ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("jobAdverts")
                                      .doc(widget.docID)
                                      .update({
                                        'applications': FieldValue.arrayUnion(
                                            [FirebaseAuth.instance.currentUser?.uid])
                                      }).then((_){
                                        FirebaseFirestore.instance.collection("applications").doc().set(
                                          {
                                            'userName': _userName,
                                            'userID': FirebaseAuth.instance.currentUser?.uid,
                                            'userGender' : _userGender,
                                            'userPhone' : _userPhone,
                                            'userEmail': _userEmail,
                                            'userCity' : _userCity,
                                            'title' : snapshot.data?.get('title'),
                                            'category' : snapshot.data?.get('category'),
                                            'employerId': snapshot.data?.get('userId'),
                                            'jobAdvertID': widget.docID,
                                          }
                                        );
                                  })
                                      .then((_) => showSuccessDialog(
                                          context, "Başvurunuz alındı."))
                                      .then(
                                        (value) {
                                          Navigator.pop(context);
                                        },
                                      );
                                },
                                child: const Text('Başvur'),
                              )
                            : _userType == "employer" ? Text("") : const ElevatedButton(
                                onPressed: null,
                                child: Text('Başvuru Yapıldı'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
