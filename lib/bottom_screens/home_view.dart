import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/storage/firebase.dart';
import 'package:hrms/themes/padding.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, currentUserType}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> userType;
  late String currentUserType;
  late String currentUserName;
  late bool isFavorite;

  @override
  void initState() {
    currentUserType = '';
    currentUserName = '';
    isFavorite = false;
    userType = getUserById();
    super.initState();
  }

  Future<String> getUserById() async {
    final User? user = auth.currentUser;
    await userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
      currentUserType = userType?['type'];
      currentUserName = userType?['name'];
    });
    return currentUserType;
  }

  @override
  Widget build(BuildContext context) {
    currentUserName = currentUserName.split(" ")[0];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: ProjectPadding.pagePaddingAll,
        child: FutureBuilder<String>(
          future: userType, // async work
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "İş İlanları",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      for (var i = 0; i < 5; i++)
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.topic),
                                trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });
                                    },
                                    icon: isFavorite
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: Colors.grey,
                                          ),
                                ),
                                title: const Text('İlan Başlığı'),
                                subtitle: const Text(
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
                                    onPressed: () {
                                    },
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
                          margin: const EdgeInsets.all(16.0),
                        ),
                    ],
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Result: ${snapshot.data}');
                }
            }
          },
        ),
      ),
    );
  }
}
