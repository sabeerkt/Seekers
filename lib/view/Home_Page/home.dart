import 'package:flutter/material.dart';
import 'package:seeker/view/detailpage/detail.dart';
import 'package:seeker/view/Home_Page/widget/serch.dart';
import 'package:seeker/view/Home_Page/widget/button.dart';
import 'package:seeker/view/Home_Page/widget/createProfile.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  List<String> usernames = []; // List to store usernames
  List<String> subtitles = []; // List to store subtitles

  void navigateToNextPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProfile()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        usernames.add(result[
            'fullName']); // Assuming you pass 'fullName' from CreateProfile
        subtitles.add(result[
            'description']); // Assuming you pass 'description' from CreateProfile
      });
    }
  }

  void navigateToDetailPage(String username, String subtitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailPage(username: username, subtitle: subtitle),
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
          Expanded(
            child: ListView.builder(
              itemCount: usernames.length,
              itemBuilder: (context, index) {
                Color tileColor = index % 2 == 0
                    ? Colors.white
                    : const Color.fromARGB(255, 215, 205, 205);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tileColor,
                      child: Text(
                        usernames[index][0].toUpperCase(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 236, 65, 65),
                        ),
                      ),
                    ),
                    title: Text(
                      usernames[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(subtitles[index]),
                    tileColor: tileColor,
                    onTap: () => navigateToDetailPage(
                        usernames[index], subtitles[index]),
                  ),
                );
              },
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
