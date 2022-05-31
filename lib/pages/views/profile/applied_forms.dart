import 'package:flutter/material.dart';
import 'package:hrms/core/themes/dark_theme.dart';
import 'package:hrms/core/themes/light_theme.dart';
import 'package:hrms/core/themes/padding.dart';

class AppliedsView extends StatefulWidget {
  const AppliedsView({Key? key}) : super(key: key);

  @override
  State<AppliedsView> createState() => _AppliedsViewState();
}

class _AppliedsViewState extends State<AppliedsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Başvurularım',
            style: darkMode
                ? DarkTheme().theme.textTheme.headline5
                : LightTheme().theme.textTheme.headline5),
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingAll,
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ListTile(
                leading: Icon(Icons.topic),
                title: Text('İlan Başlığı'),
                subtitle: Text(
                  'Maaş ve Tarih',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'İlan Detayı',
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ad soyad"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
