import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:seeker/view/Home_Page/widget/button.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? selectedImage;
  String? selectedFileName;

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    );
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
      print('Selected image: ${result.files.single.name}');
    } else {
      print('User canceled the image picker');
    }
  }

  Future<void> uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        selectedFileName = file.name;
      });
      // Handle the selected file here (e.g., upload it to a server)
      print('Selected file: ${file.name}');
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }
  }

  void navigateBackWithData() {
    Navigator.pop(context, {
      'fullName': '${firstNameController.text} ${lastNameController.text}',
      'phoneNumber': phoneNumberController.text,
      'email': emailController.text,
      'description': descriptionController.text,
      'selectedImage': selectedImage,
      'selectedFileName': selectedFileName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image loading container
              InkWell(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150, // Adjust as needed
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3), // Placeholder color
                    image: selectedImage != null
                        ? DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: selectedImage == null
                      ? Center(
                          child: Text(
                            'Select Image',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: firstNameController,
                decoration: inputDecoration('First Name'),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                decoration: inputDecoration('Last Name'),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneNumberController,
                decoration: inputDecoration('Phone Number'),
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3, // Adjust as needed
                decoration: inputDecoration('Description'),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: uploadDocument, // Link the uploadDocument method here
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_upload),
                      const SizedBox(width: 12),
                      Text(selectedFileName ?? 'Upload Document'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OutlineCancelButton(
                onTap: navigateBackWithData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
