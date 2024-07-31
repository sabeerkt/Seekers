import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/view/Home_Page/widget/createProfile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:seeker/model/seeker_model.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailPage extends StatefulWidget {
  final SeekerModel seeker;

  const DetailPage({
    Key? key,
    required this.seeker,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late SeekerModel _currentSeeker;

  @override
  void initState() {
    super.initState();
    _currentSeeker = widget.seeker;
  }

  void _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openWhatsApp(String phoneNumber) async {
    var whatsappUrl = "https://wa.me/$phoneNumber";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  void _openPdfPopup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('PDF Viewer'),
              backgroundColor: Colors.red,
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: PDFView(
              filePath: _currentSeeker.pdf ?? '',
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            ),
          );
        },
      ),
    );
  }

  Future<void> _uploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final seekerProvider =
          Provider.of<SeekerProvider>(context, listen: false);

      try {
        await seekerProvider.imageAdder(imageFile);
        String newImageUrl = seekerProvider.downloadurl;

        SeekerModel updatedSeeker = SeekerModel(
          id: _currentSeeker.id,
          name: _currentSeeker.name,
          secondname: _currentSeeker.secondname,
          email: _currentSeeker.email,
          number: _currentSeeker.number,
          description: _currentSeeker.description,
          pdf: _currentSeeker.pdf,
          category: _currentSeeker.category,
          image: newImageUrl,
        );

        await seekerProvider.updateSeeker(_currentSeeker.id!, updatedSeeker);

        setState(() {
          _currentSeeker = updatedSeeker;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  bool _isCurrentUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == _currentSeeker.id;
  }

  @override
  Widget build(BuildContext context) {
    final seekerProvider = Provider.of<SeekerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_currentSeeker.name ?? 'Details'),
        elevation: 0,
        actions: [
          if (_isCurrentUser())
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditPage(student: _currentSeeker),
                  ),
                );
              },
            ),
          Consumer<SeekerProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  seekerProvider.isFavorite(_currentSeeker)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (seekerProvider.isFavorite(_currentSeeker)) {
                    seekerProvider.removeFavorite(_currentSeeker);
                  } else {
                    seekerProvider.addFavorite(_currentSeeker);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _getImageProvider(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      _currentSeeker.name ?? '',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    'Contact Options:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildContactOption(context),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                      'Subtitle', _currentSeeker.secondname ?? ''),
                  _buildInfoSection(
                      'Description', _currentSeeker.description ?? ''),
                  _buildInfoSection('Category', _currentSeeker.category ?? ''),
                  const SizedBox(height: 20),
                  const Text(
                    'Uploaded Document:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPdfSection(context),
                  const SizedBox(height: 20),
                  const Text(
                    'Uploaded Image:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  if (_isCurrentUser())
                    ElevatedButton.icon(
                      onPressed: () => _uploadImage(context),
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Upload New Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if ((_currentSeeker.image ?? '').startsWith('http') ||
        (_currentSeeker.image ?? '').startsWith('https')) {
      return NetworkImage(_currentSeeker.image!);
    } else if (_currentSeeker.image != null &&
        _currentSeeker.image!.isNotEmpty) {
      return FileImage(File(_currentSeeker.image!));
    } else {
      return const AssetImage('assets/default_profile.jpg');
    }
  }

  Widget _buildContactOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => _makePhoneCall('tel:${_currentSeeker.number}'),
          icon: const Icon(Icons.call, color: Colors.green, size: 40),
        ),
        IconButton(
          onPressed: () => _openWhatsApp(_currentSeeker.number ?? ''),
          icon: const Icon(Icons.message, color: Colors.green, size: 40),
        ),
        IconButton(
          onPressed: () {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: _currentSeeker.email ?? '',
            );
            launch(emailLaunchUri.toString());
          },
          icon: const Icon(Icons.email, color: Colors.green, size: 40),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfSection(BuildContext context) {
    return Column(
      children: [
        if (_currentSeeker.pdf != null && _currentSeeker.pdf!.isNotEmpty)
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => _openPdfPopup(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('View PDF'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          )
        else
          const Text(
            'No document uploaded',
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        if (_currentSeeker.image != null && _currentSeeker.image!.isNotEmpty)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _getImageProvider(),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          )
        else
          const Text(
            'No image uploaded',
            style: TextStyle(fontSize: 18),
          ),
      ],
    );
  }
}
