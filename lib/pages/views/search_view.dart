import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/views/details_view.dart';
import 'package:hrms/pages/views/profile/applied_forms.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List asd = [];
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<DocumentSnapshot> documents = [];
  late bool isListView;

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    isListView = false;
    super.initState();
  }

  void _onSearchChanged() {
    setState(() {
      searchText = _searchController.text;
    });
  }

  jobAdvertsSnapshot() {
    FirebaseFirestore.instance.collection('jobAdverts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Expanded(
            flex: 90,
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Ara',
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    isListView = false;
                  } else {
                    isListView = true;
                  }
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 10,
            child: IconButton(
              icon: const Icon(Icons.filter_vintage),
              onPressed: () {
                setState(() {
                  searchText = '';
                  isListView = !isListView;
                });
              },
            ),
          ),
        ]),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobAdverts').snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : isListView
                  ? ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        if (data['title']
                            .toString()
                            .toLowerCase()
                            .startsWith(searchText.toLowerCase())) {
                          return ListTile(
                            title: Text(
                              "${data['title']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            subtitle: Text(
                              data['city'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection('jobAdverts')
                                  .doc(data['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsView(
                                    docID: snapshots.data?.docs[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      })
                  : Padding(
                      padding: ProjectPadding.pagePaddingHorizontal,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              '  Hızlı Arama',
                              style: GoogleFonts.rubik(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        var data = FirebaseFirestore.instance
                                            .collection('jobAdverts')
                                            .where('category',
                                                isEqualTo: 'Temizlik')
                                            .get()
                                            .then(
                                                (value) => (value.docs.map((e) {
                                                      setState(() {
                                                        asd.add(e.data());
                                                      });
                                                    })))
                                            .then((value) => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const AppliedsView()),
                                                ));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Temizlik'),
                                          const Text('5 iş')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        print('pressed');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Nakliyat'),
                                          const Text('4 iş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        print('pressed');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Nakliyat'),
                                          const Text('4 iş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        print('pressed');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Nakliyat'),
                                          const Text('4 iş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        print('pressed');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Nakliyat'),
                                          const Text('4 iş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        print('pressed');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Nakliyat'),
                                          const Text('4 iş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Card(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          primary: Colors.black,
                                          // backgroundColor: Colors.amber,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      onPressed: () {
                                        print('pressed');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepOrange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                                Icons.cleaning_services),
                                          ),
                                          const Text('Nakliyat'),
                                          const Text('4 iş'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
