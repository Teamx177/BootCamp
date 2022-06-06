import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hireme/core/managers/route_manager.dart';
import 'package:hireme/core/services/auth/auth_exceptions.dart';
import 'package:hireme/core/services/auth/auth_service.dart';
import 'package:hireme/core/storage/dialog_storage.dart';
import 'package:hireme/core/storage/firebase.dart';
import 'package:hireme/core/storage/text_storage.dart';
import 'package:hireme/core/storage/validation_storage.dart';
import 'package:hireme/core/themes/lib_color_schemes.g.dart';
import 'package:hireme/core/themes/padding.dart';
import 'package:hireme/pages/views/auth/widgets/form_field.dart';
import 'package:hive/hive.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _userType;
  String? _userPic;

  @override
  initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    final User? user = auth.currentUser;
    await userRef.doc(user?.uid).get().then((doc) {
      var data = doc.data();
      setState(() {
        _userType = data?['type'];
        _userPic = data?['picture'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool value;
    var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 100,
                  child: _userPic != null
                      ? Image.asset(
                          _userPic.toString(),
                        )
                      : null,
                ),
                _customContainer(
                    child: TextButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Profilimi Düzenle'),
                  onPressed: () {
                    context.push('/edit-profile');
                  },
                )),
                _userType == "employee"
                    ? _customContainer(
                        child: TextButton.icon(
                        icon: const Icon(Icons.approval_outlined),
                        label: const Text('Başvurularım'),
                        onPressed: () {
                          context.push('/applied-jobs');
                        },
                      ))
                    : _customContainer(
                        child: TextButton.icon(
                        icon: const Icon(Icons.approval_outlined),
                        label: const Text('Gelen Başvurular'),
                        onPressed: () {
                          context.push('/incoming-applications');
                        },
                      )),
                _customContainer(
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
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(AuthStatusTexts.cancel),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            var credential = EmailAuthProvider.credential(
                                                email: _emailController.text, password: _passwordController.text);
                                            await FirebaseAuth.instance.currentUser
                                                ?.reauthenticateWithCredential(credential)
                                                .then((_) async {
                                              showDialog(
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
                                                            style: TextButton.styleFrom(primary: Colors.red),
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
                    label: Text(UpdateTexts.delete),
                    icon: const Icon(Icons.delete_forever),
                  ),
                ),
                _customContainer(
                  child: TextButton.icon(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Çıkış yapmak istediğinize emin misiniz?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Vazgeç')),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await AuthService.firebase().logOut();
                                        router.push('/');
                                      } on UserNotFoundAuthException {
                                        showErrorDialog(
                                          context,
                                          ErrorTexts.errorOnExit,
                                        );
                                      }
                                      final user = AuthService.firebase().currentUser;
                                      if (user == null) {
                                        router.go('/login');
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showErrorDialog(
                                          context,
                                          ErrorTexts.errorOnExit,
                                        );
                                      }
                                    },
                                    child: const Text('Çıkış Yap'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.exit_to_app_outlined),
                      label: Text(AuthStatusTexts.exit)),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class _customContainer extends StatelessWidget {
  dynamic child;

  _customContainer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
    return Container(
      height: 60,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: darkMode ? darkColorScheme.onPrimary : lightColorScheme.onPrimary,
      ),
      child: child,
    );
  }
}
