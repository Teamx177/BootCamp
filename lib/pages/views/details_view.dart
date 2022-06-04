import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/themes/padding.dart';

class DetailsView extends StatefulWidget {
  final String? docID;

  const DetailsView({Key? key, this.docID}) : super(key: key);

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobAdverts')
            .doc(widget.docID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: ProjectPadding.pagePaddingHorizontal,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data?.get('userName')),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data?.get('title')),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 50,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(snapshot.data?.get('category')),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 50,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(snapshot.data?.get('city')),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    autofocus: true,
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            selectedIndex == 0 ? Colors.green : null),
                                    onPressed: () async {
                                      setState(() {
                                        selectedIndex = 0;
                                      });
                                    },
                                    child: const Text('Açıklaması'))),
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            selectedIndex == 1 ? Colors.green : null),
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 1;
                                      });
                                    },
                                    child: const Text('Özellikler'))),
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            selectedIndex == 2 ? Colors.green : null),
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 2;
                                      });
                                    },
                                    child: const Text('Iletişim'))),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.33,
                          child: Align(
                            alignment: Alignment.center,
                            child: (selectedIndex == 0)
                                ? Text(snapshot.data?.get('description'))
                                : (selectedIndex == 1)
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Ücret",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "${snapshot.data?.get('minSalary')} TL - ${snapshot.data?.get('maxSalary')} TL"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Aranan Cinsiyet",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("${snapshot.data?.get('gender')}"),
                                        ],
                                      ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Açık Adres",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text("${snapshot.data?.get('fullAddress')}"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Telefon Numarası",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "${snapshot.data?.get('phone').toString().substring(3, 13)}"),
                                        ],
                                      ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: const Text('Şimdi Başvur')),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
