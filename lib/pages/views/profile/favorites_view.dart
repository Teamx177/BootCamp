import 'package:flutter/material.dart';
import 'package:hrms/core/themes/dark_theme.dart';
import 'package:hrms/core/themes/light_theme.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoriler',
            style: darkMode
                ? DarkTheme().theme.textTheme.headline5
                : LightTheme().theme.textTheme.headline5),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < 2; i++)
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.topic),
                      title: Text('İlan Başlığı'),
                      subtitle: Text(
                        'Maaş ve Tarih',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'İlan Detayı',
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          child: const Text(
                            'Başvuru Yap',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Text("Ad soyad"),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
