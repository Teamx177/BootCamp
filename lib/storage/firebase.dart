import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final userRef = firestore.collection('users');
