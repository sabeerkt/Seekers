import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker/controller/auth_provider.dart';

import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:seeker/view/Home_Page/widget/createProfile.dart';
import 'package:seeker/view/Home_Page/widget/cursorslider.dart';
import 'package:seeker/view/detailpage/detail.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _userName = userData['name'] ?? 'User';
        });
      }
    }
  }

  void navigateToNextPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        // Handle any updates if necessary
      });
    }
  }

  void navigateToDetailPage(SeekerModel seeker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          username: seeker.name ?? '',
          subtitle: seeker.secondname ?? '',
          phoneNumber: seeker.number ?? '',
          pdfUrl: seeker.pdf ?? '',
          image: seeker.image ?? '',
          category: seeker.category ?? '',
          description: seeker.description ?? '',
        ),
      ),
    );
  }

  Future<void> launchCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone call')),
      );
    }
  }

  Future<void> launchWhatsApp(String phoneNumber, String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final Uri url =
        Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final currentUser = Provider.of<AuthProviders>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "wlecom",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 4.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              // Your code for the notifications button action
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Consumer<SeekerProvider>(
                builder: (context, notifier, child) => TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: TextStyle(fontSize: 16),
                  onChanged: (query) {
                    notifier.updateSearchQuery(query);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageSliderComponent(
              onImageTap: (imagePath, index) {
                String message = 'Let me know more about this ${index + 1}';
                launchWhatsApp('7510554555', message);
              },
            ),
          ),
          Expanded(
            child: Consumer<SeekerProvider>(
              builder: (context, value, child) =>
                  StreamBuilder<QuerySnapshot<SeekerModel>>(
                stream: value.getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Snapshot has error'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No seekers found'));
                  } else {
                    List<SeekerModel> seekers =
                        snapshot.data!.docs.map((doc) => doc.data()).toList();
                    return ListView.builder(
                      itemCount: seekers.length,
                      itemBuilder: (context, index) {
                        SeekerModel seeker = seekers[index];
                        return Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            onTap: () => navigateToDetailPage(seeker),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          child: seeker.image != null
                                              ? Image.file(
                                                  File(seeker.image!),
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  color: Colors.blue[100],
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              seeker.name ?? '',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              seeker.category ?? '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'Tap to view details',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.blue[300],
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            launchCall(seeker.number ?? ''),
                                        icon: Icon(Icons.call,
                                            color: Colors.white),
                                        label: Text('Call'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => launchWhatsApp(
                                            seeker.number ?? '',
                                            'Hello, I would like to know more about your services.'),
                                        icon: Icon(Icons.chat,
                                            color: Colors.white),
                                        label: Text('WhatsApp'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToNextPage,
        label: const Text('Create a Profile'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
