import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:seeker/view/Home_Page/widget/serch.dart';
import 'package:seeker/view/detailpage/detail.dart';
import 'package:seeker/view/Home_Page/widget/createProfile.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
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
          subtitle: seeker.secondname ??
              '', // Assuming category can be used as subtitle
          phoneNumber: seeker.number ?? '',
          pdfUrl: seeker.pdf ?? '',
          image: seeker.image ?? '', category: seeker.category ?? '',
          description: seeker.description ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: NeumorphicSearchField(),
          ),
          Consumer<SeekerProvider>(
            builder: (context, value, child) => Expanded(
              child: StreamBuilder<QuerySnapshot<SeekerModel>>(
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
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  child: InkWell(
    onTap: () => navigateToDetailPage(seeker),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Hero(
            tag: 'seeker_image_${seeker.id}',
            child: Container(
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
              child: ClipOval(
                child: seeker.image != null
                    ? Image.asset(
                        seeker.image!,
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
          ),
          SizedBox(width: 16),
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
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
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
