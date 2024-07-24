import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:seeker/view/Network/widget/list.dart';
import 'package:seeker/view/Network/widget/tabbar.dart'; // Ensure this file contains the CustomTabbar widget
import 'package:seeker/view/detailpage/detail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class My_Network extends StatefulWidget {
  const My_Network({Key? key}) : super(key: key);

  @override
  State<My_Network> createState() => _My_NetworkState();
}

class _My_NetworkState extends State<My_Network> with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentCategory = 'Business';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentCategory =
            _tabController.index == 0 ? 'Business' : 'Profession';
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
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

  Future<void> launchWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  Widget buildSeekerList(Stream<QuerySnapshot<SeekerModel>> stream) {
    return StreamBuilder<QuerySnapshot<SeekerModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred'));
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
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                    color: Colors.grey.withOpacity(0.5),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => launchCall(seeker.number ?? ''),
                              icon: Icon(Icons.call, color: Colors.white),
                              label: Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  launchWhatsApp(seeker.number ?? ''),
                              icon: Icon(Icons.chat, color: Colors.white),
                              label: Text('WhatsApp'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemdbprovider = Provider.of<SeekerProvider>(context);
    itemdbprovider.getData();

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Network",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 8.0,
          shadowColor: Colors.black.withOpacity(0.3),
          automaticallyImplyLeading: false,
          bottom: CustomTabbar(controller: _tabController),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Consumer<SeekerProvider>(
              builder: (context, provider, _) => buildSeekerList(
                provider.getFilteredData('Business'),
              ),
            ),
            Consumer<SeekerProvider>(
              builder: (context, provider, _) => buildSeekerList(
                provider.getFilteredData('Profession'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
