import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/storage/validation_storage.dart';
import 'package:hrms/core/themes/padding.dart';

import '../../core/storage/dialog_storage.dart';
import '../../core/storage/firebase.dart';

class EditFormView extends StatefulWidget {
  final String? docID;

  const EditFormView({Key? key, this.docID}) : super(key: key);

  @override
  State<EditFormView> createState() => _EditFormViewState();
}

class _EditFormViewState extends State<EditFormView> {
  late String _category = "Temizlik";
  late String _shift = "1 Gün";
  late String _gender = "Erkek";
  late String _city = "ANKARA";
  late int _index = 0;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _fullAddressController;
  late TextEditingController _minSalaryController;
  late TextEditingController _maxSalaryController;

  @override
  initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _fullAddressController = TextEditingController();
    _minSalaryController = TextEditingController();
    _maxSalaryController = TextEditingController();
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    await FirebaseFirestore.instance.collection("jobAdverts").doc(widget.docID).get().then((doc) {
      var snapshot = doc.data();
      _titleController.text = snapshot!['title'];
      _descriptionController.text = snapshot['description'];
      _fullAddressController.text = snapshot['fullAddress'];
      _minSalaryController.text = snapshot['minSalary'].toString();
      _maxSalaryController.text = snapshot['maxSalary'].toString();
      setState((){
        _category = snapshot['category'];
      _shift = snapshot['shift'];
      _city = snapshot['city'];
      _gender = snapshot['gender'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // backgroundColor: Colors.black,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 25),
            Text('İlanı Düzenle ${_index + 1}/2')
          ],
        ),
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
        const SizedBox(
          height: 25,
        ),
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
        const SizedBox(
          height: 25,
        ),
        TextFormField(
          controller: _titleController,
          maxLength: 50,
          decoration: const InputDecoration(
            labelText: 'İlan Başlığı',
          ),
          validator: ValidationConstants.titleValidator,
        ),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 200,
          decoration: const InputDecoration(
            labelText: 'İlan Açıklaması',
          ),
          validator: ValidationConstants.descriptionValidator,
        ),
        TextFormField(
          controller: _fullAddressController,
          maxLines: 2,
          maxLength: 150,
          decoration: const InputDecoration(
            labelText: 'Açık Adres',
          ),
          validator: ValidationConstants.addressValidator,
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
                validator: ValidationConstants.salaryValidator,
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
                validator: ValidationConstants.salaryValidator,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              },
              child: const Text('Geri Dön'),
            ),
            OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (int.parse(_maxSalaryController.text) >
                      int.parse(_minSalaryController.text)) {
                    FirebaseFirestore.instance.collection("jobAdverts").doc(widget.docID).update({
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'fullAddress': _fullAddressController.text,
                      'minSalary': _minSalaryController.text,
                      'maxSalary': _maxSalaryController.text,
                      'category': _category,
                      'shift': _shift,
                      'gender': _gender,
                      'city': _city,
                    }).then((_) => showSuccessDialog(context, "İlan başarıyla güncellendi")
                        .then((_) => Navigator.pop(context)));
                  } else {
                    showErrorDialog(
                        context, "Minimum ücret Maksimum ücret'ten büyük olamaz!");
                  }
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        )
      ],
    );
  }
}
