// import 'package:flutter/material.dart';
// import 'package:hrms/screens/log_in.dart';
// import 'package:hrms/static_storage/firebase.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Text(
//               'Welcome',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 auth.signOut();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => const LoginPage(),
//                   ),
//                 );
//               },
//               child: const Center(child: Text('Cikis Yap')),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Anasayfa',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search_outlined),
//             label: 'Arama',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.join_full_outlined),
//             label: 'Işler',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hrms/bottom_screens/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;
  late PageController _pageController;

  List<Widget> tabPages = [
    const HomePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ("Search")),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ("Account")),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
