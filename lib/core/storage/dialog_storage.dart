import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Bir hata oluştu'),
      content: Text(text),
      // backgroundColor: const Color.fromRGBO(208, 135, 112, 1),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Tamam',
            style: TextStyle(
                // color: Colors.black87,
                ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> showSuccessDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // backgroundColor: const Color.fromARGB(255, 163, 190, 140),
      title: const Text(
        'Başarılı',
      ),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Tamam',
            // style: TextStyle(color: Colors.black87),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: codeController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Done"),
          onPressed: onPressed,
        )
      ],
    ),
  );
}

var darkMode = Hive.box('themeData').get('darkmode', defaultValue: false);
