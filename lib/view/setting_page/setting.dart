import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/auth_provider.dart';
import 'package:seeker/screens/Login_Page/login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 6.0,
        shadowColor: Colors.black.withOpacity(0.3),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<AuthProviders>(
            builder: (context, value, child) => IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                value.signOut().then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }).catchError((error) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $error')),
                  );
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Edit Profile",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.person),
              onTap: () {
                // Handle tapping this tile, navigate to edit profile page or show a dialog
              },
            ),
            Divider(), // Optional: Add a divider between list tiles
            ListTile(
              title: Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.privacy_tip),
              onTap: () {
                // Handle tapping this tile, navigate to privacy policy page or show details
              },
            ),
            Divider(), // Optional: Add a divider between list tiles
            ListTile(
              title: Text(
                "About",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.info),
              onTap: () {
                // Handle tapping this tile, navigate to about page or show details
              },
            ),
            // Add more ListTiles as needed
          ],
        ),
      ),
    );
  }
}
