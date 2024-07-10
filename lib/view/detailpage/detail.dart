import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For call and WhatsApp functionalities
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF viewing
import 'package:permission_handler/permission_handler.dart'; // For permissions
import 'package:dio/dio.dart'; // For downloading files
import 'package:path_provider/path_provider.dart'; // For accessing device storage

class DetailPage extends StatelessWidget {
  final String username;
  final String subtitle;
  final String phoneNumber;
  final String pdfUrl;
  final String image;

  const DetailPage({
    Key? key,
    required this.username,
    required this.subtitle,
    required this.phoneNumber,
    required this.pdfUrl,
      required this.image,
  }) : super(key: key);

  void _showNumberOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.call, color: Colors.blueAccent),
                title: Text('Call'),
                onTap: () {
                  Navigator.of(context).pop();
                  _makePhoneCall('tel:$phoneNumber');
                },
              ),
              SizedBox(height: 8), // Adding some space between options
              ListTile(
                leading: Icon(Icons.message, color: Colors.green),
                title: Text('WhatsApp'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openWhatsApp(phoneNumber);
                },
              ),
            ],
          ),
        );
      },
    );
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PDFView(
                    filePath: pdfUrl,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close PDF'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _downloadFile(context, pdfUrl, 'document.pdf');
                      },
                      child: Text('Download PDF'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadFile(BuildContext context, String url, String fileName) async {
    // Check if permission is granted
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var dir = await getExternalStorageDirectory();
      String savePath = "${dir!.path}/$fileName";
      Dio dio = Dio();

      try {
        await dio.download(url, savePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to $savePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      image
                      
                      ), // Replace with the path to your image asset
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  username,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              const Text(
                'Uploaded Document:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              const SizedBox(height: 5),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: pdfUrl.isNotEmpty
                    ? Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _openPdfPopup(context); // Open PDF in a popup
                          },
                          icon: Icon(Icons.insert_drive_file),
                          label: Text('Open PDF'),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.insert_drive_file,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Options:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showNumberOptionsDialog(context),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        phoneNumber,
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
