import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
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

  String? selectedCategory;
  File? selectedImage;
  File? selectedPDF;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameController.text = widget.student!.name ?? '';
      secondnameController.text = widget.student!.secondname ?? '';
      emailController.text = widget.student!.email ?? '';
      numberController.text = widget.student!.number ?? '';
      descriptionController.text = widget.student!.description ?? '';
      selectedCategory = widget.student!.category;
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
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green[100]!, Colors.white],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Consumer<BaseProvider>(
                        builder: (context, provider, child) {
                          final image = kIsWeb
                              ? provider.selectedImageWeb
                              : provider.selectedImage?.path ??
                                  selectedImage?.path;
                          return Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: image != null
                                      ? kIsWeb
                                          ? Image.network(image as String,
                                              fit: BoxFit.cover)
                                          : Image.file(File(image),
                                              fit: BoxFit.cover)
                                      : widget.student != null &&
                                              widget.student!.image != null
                                          ? Image.network(
                                              widget.student!.image!,
                                              fit: BoxFit.cover)
                                          : Icon(Icons.person,
                                              size: 60,
                                              color: Colors.grey[400]),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt,
                                        color: Colors.white, size: 20),
                                    onPressed: () =>
                                        pro.setImage(ImageSource.gallery),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(nameController, 'Name', Icons.person),
                          SizedBox(height: 16.0),
                          _buildTextField(secondnameController, 'Second Name',
                              Icons.person_outline),
                          SizedBox(height: 16.0),
                          _buildTextField(emailController, 'Email', Icons.email,
                              keyboardType: TextInputType.emailAddress),
                          SizedBox(height: 16.0),
                          _buildTextField(
                              numberController, 'Number', Icons.phone,
                              keyboardType: TextInputType.phone, maxLength: 10),
                          SizedBox(height: 16.0),
                          _buildTextField(descriptionController, 'Description',
                              Icons.description,
                              maxLines: 3),
                          SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            items: ['Business', 'Job Seeker']
                                .map((category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (kIsWeb) {
                                final result = await file_picker
                                    .FilePicker.platform
                                    .pickFiles(
                                  type: file_picker.FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );

                                if (result != null && result.files.isNotEmpty) {
                                  setState(() {
                                    selectedPDF =
                                        File(result.files.single.path!);
                                  });
                                }
                              } else {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null &&
                                    result.files.single.path != null) {
                                  setState(() {
                                    selectedPDF =
                                        File(result.files.single.path!);
                                  });
                                }
                              }
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Select PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                          if (selectedPDF != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Selected PDF: ${selectedPDF!.path.split('/').last}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    final name = nameController.text.trim();
                                    final secondname =
                                        secondnameController.text.trim();
                                    final email = emailController.text.trim();
                                    final number = numberController.text.trim();
                                    final description =
                                        descriptionController.text.trim();

                                    SeekerModel seeker = SeekerModel(
                                      name: name,
                                      secondname: secondname,
                                      email: email,
                                      number: number,
                                      description: description,
                                      image: pro.selectedImageWeb ??
                                          pro.selectedImage?.path ??
                                          selectedImage?.path,
                                      pdf: selectedPDF?.path,
                                      category: selectedCategory,
                                    );

                                    final seekerProvider =
                                        Provider.of<SeekerProvider>(context,
                                            listen: false);
                                    try {
                                      if (isEdit && widget.id != null) {
                                        await seekerProvider.updateSeeker(
                                            widget.id, seeker);
                                        if (pro.selectedImage != null) {
                                          await seekerProvider.updateImage(
                                              seeker.image!, pro.selectedImage);
                                        }
                                        if (selectedPDF != null) {
                                          await seekerProvider
                                              .pdfAdder(selectedPDF!);
                                        }
                                      } else {
                                        await seekerProvider.addSeeker(seeker);
                                        if (selectedPDF != null) {
                                          await seekerProvider
                                              .pdfAdder(selectedPDF!);
                                        }
                                        if (pro.selectedImage != null) {
                                          await seekerProvider
                                              .imageAdder(pro.selectedImage!);
                                        }
                                      }
                                      Navigator.pop(context);
                                    } catch (e) {
                                      // Handle any errors here
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Error: ${e.toString()}')),
                                      );
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                            child:
                                Text(isEdit ? 'Update Seeker' : 'Add Seeker'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Lottie.asset('assets/register.json'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType, int? maxLength, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
