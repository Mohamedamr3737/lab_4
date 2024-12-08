import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_4/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final LocationService _locationService = LocationService();
  String _statusMessage = "Enter coordinates to fetch addresses.";
  List<String> _addresses = [];
  String? _selectedAddress;

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> fetchAddressesFromInput() async {
    try {
      final latitude = double.tryParse(_latitudeController.text);
      final longitude = double.tryParse(_longitudeController.text);

      if (latitude == null || longitude == null) {
        setState(() {
          _statusMessage = "Please enter valid latitude and longitude.";
        });
        return;
      }

      setState(() {
        _statusMessage = "Fetching addresses...";
      });

      List<String> addresses =
      await _locationService.getAddressesFromCoordinates(latitude, longitude);

      // Remove duplicates
      addresses = addresses.toSet().toList();

      setState(() {
        _addresses = addresses;
        _statusMessage = _addresses.isNotEmpty
            ? "Select an address from the list below."
            : "No addresses found for the given coordinates.";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Error fetching addresses: $e";
      });
    }
  }

  Future<void> saveLocation() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an address to save.")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('saved_locations') ?? [];

    // Check for duplicates
    if (savedLocations.contains(_selectedAddress)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This address is already saved.")),
      );
      return;
    }

    savedLocations.add(_selectedAddress!);
    await prefs.setStringList('saved_locations', savedLocations);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Location saved successfully!")),
    );
  }

  void navigateToSavedLocations() {
    Navigator.pushNamed(context, '/saved-locations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Picker"),
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: navigateToSavedLocations,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _statusMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _latitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Latitude",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _longitudeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Longitude",
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: fetchAddressesFromInput,
              icon: Icon(Icons.search),
              label: Text("Fetch Addresses"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            if (_addresses.isNotEmpty)
              Column(
                children: [
                  Text(
                    "Available Addresses",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    child: ListView.builder(
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          title: Text(_addresses[index]),
                          value: _addresses[index],
                          groupValue: _selectedAddress,
                          onChanged: (value) {
                            setState(() {
                              _selectedAddress = value as String;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (_addresses.isNotEmpty)
              SizedBox(height: 20),
            if (_addresses.isNotEmpty)
              ElevatedButton.icon(
                onPressed: saveLocation,
                icon: Icon(Icons.save),
                label: Text("Save Address"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
