import 'package:flutter/material.dart';

class Lists extends StatefulWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    final List<Map<String, String>> dataList = [
      {
        'title': 'Item 1',
        'subtitle': 'Description for Item 1',
        'userName': 'John Doe', // Replace with actual user names
      },
      {
        'title': 'Item 2',
        'subtitle': 'Description for Item 2',
        'userName': 'Jane Smith', // Replace with actual user names
      },
      // Add more items as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('List Example'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            String userName = dataList[index]['userName'] ?? '';
            String firstLetter =
                userName.isNotEmpty ? userName[0].toUpperCase() : '';
            return ListTile(
              title: Text(dataList[index]['title'] ?? ''),
              subtitle: Text(dataList[index]['subtitle'] ?? ''),
              leading: CircleAvatar(
                child: Text(firstLetter, style: TextStyle(fontSize: 20)),
              ),
              onTap: () {
                // Handle tap on the list item
                print('Tapped on ${dataList[index]['title']}');
              },
            );
          },
        ),
      ),
    );
  }
}
