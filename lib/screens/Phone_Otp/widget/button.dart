import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonPhone extends StatelessWidget {
  const CustomButtonPhone(
      {super.key,
      required this.size,
      required this.buttonname,
      required this.onPressed});

  final Size size;
  final String buttonname;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        height: size.height * 0.08,
        width: size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)))),
          child: Text(buttonname,
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black)),
        ));
  }
}
