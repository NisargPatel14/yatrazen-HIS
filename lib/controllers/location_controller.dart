import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

List<String> emergencyContactNumbers = ["100","108"]; // Global variable to store emergency contact numbers

class LocationController extends GetxController {
  Position? currentPosition;
  var isLoading = false.obs;

  String? currentLocation;

  Future<Position> getPosition() async {
    LocationPermission? permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAdressFromLatLng(double lat, double long) async {
    try {
      print('Getting address from lat, long: $lat, $long');
      const apiKey =
          'AIzaSyA3wfl35CzCuXjk1wCkz64hZawNYyWjHDg'; // Replace with your Google Maps API key
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final addressComponents =
              results[0]['address_components'] as List<dynamic>;
          final formattedAddress = addressComponents
              .map((component) => component['long_name'])
              .join(', ');
          currentLocation = formattedAddress;
          update();
        }
      } else {
        print('Failed to get address. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading(true);
      update();
      currentPosition = await getPosition();
      await getAdressFromLatLng(
          currentPosition!.latitude, currentPosition!.longitude);

      // Fetch emergency contact number based on the city
      const apiKey = 'AIzaSyA3wfl35CzCuXjk1wCkz64hZawNYyWjHDg';
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentPosition!.latitude},${currentPosition!.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          final addressComponents =
              results[0]['address_components'] as List<dynamic>;
          final city = addressComponents[3]['long_name'];
          print(city);
          final emergencyContactUrl =
              'https://pols-aagyi-pols.vercel.app/contact/$city';
          final emergencyContactResponse =
              await http.get(Uri.parse(emergencyContactUrl));
          if (emergencyContactResponse.statusCode == 200) {
            final emergencyContactData =
                jsonDecode(emergencyContactResponse.body);
            final contactNumberPrimary =
                emergencyContactData['Contact Number ( pri )'];
            final contactNumberSecondary =
                emergencyContactData['Contact Number ( sec )'];
            final contactNumberTertiary =
                emergencyContactData['Contact Number ( tri )'];
            print('Primary Contact: $contactNumberPrimary');
            print('Secondary Contact: $contactNumberSecondary');
            print('Tertiary Contact: $contactNumberTertiary');
            emergencyContactNumbers = [
              contactNumberPrimary,
              contactNumberSecondary,
              contactNumberTertiary
            ];
            isLoading(false);
            update();
          } else {
            print(
                'Failed to fetch emergency contact number. Status code: ${emergencyContactResponse.statusCode}');
          }
        }
      } else {
        print('Failed to get address. Status code: ${response.statusCode}');
      }

      isLoading(false);
      update();
    } catch (e) {
      print(e);
    }
  }
}
