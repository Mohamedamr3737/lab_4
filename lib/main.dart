import 'package:flutter/material.dart';
import 'screens/location_picker_screen.dart';
import 'screens/saved_locations_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Picker App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LocationPickerScreen(),
        '/saved-locations': (context) => SavedLocationsScreen(),
      },
    );
  }
}
