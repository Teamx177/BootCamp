import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms/core/models/user.dart';
import 'package:hrms/core/themes/lib_color_schemes.g.dart';
import 'package:hrms/core/themes/light_theme.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/widgets/form_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    Key? key,
  }) : super(key: key);
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _editProfileKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final List<String> _cities = ['Ankara', 'İstanbul', 'İzmir'];
  late String _city = 'Ankara';
  late bool buttonIsEnabled;
  late String name;

  Stream<UserModel> getUser(String? uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDocuments(snapshot));
  }

  @override
  void initState() {
    getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    buttonIsEnabled = false;
    super.initState();
  }

  void editButton() {
    setState(() {
      buttonIsEnabled = !buttonIsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/main'),
        ),
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Form(
          key: _editProfileKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Profil Bilgileri',
                  style: LightTheme().theme.textTheme.headline5,
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      return !snapshot.hasData
                          ? const Center(child: CircularProgressIndicator())
                          : Card(
                              borderOnForeground: true,
                              color: LightTheme().theme.cardColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: ProjectPadding.inputBoxHeight),
                                    NameFormField(
                                      initialValue: snapshot.data?.get('name'),
                                      enabled: buttonIsEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          nameController.text = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        height: ProjectPadding.inputBoxHeight),
                                    EmailFormField(
                                      enabled: buttonIsEnabled,
                                      initialValue: snapshot.data?.get('email'),
                                      onChanged: (value) {
                                        setState(() {
                                          emailController.text = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        height: ProjectPadding.inputBoxHeight),
                                    PhoneFormField(
                                      enabled: buttonIsEnabled,
                                      initialValue: snapshot.data?.get('phone'),
                                      onChanged: (value) {
                                        setState(() {
                                          phoneController.text = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        height: ProjectPadding.inputBoxHeight),
                                    DropdownButtonFormField(
                                      value: _city,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.location_on),
                                        prefixText: "Şehir: ",
                                        // contentPadding: ,
                                        constraints:
                                            BoxConstraints(maxWidth: 300),
                                      ),
                                      items: _cities.map((String items) {
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
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                            height:
                                                ProjectPadding.inputBoxHeight),
                                        FloatingActionButton.small(
                                          backgroundColor:
                                              lightColorScheme.secondary,
                                          child: Icon(
                                            !buttonIsEnabled
                                                ? Icons.edit
                                                : Icons.cancel,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              buttonIsEnabled =
                                                  !buttonIsEnabled;
                                            });
                                          },
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                            height:
                                                ProjectPadding.inputBoxHeight),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final baseUser = FirebaseAuth
                                                .instance.currentUser;
                                            // await user?.verifyBeforeUpdateEmail(emailController.text);// this sends after
                                            //change email an mail for verify again
                                            var credential =
                                                EmailAuthProvider.credential(
                                                    email:
                                                        baseUser?.email ?? '',
                                                    password:
                                                        'Test123.'); // Look for take user password with an dialog card
                                            await FirebaseAuth
                                                .instance.currentUser
                                                ?.reauthenticateWithCredential(
                                                    credential);
                                            await FirebaseAuth
                                                .instance.currentUser
                                                ?.updateDisplayName(
                                                    nameController.value.text);
                                            await FirebaseAuth
                                                .instance.currentUser
                                                ?.updateEmail(
                                                    emailController.value.text);
                                            // await user?.updatePhoneNumber(); // I don't know how to do this
                                            var a = await FirebaseFirestore
                                                .instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser?.uid)
                                                .get();
                                            if (a.exists) {
                                              final DocumentReference
                                                  documentReference =
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid);

                                              return await documentReference
                                                  .update({
                                                'name': nameController.text,
                                                'email': emailController.text,
                                                'phone': phoneController.text,
                                                'city': _city,
                                              });
                                            } else {
                                              final DocumentReference
                                                  documentReference =
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid);
                                              return await documentReference
                                                  .set({
                                                'name': nameController.text,
                                                'email': emailController.text,
                                                'phone': phoneController.text,
                                                'city': _city,
                                              });
                                            }
                                          },
                                          child: const Text('Kaydet'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
