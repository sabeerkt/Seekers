import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker/controller/seeker_provider.dart';
import 'package:seeker/view/detailpage/detail.dart';

class FvrtPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SeekerProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text('No favorites added'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final seeker = favorites[index];
                return ListTile(
                  title: Text(seeker.name ?? ''),
                  subtitle: Text(seeker.secondname ?? ''),
                  leading: CircleAvatar(
                    backgroundImage: seeker.image != null
                        ? NetworkImage(seeker.image!)
                        : null,
                    child: seeker.image == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(seeker: seeker),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
