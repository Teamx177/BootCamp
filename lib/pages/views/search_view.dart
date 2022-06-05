import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/pages/views/details_view.dart';

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

  getCategory() {
    var a = FirebaseFirestore.instance
        .collection('jobAdverts')
        .doc()
        .snapshots()
        .where((event) => event.data()?['category']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('jobAdverts').where('category').snapshots(),
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          print(snapshot.data?.docs.map((e) => e.get(
                                'category',
                              )));
                        },
                        child: const Text('Temizlik')),
                  ],
                );
              }),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobAdverts').snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;
                        if (data['title'].toString().toLowerCase().startsWith(searchText.toLowerCase())) {
                          return ListTile(
                            title: Text(
                              "${data['title']} - ${data['userName']}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${data['category']} / ${data['city']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              FirebaseFirestore.instance.collection('jobAdverts').doc(data['id']);
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
                      }),
                );
        },
      ),
    );
  }
}
