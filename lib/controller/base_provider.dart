import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // Add import for Uint8List
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  File? _selectedImage;
  ImagePicker imagePicker = ImagePicker();
  Uint8List? selectedImageBytes; // To store the Uint8List of the selected image
  String?
      selectedImageWeb; // To store the base64 or URL of the selected image for web

  File? get selectedImage => _selectedImage;

  Future<void> setImage(ImageSource source) async {
    if (kIsWeb) {
      final pickedImage = await imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        selectedImageBytes = bytes; // Store image as Uint8List
        selectedImageWeb =
            "data:image/png;base64,${base64Encode(bytes)}"; // Base64 encoding for web
        _selectedImage =
            null; // Clear selected image if switching from web to local
      } else {
        selectedImageBytes = null;
        selectedImageWeb = null;
      }
    } else {
      final pickedImage = await imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        final file = File(pickedImage.path);
        if (await file.exists()) {
          _selectedImage = file;
          final bytes = await file.readAsBytes();
          selectedImageBytes = bytes; // Store image as Uint8List
        } else {
          _selectedImage = null;
          selectedImageBytes = null;
        }
      } else {
        _selectedImage = null;
        selectedImageBytes = null;
      }
      selectedImageWeb =
          null; // Clear web selected image if switching from local to web
    }
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    selectedImageBytes = null;
    selectedImageWeb = null;
    notifyListeners();
  }
}
