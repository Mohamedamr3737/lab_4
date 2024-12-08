import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Get the current location of the device
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// Get addresses from provided coordinates
  Future<List<String>> getAddressesFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      // Convert placemarks into a list of readable address strings
      return placemarks.map((place) {
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch addresses: $e");
    }
  }
}
