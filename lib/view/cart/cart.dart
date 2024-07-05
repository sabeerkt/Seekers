import 'package:flutter/material.dart';

class Cart_Page extends StatefulWidget {
  const Cart_Page({super.key});

  @override
  State<Cart_Page> createState() => _Cart_PageState();
}

class _Cart_PageState extends State<Cart_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
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
    );
  }
}
