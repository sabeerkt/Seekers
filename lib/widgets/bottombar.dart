import 'package:flutter/material.dart';
import 'package:seeker/view/cart/cart.dart';
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
    Cart_Page(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor:
            Colors.black, // Set the unselected icon color to white
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
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
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
