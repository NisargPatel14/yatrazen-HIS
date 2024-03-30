import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yatrazen/controllers/location_controller.dart';
import 'package:get/get.dart';

class Hospital extends StatefulWidget {
  const Hospital({super.key});

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital>
    with AutomaticKeepAliveClientMixin {

  LatLng _initialPosition = const LatLng(0, 0);
  List<dynamic> _nearbyHospitals = [];

  final locationController = Get.find<LocationController>();
  bool _isLoading = true;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    locationController.getPosition().then((Position position) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _fetchNearbyHospitals();
      });
    });
  }

  Future<void> _fetchNearbyHospitals() async {
    const apiKey =
        'AIzaSyA3wfl35CzCuXjk1wCkz64hZawNYyWjHDg'; // Replace with your Google Places API key
    const radius = 15000;
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=hospital&location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=$radius&type=hospitals&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _nearbyHospitals = data['results'].map((hospital) {
          final lat = hospital['geometry']['location']['lat'];
          final lng = hospital['geometry']['location']['lng'];
          final distanceInMeters = Geolocator.distanceBetween(
            _initialPosition.latitude,
            _initialPosition.longitude,
            lat,
            lng,
          );
          return {...hospital, 'distance': distanceInMeters};
        }).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch nearby hospitals');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hospital",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: const Color(0xff0E1219),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator( color: Color(0xffffffff)))
          : SingleChildScrollView(
              child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _nearbyHospitals.length,
              itemBuilder: (context, index) {
                final hospital = _nearbyHospitals[index];
                final name = hospital['name'];
                final photoReference =
                    hospital['photos'] != null && hospital['photos'].isNotEmpty
                        ? hospital['photos'][0]['photo_reference']
                        : null;
                final distance = hospital['distance'];
                final isOpen = hospital['opening_hours'] != null &&
                    hospital['opening_hours']['open_now'] == true;

                return Card(
                  child: ListTile(
                    leading: photoReference != null
                        ? Image.network(
                            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=AIzaSyA3wfl35CzCuXjk1wCkz64hZawNYyWjHDg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/SVG/hospital_place.jpg', // Path to the placeholder image
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                    title: Text(name),
                    subtitle: Text('Distance: ${distance.round()} meters'),
                    trailing:
                        isOpen ? const Text('Open') : const Text('Closed'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}