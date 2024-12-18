import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ndlgmrluvfzsalnztaxp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kbGdtcmx1dmZ6c2Fsbnp0YXhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM1ODA3MTksImV4cCI6MjA0OTE1NjcxOX0.Q5JnzHWzimEmTHOXVUIftA42_T_rgh7l56radSfbwKc',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamer CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}