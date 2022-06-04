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
  late String selectedText;
  var index = 0;
  @override
  void initState() {
    selectedIndex = 0;
    selectedText = '';
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
                        Text(snapshot.data?.get('title')),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(snapshot.data?.get('userName')),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.amber[50]),
                                onPressed: () {},
                                child: Text(snapshot.data?.get('category')),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {},
                                child: const Text('Acil'),
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
                                flex: 75,
                                child: Text(
                                  '${snapshot.data?.get('minSalary')} - ${snapshot.data?.get('maxSalary')}',
                                )),
                            Expanded(
                                flex: 25,
                                child: Text(snapshot.data?.get('city'))),
                          ],
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    autofocus: true,
                                    onPressed: () async {
                                      selectedIndex = 0;
                                      setState(() {
                                        selectedIndex = 0;
                                        selectedText =
                                            snapshot.data?.get('description');
                                      });
                                    },
                                    child: const Text('Ilan detayı'))),
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 1;
                                        selectedText =
                                            '${snapshot.data?.get('gender')} - ${snapshot.data?.get('shift')}';
                                      });
                                    },
                                    child: const Text('Gereksinimler'))),
                            Expanded(
                                flex: 25,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 2;
                                        selectedText =
                                            snapshot.data?.get('fullAdress');
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
                            child: Text(selectedText),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: const Text('Şimdi Başvur')),
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
