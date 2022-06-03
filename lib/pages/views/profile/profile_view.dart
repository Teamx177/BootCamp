import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hrms/core/managers/route_manager.dart';
import 'package:hrms/core/services/auth/auth_exceptions.dart';
import 'package:hrms/core/services/auth/auth_service.dart';
import 'package:hrms/core/storage/dialog_storage.dart';
import 'package:hrms/core/storage/text_storage.dart';
import 'package:hrms/core/themes/lib_color_schemes.g.dart';
import 'package:hrms/core/themes/padding.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    bool value;
    var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
    return Scaffold(
      extendBody: true,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              // childa image picker gelebilir.
              radius: 80,
              backgroundImage:
                  NetworkImage('https://picsum.photos/seed/picsum/200/300'),
            ),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Profilimi Düzenle'),
              onPressed: () {
                context.push('/edit-profile');
              },
            )),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.favorite_outline),
              label: const Text('Favorilerim'),
              onPressed: () {
                context.push('/favorites');
              },
            )),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.approval_outlined),
              label: const Text('Başvurularım'),
              onPressed: () {
                context.push('/applied-jobs');
              },
            )),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Ayarlar'),
              onPressed: () {
                context.push('/settings');
              }, // tema ayarları ayarlara alınabilir.
            )),
            _customContainer(
              child: TextButton.icon(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'Çıkış yapmak istediğinize emin misiniz?'),
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
                                  final user =
                                      AuthService.firebase().currentUser;
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
        color:
            darkMode ? darkColorScheme.onPrimary : lightColorScheme.onPrimary,
      ),
      child: child,
    );
  }
}