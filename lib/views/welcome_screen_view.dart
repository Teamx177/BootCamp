import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:hrms/main.dart';
import 'package:hrms/static_storage/texts.dart';

int value = 0;

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
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AnimatedToggleSwitch<int>.size(
                  current: value,
                  values: const [0, 1],
                  borderWidth: 2,
                  iconOpacity: 0.2,
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     spreadRadius: 1,
                  //     blurRadius: 2,
                  //     offset: Offset(0, 1.5),
                  //   ),
                  // ],
                  // indicatorSize: const Size.fromWidth(60),
                  animationCurve: Curves.easeOutCubic,
                  animationDuration: const Duration(milliseconds: 300),
                  // height: 60,
                  iconBuilder: (value, size) {
                    IconData data = Icons.dark_mode;
                    if (value.isEven) data = Icons.brightness_4;
                    return Icon(data, size: min(size.width, size.height));
                  },
                  borderColor:
                      value.isEven ? const Color.fromARGB(255, 99, 121, 146) : const Color.fromARGB(255, 99, 121, 146),
                  colorBuilder: (i) =>
                      i.isEven ? const Color.fromARGB(255, 255, 187, 0) : const Color.fromARGB(255, 98, 132, 172),
                  onChanged: (i) => setState(() {
                    value = i;
                    Hrms.themeNotifier.value = i.isEven ? ThemeMode.light : ThemeMode.dark;
                  }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
