import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/base_provider.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

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
  File? selectedPDF;

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
                ElevatedButton.icon(
                  onPressed: () {
                    pro.setImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Choose from Gallery'),
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
                    controller: secondnameController,
                    decoration: InputDecoration(
                      labelText: 'Second Name',
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
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (kIsWeb) {
                        // For web platform, use input element to select PDF
                        final result =
                            await file_picker.FilePicker.platform.pickFiles(
                          type: file_picker.FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            selectedPDF = File(result.files.single.path!);
                          });
                        }
                      } else {
                        // For mobile platform, use image_picker package
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null && result.files.single.path != null) {
                          setState(() {
                            selectedPDF = File(result.files.single.path!);
                          });
                        }
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Select PDF'),
                  ),
                  if (selectedPDF != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Selected PDF: ${selectedPDF!.path.split('/').last}'),
                    ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final secondname = secondnameController.text.trim();
                      final email = emailController.text.trim();
                      final number = numberController.text.trim();
                      final description = descriptionController.text.trim();

                      SeekerModel seeker = SeekerModel(
                        name: name,
                        secondname: secondname,
                        email: email,
                        number: number,
                        description: description,
                        image: pro.selectedImageWeb ?? pro.selectedImage?.path ?? selectedImage?.path,
                        pdf: selectedPDF?.path,
                      );

                      final seekerProvider =
                          Provider.of<SeekerProvider>(context, listen: false);
                      if (isEdit && widget.id != null) {
                        seekerProvider.updateSeeker(widget.id, seeker);
                        if (pro.selectedImage != null) {
                          await seekerProvider.updateImage(
                              seeker.image!, pro.selectedImage);
                        }
                        if (selectedPDF != null) {
                          await seekerProvider.pdfAdder(selectedPDF!);
                        }
                      } else {
                        await seekerProvider.addSeeker(seeker);
                        if (selectedPDF != null) {
                          await seekerProvider.pdfAdder(selectedPDF!);
                        }
                        if (pro.selectedImage != null) {
                          await seekerProvider.imageAdder(pro.selectedImage!);
                        }
                      }

                      Navigator.pop(context);
                    },
                    child: Text(isEdit ? 'Update Seeker' : 'Add Seeker'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
