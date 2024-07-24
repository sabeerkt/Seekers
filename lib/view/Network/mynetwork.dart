import 'package:flutter/material.dart';
import 'package:seeker/view/Network/widget/list.dart';
import 'package:seeker/view/Network/widget/tabbar.dart'; // Make sure to import your CustomTabbar widget

class My_Network extends StatefulWidget {
  const My_Network({Key? key}) : super(key: key);

  @override
  State<My_Network> createState() => _My_NetworkState();
}

class _My_NetworkState extends State<My_Network> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Network",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 6.0,
          shadowColor: Colors.black.withOpacity(0.3),
          automaticallyImplyLeading: false,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTabbar(), // Include the CustomTabbar here
              Expanded(
                child: TabBarView(
                  children: [
                    // Add your content for each tab view here
                    List_Seeker(),
                    List_Seeker(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
