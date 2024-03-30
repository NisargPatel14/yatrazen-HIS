import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:v4/controllers/location_controller.dart';

class Hospital extends StatefulWidget {
  const Hospital({super.key});

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital>
    with AutomaticKeepAliveClientMixin {
  LatLng _initialPosition = const LatLng(0, 0);
  List<dynamic> _nearbyHospitals = [];

  // final locationController = Get.find<LocationController>();

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
   // fetch nearby hospitals using Google Places API
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
      body: SingleChildScrollView(
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
                final distance = hospital['geometry']['location']['lat'];
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
                    subtitle: Text('Distance: $distance meters'),
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