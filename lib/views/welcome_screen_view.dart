import 'package:flutter/material.dart';
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
                    Navigator.pushNamed(
                      context,
                      '/signUp',
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
