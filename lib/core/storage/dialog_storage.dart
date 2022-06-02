import 'package:flutter/material.dart';

import '../managers/route_manager.dart';

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

Future<void> goToRegister(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Kullanıcı Bulunamadı!'),
      content: const Text("Kayıt sayfasına yönlendiriliyorsunuz!"),
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
            router.go('/register');
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

Future<void> showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Gönderilen kodu giriniz"),
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
          onPressed: onPressed,
          child: const Text("Tamam"),
        ),
      ],
    ),
  );
}
