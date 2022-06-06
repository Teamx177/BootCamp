import 'package:flutter/material.dart';
import 'package:hireme/core/themes/lib_color_schemes.g.dart';
import 'package:hireme/pages/views/home_view.dart';
import 'package:hireme/pages/views/profile/profile_view.dart';
import 'package:hireme/pages/views/search_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'notify_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  dynamic selected;
  late PageController _pageController;

  List<Widget> tabPages() {
    return <Widget>[
      const HomeView(),
      const SearchView(),
      const NotifyView(),
      const ProfileView(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: darkColorScheme.outline,
        padding: EdgeInsets.zero,
        items: [
          AnimatedBarItems(
            icon: const Icon(
              Icons.home,
            ),
            selectedColor: Colors.deepPurpleAccent,
            backgroundColor: Colors.amber,
            title: const Text(
              'Anasayfa',
              style: TextStyle(fontSize: 12),
            ),
          ),
          AnimatedBarItems(
            icon: const Icon(
              Icons.search,
            ),
            selectedColor: Colors.green,
            backgroundColor: Colors.amber,
            title: const Text(
              'Arama',
              style: TextStyle(fontSize: 12),
            ),
          ),
          AnimatedBarItems(
              icon: const Icon(
                Icons.notifications,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.blueAccent,
              title: const Text(
                'Bildirimler',
                style: TextStyle(fontSize: 12),
              )),
          AnimatedBarItems(
              icon: const Icon(
                Icons.person,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.redAccent,
              title: const Text(
                'Profilim',
                style: TextStyle(fontSize: 12),
              )),
        ],
        iconSize: 24,
        barAnimation: BarAnimation.fade,
        iconStyle: IconStyle.Default,
        hasNotch: false,
        opacity: 0.3,
        currentIndex: selected ?? 0,
        onTap: (index) {
          setState(
            () {
              selected = index!;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastLinearToSlowEaseIn,
              );
            },
          );
        },
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        controller: _pageController,
        children: tabPages(),
      ),
    );
  }
}
