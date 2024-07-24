import 'package:flutter/material.dart';
import 'package:seeker/view/Home_Page/home.dart';
import 'package:seeker/view/Network/mynetwork.dart';
import 'package:seeker/view/setting_page/setting.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedindex = 0;

  void pageChanger(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  List<Widget> pages = [
    Home_Page(),
    My_Network(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        currentIndex: selectedindex,
        onTap: pageChanger,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedindex,
        children: pages,
      ),
    );
  }
}
