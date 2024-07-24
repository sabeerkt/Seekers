import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DetailPage extends StatelessWidget {
  final String username;
  final String subtitle;
  final String phoneNumber;
  final String pdfUrl;
  final String image;
  final String category;
  final String description;

  const DetailPage({
    Key? key,
    required this.username,
    required this.subtitle,
    required this.phoneNumber,
    required this.pdfUrl,
    required this.image,
    required this.category,
    required this.description,
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
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PDF Viewer',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PDFView(filePath: pdfUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _downloadFile(context, pdfUrl, 'document.pdf'),
                    icon: Icon(Icons.download),
                    label: Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(username),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
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
                      username,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Contact Options:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildContactOption(context),
                  SizedBox(height: 20),
                  _buildInfoSection('Subtitle', subtitle),
                  _buildInfoSection('Description', description),
                  _buildInfoSection('Category', category),
                  SizedBox(height: 20),
                  Text(
                    'Uploaded Document:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildPdfSection(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (image.startsWith('http') || image.startsWith('https')) {
      return NetworkImage(image);
    } else if (image.isNotEmpty) {
      return FileImage(File(image));
    } else {
      return AssetImage('assets/default_profile.png');
    }
  }

  Widget? _getImageErrorWidget() {
    if (image.isEmpty) {
      return Icon(Icons.person, size: 70, color: Colors.black);
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
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 15),
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
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: pdfUrl.isNotEmpty
          ? Center(
              child: ElevatedButton.icon(
                onPressed: () => _openPdfPopup(context),
                icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                label: Text('View PDF',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, size: 60, color: Colors.blue[700]),
                SizedBox(height: 10),
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
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall('tel:$phoneNumber'),
            icon: Icon(Icons.call, color: Colors.white),
            label: Text('Call', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _openWhatsApp(phoneNumber),
            icon: Icon(Icons.message, color: Colors.white),
            label: Text('WhatsApp', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}
