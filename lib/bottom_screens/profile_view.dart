import 'package:flutter/material.dart';
import 'package:hrms/main.dart';
import 'package:hrms/themes/padding.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Hrms.themeNotifier.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                Hrms.themeNotifier.value =
                    Hrms.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
              })
        ],
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingHorizontal,
        child: Column(
          children: [
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
