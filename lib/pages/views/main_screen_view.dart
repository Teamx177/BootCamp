import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hireme/core/themes/lib_color_schemes.g.dart';
import 'package:hireme/pages/views/employer_notify_view.dart';
import 'package:hireme/pages/views/home_view.dart';
import 'package:hireme/pages/views/profile/profile_view.dart';
import 'package:hireme/pages/views/search_view.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../core/services/auth/auth_service.dart';
import '../../core/storage/firebase.dart';
import 'employee_notify_view.dart';

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
      _userType == "employee" ? const EmployeeNotifyView() : const EmployerNotifyView(),
      const ProfileView(),
    ];
  }

  @override
  void initState() {
    getEmployerNotification();
    getEmployeeNotification();
    getUser();
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int? _employeeNofiticationCount;
  int? _employerNofiticationCount;
  String? _userType;

  Future<void> getUser() async {
    final User? user = auth.currentUser;
    await userRef.doc(user?.uid).get().then((doc) {
      var userType = doc.data();
      setState(() {
        _userType = userType?['type'];
      });
    });
  }

  Future<void> getEmployeeNotification() async {
    await FirebaseFirestore.instance
        .collection("employeeNotifications")
        .where("employeeId", isEqualTo: AuthService.firebase().currentUser?.uid)
        .get()
        .then((doc) {
      var data = doc.docs.map((e) => e.data());
      setState(() {
        _employeeNofiticationCount = data.length;
      });
    });
  }

  Future<void> getEmployerNotification() async {
    await FirebaseFirestore.instance
        .collection("employerNotifications")
        .where("employerId", isEqualTo: AuthService.firebase().currentUser?.uid)
        .get()
        .then((doc) {
      var data = doc.docs.map((e) => e.data());
      setState(() {
        _employerNofiticationCount = data.length;
      });
    });
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
            // backgroundColor: Colors.,
            selectedColor: Color(0xFFC2C2C2),
            title: const Text(
              'Anasayfa',
              style: TextStyle(fontSize: 12),
            ),
          ),
          AnimatedBarItems(
            icon: const Icon(
              Icons.search,
            ),
            selectedColor: Color(0xFF7EC895),
            backgroundColor: Colors.amber,
            title: const Text(
              'Arama',
              style: TextStyle(fontSize: 12),
            ),
          ),
          AnimatedBarItems(
              icon: _userType == "employee"
                  ? Badge(
                badgeColor: const Color(0xFFDF2935),
                      animationType: BadgeAnimationType.scale,
                      showBadge: _employeeNofiticationCount != null && _employeeNofiticationCount! > 0,
                      badgeContent: Text(_employeeNofiticationCount.toString(),style: const TextStyle(
                        color: Colors.white
                      ),),
                      child: const Icon(Icons.notifications),
                    )
                  : Badge(
                badgeColor: const Color(0xFFDF2935),
                      animationType: BadgeAnimationType.scale,
                      showBadge: _employerNofiticationCount != null && _employerNofiticationCount! > 0,
                      badgeContent: Text(_employerNofiticationCount.toString(),style: const TextStyle(
                        color: Colors.white
                      ),),
                      child: const Icon(Icons.notifications),
                    ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.deepPurple.shade200,
              title: const Text(
                'Bildirimler',
                style: TextStyle(fontSize: 12),
              )),
          AnimatedBarItems(
              icon: const Icon(
                Icons.person,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.blueAccent.shade100,
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
          setState(() {
            getUser();
            getEmployerNotification();
            getEmployeeNotification();
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
        controller: _pageController,
        children: tabPages(),
      ),
    );
  }
}
