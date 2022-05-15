import 'package:flutter/material.dart';
import 'package:hrms/main.dart';
import 'package:hrms/services/auth/auth_exceptions.dart';
import 'package:hrms/services/auth/auth_service.dart';
import 'package:hrms/static_storage/texts.dart';
import 'package:hrms/themes/lib_color_schemes.g.dart';
import 'package:hrms/themes/padding.dart';

import '../static_storage/dialogs.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Hrms.themeNotifier.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: () {
                setState(() {
                  Hrms.themeNotifier.value = Hrms.themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                });
              }),
        ],
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              // childa image picker gelebilir.
              radius: 80,
              backgroundImage: NetworkImage('https://picsum.photos/seed/picsum/200/300'),
            ),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Profilimi Düzenle'),
              onPressed: () {},
            )),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.favorite_outline),
              label: const Text('Favorilerim'),
              onPressed: () {},
            )),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.approval_outlined),
              label: const Text('Başvurularım'),
              onPressed: () {},
            )),
            _customContainer(
                child: TextButton.icon(
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Ayarlar'),
              onPressed: () {}, // tema ayarları ayarlara alınabilir.
            )),
            _customContainer(
              child: TextButton.icon(
                  onPressed: () async {
                    try {
                      await AuthService.firebase().logOut();
                    } on UserNotFoundAuthException {
                      showErrorDialog(
                        context,
                        ErrorTexts.errorOnExit,
                      );
                    }
                    final user = AuthService.firebase().currentUser;
                    if (user == null) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      showErrorDialog(
                        context,
                        ErrorTexts.errorOnExit,
                      );
                    }
                  },
                  icon: const Icon(Icons.exit_to_app_outlined),
                  label: const Text('Çıkış Yap')),
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
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeMode.dark == Hrms.themeNotifier.value
            ? darkColorScheme.onPrimary
            : lightColorScheme.onPrimary,
      ),
      child: child,
    );
  }
}
