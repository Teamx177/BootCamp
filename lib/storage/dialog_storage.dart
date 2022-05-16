import 'package:flutter/material.dart';

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
