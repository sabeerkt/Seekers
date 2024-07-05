import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package for call and WhatsApp functionalities

class DetailPage extends StatelessWidget {
  final String username;
  final String subtitle;

  const DetailPage({Key? key, required this.username, required this.subtitle})
      : super(key: key);

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
                  _makePhoneCall(
                      'tel:1234567890'); // Replace with actual number
                },
              ),
              SizedBox(height: 8), // Adding some space between options
              ListTile(
                leading: Icon(Icons.message, color: Colors.green),
                title: Text('WhatsApp'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openWhatsApp('1234567890'); // Replace with actual number
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
                      'assets/s22 shop.jpeg'), // Replace with the path to your image asset
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
                child: const Center(
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
                    children: const [
                      Icon(Icons.phone, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text(
                        '1234567890', // Replace with the actual number
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
