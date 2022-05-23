import 'package:flutter/material.dart';
import 'package:hrms/core/storage/dialog_storage.dart';
import 'package:hrms/pages/views/form_view.dart';
import 'package:hrms/pages/views/home_view.dart';
import 'package:hrms/pages/views/profile_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

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
      const HomePage(),
      const ProfileView(),
      const HomePage(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return const JobFormView();
                  },
                  fullscreenDialog: true),
            );
          }),
      bottomNavigationBar: StylishBottomBar(
        padding: EdgeInsets.zero,
        backgroundColor:
            darkMode ? const Color.fromARGB(255, 88, 88, 88) : Colors.white,
        items: [
          AnimatedBarItems(
            icon: const Icon(
              Icons.home,
            ),
            selectedColor: Colors.deepPurple.shade200,
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
            selectedColor: Colors.green.shade200,
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
              selectedColor: Colors.blueAccent.shade200,
              title: const Text(
                'Bildirimler',
                style: TextStyle(fontSize: 12),
              )),
          AnimatedBarItems(
              icon: const Icon(
                Icons.person,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.redAccent.shade200,
              title: const Text(
                'Profilim',
                style: TextStyle(fontSize: 12),
              )),
        ],

        iconSize: 24,
        // barAnimation: BarAnimation.liquid,

        barAnimation: BarAnimation.blink,
        iconStyle: IconStyle.animated,

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
            selected = index!;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastLinearToSlowEaseIn,
            );
          });
        },
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: tabPages(),
        controller: _pageController,
      ),
    );
  }
}
