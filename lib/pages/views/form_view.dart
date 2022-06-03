import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/themes/padding.dart';

import '../../core/storage/dialog_storage.dart';
import '../../core/storage/firebase.dart';

=======
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:intl/intl.dart';
import '../../core/storage/dialog_storage.dart';
import '../../core/storage/firebase.dart';

>>>>>>> 62aa17d25f1cd8abfba66096e788d071a408f731
class JobFormView extends StatefulWidget {
  const JobFormView({Key? key}) : super(key: key);

  @override
  State<JobFormView> createState() => _JobFormViewState();
}

class _JobFormViewState extends State<JobFormView> {
  late String _category = "Temizlik";
  late String _shift = "1 Gün";
  late String _gender = "Erkek";
  late String _city = "Ankara";
  late int _index = 0;

  final _formKey = GlobalKey<FormState>();

<<<<<<< HEAD
=======
  DateTime now = DateTime.now();
  late final String _date = DateFormat('yyyy-MM-dd').format(now);

>>>>>>> 62aa17d25f1cd8abfba66096e788d071a408f731
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _fullAdressController;
  late TextEditingController _minSalaryController;
  late TextEditingController _maxSalaryController;
  late String _userName;

  @override
  initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _fullAdressController = TextEditingController();
    _minSalaryController = TextEditingController();
    _maxSalaryController = TextEditingController();
    getUser();
    super.initState();
  }

  Future<String> getUser() async {
    final User? user = auth.currentUser;
    await userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
      _userName = userType?['name'];
    });

    return _userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: Text('İş İlanı Oluştur ${_index + 1}/2'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ProjectPadding.pagePaddingHorizontal,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _index == 0 ? pageOne() : pageTwo(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column pageOne() {
    return Column(
      children: [
        DropdownButtonFormField(
          value: _category,
          decoration: const InputDecoration(
            labelText: "Kategori",
            labelStyle: TextStyle(
              fontSize: 22,
            ),
            // contentPadding: ,
          ),
          items: DropdownTexts.categories.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _category = value!;
            });
          },
        ),
        const SizedBox(
          height: 25,
        ),
        DropdownButtonFormField(
          value: _shift,
          decoration: const InputDecoration(
            labelText: "Çalışma Süresi",
            labelStyle: TextStyle(
              fontSize: 22,
            ),
            // contentPadding: ,
          ),
          items: DropdownTexts.shifts.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _shift = value!;
            });
          },
        ),
        const SizedBox(
          height: 25,
        ),
        DropdownButtonFormField(
          value: _gender,
          decoration: const InputDecoration(
            labelText: "Aranan Cinsiyet",
            labelStyle: TextStyle(
              fontSize: 22,
            ),
            // contentPadding: ,
          ),
          items: DropdownTexts.genders.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _gender = value!;
            });
          },
        ),
        const SizedBox(
          height: 25,
        ),
        DropdownButtonFormField(
          value: _city,
          decoration: const InputDecoration(
            labelText: "Şehir",
            labelStyle: TextStyle(
              fontSize: 22,
            ),
            // contentPadding: ,
          ),
          items: DropdownTexts.cities.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _city = value!;
            });
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _index = 1;
            });
          },
          child: const Text('Devam'),
        ),
      ],
    );
  }

  Column pageTwo() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          maxLength: 50,
          decoration: const InputDecoration(
            labelText: 'İlan Başlığı',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bu alan boş bırakılamaz';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 200,
          decoration: const InputDecoration(
            labelText: 'İlan Açıklaması',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bu alan boş bırakılamaz';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _fullAdressController,
          maxLines: 2,
          maxLength: 150,
          decoration: const InputDecoration(
            labelText: 'Açık Adres',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bu alan boş bırakılamaz';
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: TextFormField(
                maxLength: 5,
                keyboardType: TextInputType.number,
                controller: _minSalaryController,
                decoration: const InputDecoration(
                  labelText: 'Min Ücret',
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Boş bırakılamaz';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: TextFormField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                controller: _maxSalaryController,
                decoration: const InputDecoration(
                  labelText: 'Max Ücret',
                  counterText: "",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Boş bırakılamaz';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              },
              child: const Text('Geri Dön'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (int.parse(_maxSalaryController.text) >
                      int.parse(_minSalaryController.text)) {
<<<<<<< HEAD
                    FirebaseFirestore.instance
                        .collection("jobAdverts")
                        .doc()
                        .set({
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'userName': _userName,
                      'date': DateTime.now().toString(),
=======
                    FirebaseFirestore.instance.collection("jobAdverts").doc().set({
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'userName': _userName,
                      'date': _date,
>>>>>>> 62aa17d25f1cd8abfba66096e788d071a408f731
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'fullAdress': _fullAdressController.text,
                      'minSalary': _minSalaryController.text,
                      'maxSalary': _maxSalaryController.text,
                      'category': _category,
                      'shift': _shift,
                      'gender': _gender,
                      'city': _city
<<<<<<< HEAD
                    }).then((_) => showSuccessDialog(
                                context, "İlan başarıyla paylaşıldı")
                            .then((_) => router.go('/home')));
                  } else {
                    showErrorDialog(context,
                        "Minimum ücret Maksimum ücret'ten büyük olamaz!");
=======
                    }).then((_) => showSuccessDialog(context, "İlan başarıyla paylaşıldı")
                        .then((_) => Navigator.pop(context)));
                  } else {
                    showErrorDialog(
                        context, "Minimum ücret Maksimum ücret'ten büyük olamaz!");
>>>>>>> 62aa17d25f1cd8abfba66096e788d071a408f731
                  }
                }
              },
              child: const Text('Paylaş'),
            ),
          ],
        )
      ],
    );
  }
}
