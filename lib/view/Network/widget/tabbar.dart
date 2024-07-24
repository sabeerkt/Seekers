import 'package:flutter/material.dart';

class CustomTabbar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  const CustomTabbar({Key? key, required this.controller}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0XFF5E5E5E),
            Color(0XFF3E3E3E),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 0, 0),
              Color.fromARGB(255, 235, 120, 120),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        tabs: const [
          Tab(
            text: 'Business',
          ),
          Tab(
            text: 'Profession',
          ),
        ],
      ),
    );
  }
}
