import 'package:flutter/material.dart';
import 'package:hireme/pages/views/auth/widgets/form_field.dart';
import 'package:oktoast/oktoast.dart';

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
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Tamam',
            style: TextStyle(),
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
      title: const Text(
        'Başarılı',
      ),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Tamam',
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

Future<void> showUpdatePhoneDialog({
  required BuildContext context,
  required TextEditingController phoneController,
  required VoidCallback onPressed,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Yeni telefon numaranızı giriniz"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PhoneFormField(
            controller: phoneController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Vazgeç"),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Gönder"),
        ),
      ],
    ),
  );
}

void showOkToast({
  required String text,
}) {
  showToast(text,
      position: ToastPosition.bottom, backgroundColor: Colors.black45, duration: const Duration(seconds: 3));
}
