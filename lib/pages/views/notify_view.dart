import 'package:flutter/material.dart';

class NotifyView extends StatefulWidget {

  const NotifyView({Key? key}) : super(key: key);

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('NotifyView'),
      ),
    );
  }
}
