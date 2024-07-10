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
          username: seeker.name ?? '', // Pass username here
          subtitle: seeker.secondname ?? '', // Pass subtitle here
          phoneNumber: seeker.number ?? '', // Replace with actual phone number from seeker model
          pdfUrl: seeker.pdf ?? '', 
          image: seeker.image ?? '',
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
                    List<SeekerModel> seekers = snapshot.data!.docs
                        .map((doc) => doc.data())
                        .toList();
                    return ListView.builder(
                      itemCount: seekers.length,
                      itemBuilder: (context, index) {
                        SeekerModel seeker = seekers[index];
                        return ListTile(
                          leading: seeker.image != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(seeker.image!),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          title: Text(seeker.name ?? ''),
                          subtitle: Text(seeker.secondname ?? ''),
                          onTap: () => navigateToDetailPage(seeker),
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
