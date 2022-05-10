import 'package:flutter/material.dart';
import 'package:hrms/bottom_screens/home_page.dart';
import 'package:hrms/bottom_screens/profile_view.dart';

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
    const ProfileView(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 9,
        notchMargin: 1,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: Colors.green,
          iconSize: 20,
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: onTabTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ("Ana Sayfa")),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ("Arama")),
            BottomNavigationBarItem(icon: Icon(Icons.stop), label: ("Yeni ozellik")),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ("Hesabım")),
          ],
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        ),
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
