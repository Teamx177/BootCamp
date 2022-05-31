import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? city;
  final String? selectedGender;

  UserModel(
      {this.id,
      this.email,
      this.name,
      this.phoneNumber,
      this.city,
      this.selectedGender});

  factory UserModel.fromDocuments(DocumentSnapshot doc) {
    return UserModel(
      id: doc.data().toString().contains('id') ? doc.get('id') : '',
      email: doc.data().toString().contains('email') ? doc.get('email') : '',
      name: doc.data().toString().contains('name') ? doc.get('name') : '',
      phoneNumber: doc.data().toString().contains('phoneNumber')
          ? doc.get('phoneNumber')
          : '',
      city: doc.data().toString().contains('city') ? doc.get('city') : '',
      selectedGender: doc.data().toString().contains('selectedGender')
          ? doc.get('selectedGender')
          : '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'city': city,
        'selectedGender': selectedGender,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        city: json["city"],
        selectedGender: json["selectedGender"],
      );
}
