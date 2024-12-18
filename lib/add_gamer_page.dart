import 'package:flutter/material.dart';
import 'package:playerinfo/view_gamer_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddGamerPage extends StatefulWidget {
  @override
  _AddGamerPageState createState() => _AddGamerPageState();
}

class _AddGamerPageState extends State<AddGamerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController gameController = TextEditingController();
  bool _isLoading = false;

  Future<void> addGamer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse the age safely
      final int age = int.tryParse(ageController.text.trim()) ?? 0;
      if (age <= 0) {
        throw FormatException('Age must be a positive number');
      }

      final response = await Supabase.instance.client
          .from('gamer_data')
          .insert({
        'gamer_name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'age': age,
        'game': gameController.text.trim(),
      })
          .execute();

      if (response.status != 201) {
        throw Exception(response ?? 'Failed to add gamer');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gamer added successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewGamerPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Gamer Info')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Gamer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: gameController,
                decoration: InputDecoration(labelText: 'Game'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a game';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: addGamer,
                child: Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewGamerPage()),
                ),
                child: Text('View Gamers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}