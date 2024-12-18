import 'package:flutter/material.dart';
import 'add_gamer_page.dart';
import 'view_gamer_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddGamerPage())),
              child: Text('Add Gamer Info'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewGamerPage())),
              child: Text('View Gamer Data'),
            ),
          ],
        ),
      ),
    );
  }
}
