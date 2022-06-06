import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/managers/route_manager.dart';
import 'package:hireme/core/storage/dialog_storage.dart';
import 'package:hireme/core/storage/text_storage.dart';
import 'package:hireme/core/storage/validation_storage.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/pages/views/auth/widgets/form_field.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isDark = false;
  bool isNotification = false;

  @override
  Widget build(BuildContext context) {
    bool value;
    var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                darkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                setState(() {
                  value = !darkMode;
                  Hive.box('themeData').put('darkmode', value);
                });
              }),
        ],
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Center(
          child: Column(
            children: [
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_active),
                      label: Text(UpdateTexts.closeNotification),
                    ),
                    const Spacer(),
                    Switch(
                        value: isNotification,
                        onChanged: (value) {
                          setState(() {
                            isNotification = !isNotification;
                          });
                        })
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(UpdateTexts.deleteAccount),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  EmailFormField(
                                    controller: null,
                                    hintText: HintTexts.emailHint,
                                    onChanged: (value) {
                                      setState(() {
                                        _emailController.text = value;
                                      });
                                    },
                                  ),
                                  PasswordFormField(
                                    validator: ValidationConstants.loginPasswordValidator,
                                    hintText: HintTexts.passwordHint,
                                    onChanged: (value) {
                                      setState(() {
                                        _passwordController.text = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(AuthStatusTexts.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          var credential = EmailAuthProvider.credential(
                                              email: _emailController.text, password: _passwordController.text);
                                          await FirebaseAuth.instance.currentUser
                                              ?.reauthenticateWithCredential(credential)
                                              .then((_) async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(UpdateTexts.confirmDeleteAccount),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text(UpdateTexts.no)),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                                                .delete();
                                                            await FirebaseAuth.instance.currentUser?.delete();
                                                            if (FirebaseAuth.instance.currentUser == null) {
                                                              router.go('/');
                                                            } else {
                                                              showErrorDialog(
                                                                  context, 'Hesap silinirken bir hata olustu');
                                                            }
                                                          },
                                                          child: Text(UpdateTexts.yes)),
                                                    ],
                                                  );
                                                });
                                          });
                                        } catch (e) {
                                          showErrorDialog(context, e.toString());
                                        }
                                      }
                                    },
                                    child: Text(AuthStatusTexts.confirm),
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                  },
                  label: Text(UpdateTexts.delete, style: const TextStyle(color: Colors.red)),
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
