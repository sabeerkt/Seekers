import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  File? _selectedImage;
  ImagePicker imagePicker = ImagePicker();
  String?
      selectedImageWeb; // To store the base64 or URL of the selected image for web

  File? get selectedImage => _selectedImage;

  Future<void> setImage(ImageSource source) async {
    if (kIsWeb) {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        selectedImageWeb = await pickedImage
            .readAsBytes()
            .then((bytes) => "data:image/png;base64,${base64Encode(bytes)}");
        _selectedImage =
            null; // Clear selected image if switching from web to local
      } else {
        selectedImageWeb = null;
      }
    } else {
      final pickedImage = await imagePicker.pickImage(source: source);
      _selectedImage = pickedImage != null ? File(pickedImage.path) : null;
      selectedImageWeb =
          null; // Clear web selected image if switching from local to web
    }
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    selectedImageWeb = null;
    notifyListeners();
  }
}
