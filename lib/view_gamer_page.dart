import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewGamerPage extends StatefulWidget {
  @override
  _ViewGamerPageState createState() => _ViewGamerPageState();
}

class _ViewGamerPageState extends State<ViewGamerPage> {
  // Fetch gamers from Supabase
  Future<List<Map<String, dynamic>>> fetchGamers() async {
    final response = await Supabase.instance.client
        .from('gamer_data')
        .select()
        .execute();

    if (response.status != 200) {
      throw Exception(response ?? 'Failed to fetch gamers');
    }

    final data = response.data as List<dynamic>;
    return data.map((gamer) => gamer as Map<String, dynamic>).toList();
  }

  // Delete a gamer from Supabase
  Future<void> deleteGamer(String id) async {
    final response = await Supabase.instance.client
        .from('gamer_data')
        .delete()
        .eq('id', id)
        .execute();

    if (response.status != 200) {
      throw Exception(response ?? 'Failed to delete gamer');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gamer deleted successfully')),
    );

    // Refresh the list after deletion
    setState(() {});
  }

  // Show dialog to edit gamer info
  Future<void> editGamer(BuildContext context, Map<String, dynamic> gamer) async {
    final nameController = TextEditingController(text: gamer['gamer_name']);
    final usernameController = TextEditingController(text: gamer['username']);
    final ageController = TextEditingController(text: gamer['age'].toString());
    final gameController = TextEditingController(text: gamer['game']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Gamer Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Gamer Name'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: gameController,
                decoration: InputDecoration(labelText: 'Game'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedGamer = {
                  'gamer_name': nameController.text.trim(),
                  'username': usernameController.text.trim(),
                  'age': int.tryParse(ageController.text) ?? gamer['age'],
                  'game': gameController.text.trim(),
                };

                final response = await Supabase.instance.client
                    .from('gamer_data')
                    .update(updatedGamer)
                    .eq('id', gamer['id'])
                    .execute();

                if (response.status != 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update gamer')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gamer updated successfully')),
                  );

                  setState(() {}); // Refresh the list
                }

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Gamer Data'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchGamers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final gamer = snapshot.data![index];
                return Card(
                  color: Colors.blue.shade50,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    title: Text(
                      gamer['gamer_name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${gamer['username']} (${gamer['age']} years old, plays ${gamer['game']})',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () => editGamer(context, gamer),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await deleteGamer(gamer['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
