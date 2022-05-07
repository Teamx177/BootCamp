import 'package:flutter/material.dart';
import 'package:hrms/main.dart';
import 'package:hrms/static_storage/texts.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.transparent,
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
        body: SafeArea(
          child: Column(
            children: [
              Image.asset(
                'assets/images/welcomeFirst.png',
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  WelcomeTexts.welcomeText,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(right: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(Icons.arrow_forward_outlined),
                  label: Text(WelcomeTexts.buttonText),
                ),
              ),
            ],
          ),
        ));
  }
}
