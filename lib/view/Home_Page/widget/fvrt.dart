import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/view/detailpage/detail.dart';

class FvrtPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SeekerProvider>(context);

    // Load favorites when the page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadFavorites();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.red[800],
      ),
      body: Consumer<SeekerProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;
          return favorites.isEmpty
              ? Center(
                  child: Text(
                    'No favorites added',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final seeker = favorites[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text(
                          seeker.name ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          seeker.secondname ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: seeker.image != null
                              ? FileImage(File(seeker.image!))
                              : null,
                          child: seeker.image == null
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.blue[800],
                                )
                              : null,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            provider.removeFavorite(seeker);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(seeker: seeker),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
