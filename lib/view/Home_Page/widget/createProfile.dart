import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/base_provider.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:seeker/widgets/bottombar.dart';

class AddEditPage extends StatefulWidget {
  final SeekerModel? student;
  final String? id;

  AddEditPage({Key? key, this.student, this.id}) : super(key: key);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController secondnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedDistrict;
  String? selectedGender;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameController.text = widget.student!.name ?? '';
      secondnameController.text = widget.student!.secondname ?? '';
      emailController.text = widget.student!.email ?? '';
      numberController.text = widget.student!.number ?? '';
      descriptionController.text = widget.student!.description ?? '';

      selectedImage =
          widget.student!.image != null ? File(widget.student!.image!) : null;
    } else {
      emailController.text = '@gmail.com';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<BaseProvider>(context);
    final isEdit = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Seeker' : 'Add Seeker'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<BaseProvider>(
                  builder: (context, provider, child) {
                    final image = kIsWeb
                        ? provider.selectedImageWeb
                        : provider.selectedImage?.path ?? selectedImage?.path;
                    return image != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: kIsWeb
                                  ? Image.network(
                                      image as String, // Cast to String for web
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(image), // Use as file for non-web
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          )
                        : widget.student != null &&
                                widget.student!.image != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    widget.student!.image!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        pro.setImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo),
                      label: const Text('Choose from Gallery'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'desc',
                      border: OutlineInputBorder(),
                    ),
                  ),
                   TextFormField(
                    controller: secondnameController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'secnd',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateFields()) {
                        if (isEdit) {
                          editStudent(context);
                        } else {
                          addStudent(context);
                        }
                      } else {
                        _showAlert(context, 'Please fill in all fields.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(isEdit ? 'Save' : 'Add'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFields() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        numberController.text.isNotEmpty;
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void addStudent(BuildContext context) async {
    final provider = Provider.of<SeekerProvider>(context, listen: false);
    final pro = Provider.of<BaseProvider>(context, listen: false);
    final name = nameController.text;
    final secondname = secondnameController.text;
    final email = emailController.text;
    final number = numberController.text;
    final description = descriptionController.text;

    String imageUrl;
    if (kIsWeb && pro.selectedImageWeb != null) {
      imageUrl = pro.selectedImageWeb!;
    } else if (pro.selectedImage != null) {
      await provider.imageAdder(pro.selectedImage!);
      imageUrl = provider.downloadurl;
    } else {
      imageUrl =
          'https://example.com/default_image.png'; // Replace with your default image URL
    }

    final seeker = SeekerModel(
      name: name,
      secondname: secondname,
      email: email,
      image: imageUrl,
      number: number,
      description: description,
    );

    provider.addSeeker(seeker);

    // Clear fields after adding student
    _clearFields();

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNav(),
      ),
    );
  }

  void editStudent(BuildContext context) async {
    final provider = Provider.of<SeekerProvider>(context, listen: false);
    final pro = Provider.of<BaseProvider>(context, listen: false);

    try {
      final editedName = nameController.text;
      final editsecondname = secondnameController.text;
      final editemail = emailController.text;
      final editnumber = numberController.text;
      final editdescription = descriptionController.text;

      String imageUrl;
      if (kIsWeb && pro.selectedImageWeb != null) {
        imageUrl = pro.selectedImageWeb!;
      } else if (pro.selectedImage != null) {
        await provider.imageAdder(pro.selectedImage!);
        imageUrl = provider.downloadurl;
      } else {
        imageUrl = widget
            .student!.image!; // Use existing image if no new image selected
      }

      final updatedSeeker = SeekerModel(
       name: editedName,
      secondname: editsecondname,
      email: editemail,
       image: imageUrl,
      
      number: editnumber,
      description: editdescription,
      );

      provider.updateSeeker(widget.id!, updatedSeeker);

      Navigator.pop(context);
    } catch (e) {
      print("Error updating student: $e");
    }
  }

  void _clearFields() {
    nameController.clear();
    descriptionController.clear();
    emailController.clear();
    numberController.clear();
    secondnameController.clear();
    setState(() {
      selectedImage = null;
      selectedDistrict = null;
      selectedGender = null;
    });
  }
}
