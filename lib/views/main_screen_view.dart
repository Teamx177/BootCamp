import 'package:flutter/material.dart';
import 'package:hrms/bottom_screens/profile_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../bottom_screens/home_vıew.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var selected;
  int _pageIndex = 0;
  late PageController _pageController;

  List<Widget> tabPages = [
    const HomePage(),
    const ProfileView(),
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
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: const Color.fromARGB(255, 24, 23, 28),
        items: [
          AnimatedBarItems(
              icon: const Icon(
                Icons.home,
              ),
              selectedColor: Colors.deepPurple,
              backgroundColor: Colors.amber,
              title: const Text('Anasayfa')),
          AnimatedBarItems(
              icon: const Icon(
                Icons.search,
              ),
              selectedColor: Colors.green,
              backgroundColor: Colors.amber,
              title: const Text('Arama')),
          AnimatedBarItems(
              icon: const Icon(
                Icons.notifications,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.pinkAccent,
              title: const Text('Bildirimler')),
          AnimatedBarItems(
              icon: const Icon(
                Icons.person,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.blueAccent,
              title: const Text('Profilim')),
        ],

        iconSize: 32,
        barAnimation: BarAnimation.liquid,

        // barAnimation: BarAnimation.blink,
        // iconStyle: IconStyle.animated,

        // iconStyle: IconStyle.simple,
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        opacity: 0.3,
        currentIndex: selected ?? 0,

        //Bubble bar specific style properties
        //unselectedIconColor: Colors.grey,
        // barStyle: BubbleBarStyle.vertical,
        // bubbleFillStyle: BubbleFillStyle.fill,

        onTap: (index) {
          setState(() {
            selected = index;
            onTabTapped(selected);
          });
        },
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
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
}
