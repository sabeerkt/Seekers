import 'package:flutter/material.dart';

class OutlineCancelButton extends StatefulWidget {
  const OutlineCancelButton({Key? key, required void Function() onTap})
      : super(key: key);

  @override
  State<OutlineCancelButton> createState() => _OutlineCancelButtonState();
}

class _OutlineCancelButtonState extends State<OutlineCancelButton> {
  bool _isOutline = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
      child: InkWell(
        onTap: () {
          setState(() {
            _isOutline = !_isOutline;
          });
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: !_isOutline ? Colors.red : null,
            border: _isOutline
                ? Border.all(color: Color.fromARGB(255, 0, 0, 0))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isOutline
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline_rounded,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              const SizedBox(width: 10),
              Text(
                'Create Profile',
                style: TextStyle(
                  fontSize: 16,
                  color: _isOutline
                      ? Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
