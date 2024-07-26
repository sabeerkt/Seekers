import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CustomPhoneField extends StatefulWidget {
  CustomPhoneField({super.key, required this.phonecontroller});

  final TextEditingController phonecontroller;

  @override
  _CustomPhoneFieldState createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  Country selectedCountry = Country(
    phoneCode: "+91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 10,
      controller: widget.phonecontroller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter your phone number",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    setState(() {
                      selectedCountry = country;
                    });
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "${selectedCountry.flagEmoji} ${selectedCountry.phoneCode}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
