import 'package:flutter/material.dart';
import 'package:hrms/storage/text_storage.dart';
import 'package:hrms/themes/padding.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Padding(
          padding: ProjectPadding.pagePaddingAll,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/welcomeFirst.png',
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                WelcomeTexts.welcomeText,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 80,
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
