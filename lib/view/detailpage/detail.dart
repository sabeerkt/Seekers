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
              filePath: widget.seeker.pdf ?? '',
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
          id: widget.seeker.id,
          name: widget.seeker.name,
          secondname: widget.seeker.secondname,
          email: widget.seeker.email,
          number: widget.seeker.number,
          description: widget.seeker.description,
          pdf: widget.seeker.pdf,
          category: widget.seeker.category,
          image: newImageUrl,
        );

        await seekerProvider.updateSeeker(widget.seeker.id!, updatedSeeker);

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
    return currentUser != null && currentUser.uid == widget.seeker.id;
  }

  @override
  Widget build(BuildContext context) {
    final seekerProvider = Provider.of<SeekerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.seeker.name ?? 'Details'),
        elevation: 0,
        actions: [
          if (_isCurrentUser())
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditPage(student: widget.seeker),
                  ),
                );
              },
            ),
          Consumer<SeekerProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  seekerProvider.isFavorite(widget.seeker)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (seekerProvider.isFavorite(widget.seeker)) {
                    seekerProvider.removeFavorite(widget.seeker);
                  } else {
                    seekerProvider.addFavorite(widget.seeker);
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
                  child: _getImageErrorWidget(),
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
                      widget.seeker.name ?? '',
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
                  _buildInfoSection('Subtitle', widget.seeker.secondname ?? ''),
                  _buildInfoSection(
                      'Description', widget.seeker.description ?? ''),
                  _buildInfoSection('Category', widget.seeker.category ?? ''),
                  const SizedBox(height: 20),
                  const Text(
                    'Uploaded Document:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPdfSection(context),
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
      floatingActionButton: Consumer<SeekerProvider>(
        builder: (context, value, child) => FloatingActionButton(
          onPressed: () => seekerProvider.imageAdderSeeker(context),
          child: const Icon(Icons.add_photo_alternate),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if ((widget.seeker.image ?? '').startsWith('http') ||
        (widget.seeker.image ?? '').startsWith('https')) {
      return NetworkImage(widget.seeker.image!);
    } else if (widget.seeker.image != null && widget.seeker.image!.isNotEmpty) {
      return FileImage(File(widget.seeker.image!));
    } else {
      return const AssetImage('assets/default_profile.jpg');
    }
  }

  Widget _getImageErrorWidget() {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: const Text(
        'Error loading image',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildContactOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => _makePhoneCall('tel:${widget.seeker.number}'),
          icon: const Icon(Icons.call, color: Colors.green, size: 40),
        ),
        IconButton(
          onPressed: () => _openWhatsApp(widget.seeker.number ?? ''),
          icon: const Icon(Icons.message, color: Colors.green, size: 40),
        ),
        IconButton(
          onPressed: () {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: widget.seeker.email ?? '',
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
        if (widget.seeker.pdf != null && widget.seeker.pdf!.isNotEmpty)
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
}
