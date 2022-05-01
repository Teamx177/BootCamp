import 'package:flutter/material.dart';
import 'package:hrms/screens/sing_up.dart';
import 'package:hrms/static_storage/texts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.network('https://picsum.photos/seed/picsum/200/300'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SingUp(),
                      ),
                    );
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
