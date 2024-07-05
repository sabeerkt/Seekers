import 'package:flutter/material.dart';

class NeumorphicSearchField extends StatelessWidget {
  const NeumorphicSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 30,
      color: Colors.grey[300],
      child: TextField(
        onChanged: (value) {},
        style: const TextStyle(fontSize: 16, color: Colors.white),
        textAlignVertical: TextAlignVertical.center,
        controller: TextEditingController(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
          border: InputBorder.none, // Remove default border from here
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: 'Search',
          hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
          suffixIcon: Container(
            width: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.red,
                  Color.fromARGB(255, 0, 0, 0),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.search,
                color: Color.fromARGB(255, 210, 202, 202)),
          ),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;

  const PrimaryContainer({
    Key? key,
    this.radius,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? Color.fromARGB(255, 208, 201, 201),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
            color: Colors.grey.shade400, width: 1.5), // Border added here
      ),
      child: child,
    );
  }
}
