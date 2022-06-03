// import 'package:cloud_firestore/cloud_firestore.dart';

// class JobModel {
//   String? category;
//   String? city;
//   String? date;
//   String? description;
//   String? fullAdress;
//   String? requirementGender;
//   int? minSalary;
//   int? maxSalary;
//   String? shift;
//   String? title;
//   String? userId;
//   String? userName;

//   JobModel(
//       {this.category,
//       this.city,
//       this.date,
//       this.description,
//       this.fullAdress,
//       this.requirementGender,
//       this.minSalary,
//       this.maxSalary,
//       this.shift,
//       this.title,
//       this.userId,
//       this.userName});

//   factory JobModel.fromDocuments(DocumentSnapshot doc) {
//     return JobModel(
//       category:
//           doc.data().toString().contains('category') ? doc.get('category') : '',
//       city: doc.data().toString().contains('city') ? doc.get('city') : '',
//       date: doc.data().toString().contains('date') ? doc.get('date') : '',
//       description: doc.data().toString().contains('description')
//           ? doc.get('description')
//           : '',
//       fullAdress: doc.data().toString().contains('fullAdress')
//           ? doc.get('fullAdress')
//           : '',
//       requirementGender: doc.data().toString().contains('requirementGender')
//           ? doc.get('requirementGender')
//           : '',
//       minSalary: doc.data().toString().contains('minSalary')
//           ? doc.get('minSalary')
//           : '',
//       maxSalary: doc.data().toString().contains('maxSalary')
//           ? doc.get('maxSalary')
//           : '',
//       shift: doc.data().toString().contains('shift') ? doc.get('shift') : '',
//       title: doc.data().toString().contains('title') ? doc.get('title') : '',
//       userId: doc.data().toString().contains('userId') ? doc.get('userId') : '',
//       userName:
//           doc.data().toString().contains('userName') ? doc.get('userName') : '',
//     );
//   }
//   Map<String, dynamic> toJson() => {
//         'category': category,
//         'city': city,
//         'date': date,
//         'description': description,
//         'fullAdress': fullAdress,
//         'requirementGender': requirementGender,
//         'minSalary': minSalary,
//         'maxSalary': maxSalary,
//         'shift': shift,
//         'title': title,
//         'userId': userId,
//         'userName': userName,
//       };

//   static JobModel fromJson(Map<String, dynamic> json) => JobModel(
//         category: json["category"],
//         city: json["city"],
//         date: json["date"],
//         description: json["description"],
//         fullAdress: json["fullAdress"],
//         requirementGender: json["requirementGender"],
//         minSalary: json["minSalary"],
//         maxSalary: json["maxSalary"],
//         shift: json["shift"],
//         title: json["title"],
//         userId: json["userId"],
//         userName: json["userName"],
//       );
// }
