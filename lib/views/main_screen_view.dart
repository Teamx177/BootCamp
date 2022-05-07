import 'package:flutter/material.dart';
import 'package:hrms/bottom_screens/home_page.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ("Ana Sayfa")),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ("Arama")),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ("Hesabım")),
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
