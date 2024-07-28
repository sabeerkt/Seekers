import 'package:flutter/material.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:seeker/model/seeker_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final SeekerModel seeker;

  const DetailPage({
    Key? key,
    required this.seeker,
  }) : super(key: key);

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PDF Viewer',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PDFView(filePath: seeker.pdf ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadFile(
                        context, seeker.pdf ?? '', 'document.pdf'),
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadFile(
      BuildContext context, String url, String fileName) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      final savePath = "${dir!.path}/$fileName";
      final dio = Dio();

      try {
        await dio.download(
          url,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
            }
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded successfully to $savePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final seekerProvider = Provider.of<SeekerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(seeker.name ?? 'Details'),
        elevation: 0,
        actions: [
          Consumer<SeekerProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  seekerProvider.isFavorite(seeker)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (seekerProvider.isFavorite(seeker)) {
                    seekerProvider.removeFavorite(seeker);
                  } else {
                    seekerProvider.addFavorite(seeker);
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
                      seeker.name ?? '',
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
                  _buildInfoSection('Subtitle', seeker.secondname ?? ''),
                  _buildInfoSection('Description', seeker.description ?? ''),
                  _buildInfoSection('Category', seeker.category ?? ''),
                  const SizedBox(height: 20),
                  const Text(
                    'Uploaded Document:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPdfSection(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if ((seeker.image ?? '').startsWith('http') ||
        (seeker.image ?? '').startsWith('https')) {
      return NetworkImage(seeker.image!);
    } else if (seeker.image != null && seeker.image!.isNotEmpty) {
      return FileImage(File(seeker.image!));
    } else {
      return const AssetImage('assets/default_profile.png');
    }
  }

  Widget? _getImageErrorWidget() {
    if (seeker.image == null || seeker.image!.isEmpty) {
      return const Icon(Icons.person, size: 70, color: Colors.black);
    }
    return null;
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPdfSection(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[100]!, Colors.blue[200]!],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: (seeker.pdf ?? '').isNotEmpty
          ? Center(
              child: ElevatedButton.icon(
                onPressed: () => _openPdfPopup(context),
                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                label: const Text('View PDF',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, size: 60, color: Colors.blue[700]),
                const SizedBox(height: 10),
                Text(
                  'No PDF Available',
                  style: TextStyle(
                      color: Colors.blue[700], fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }

  Widget _buildContactOption(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.phone, color: Colors.green),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _makePhoneCall('tel:${seeker.number ?? ''}'),
              child: Text(
                seeker.number ?? 'No phone number',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.email, color: Colors.red),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => launch('mailto:${seeker.email ?? ''}'),
              child: Text(
                seeker.email ?? 'No email',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.message, color: Colors.green),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _openWhatsApp(seeker.number ?? ''),
              child: const Text(
                'WhatsApp',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
