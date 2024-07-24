import 'package:flutter/material.dart';
import 'package:seeker/view/Home_Page/widget/serch.dart';

class CustomTabbar extends StatelessWidget {
  final TabController controller;
  const CustomTabbar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 30,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        indicator: BoxDecoration(
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
