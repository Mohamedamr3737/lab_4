import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLocationsScreen extends StatefulWidget {
  @override
  _SavedLocationsScreenState createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  List<String> _savedLocations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  Future<void> _loadSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedLocations = prefs.getStringList('saved_locations') ?? [];
    });
  }

  Future<void> _deleteLocation(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedLocations.removeAt(index);
    await prefs.setStringList('saved_locations', _savedLocations);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Locations"),
      ),
      body: _savedLocations.isEmpty
          ? Center(
        child: Text(
          "No saved locations.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _savedLocations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(_savedLocations[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteLocation(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
