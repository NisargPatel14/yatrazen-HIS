import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yatrazen/controllers/location_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;
  double mapHeight = 0;
  bool isFullScreen = false;
  bool isLiveLocationOn = false;
  bool _isLoading = false;

  final LatLng _initialPosition = const LatLng(0, 0);

  final locationController = Get.find<LocationController>();

  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyA3wfl35CzCuXjk1wCkz64hZawNYyWjHDg');
  // Create a set of markers
  final Set<Marker> _markers = {};

  Timer? liveLocationTimer;

  @override
  bool get wantKeepAlive => true;

  Future<String> fetchCity(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks[0];
    if (place.administrativeArea != null) {
      return place.administrativeArea!;
    } else {
      return place.subAdministrativeArea!;
    }
  }

  var circleColor = Colors.white.withOpacity(0.5);

  Future<List<int>> fetchScore(String city) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.214.2:5000/senseScore/$city/?api_key=247da0f7b7f3bfcbea1b73a401cb426f'),
      // replace with your local IP address ( not the localhost )
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final scoresData = data['score'][0] as List<dynamic>;

      final positiveScore = scoresData[0]['score'] as double;
      final negativeScore = scoresData[1]['score'] as double;
      final neutralScore = scoresData[2]['score'] as double;

      int positiveScorePercentage = (positiveScore * 100).toInt();
      int negativeScorePercentage = (negativeScore * 100).toInt();
      int neutralScorePercentage = (neutralScore * 100).toInt();

      print('Positive: $positiveScorePercentage');
      print('Negative: $negativeScorePercentage');
      print('Neutral: $neutralScorePercentage');

      scores = [
        positiveScorePercentage,
        negativeScorePercentage,
        neutralScorePercentage
      ];

      // update the circle color based on the score
      if (positiveScore > negativeScore && positiveScore > neutralScore) {
        circleColor = Colors.green.withOpacity(0.5);
      } else if (negativeScore > positiveScore &&
          negativeScore > neutralScore) {
        circleColor = Colors.red.withOpacity(0.5);
      } else {
        circleColor = Colors.yellow.withOpacity(0.5);
      }
    } else {
      print('Failed to load score');
    }

    return scores;
  }

  void updateMarker() async {
    Position position = await locationController.getPosition();

    // Add a marker to the new position
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('current_position'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );
    });
  }

  var position2 = const LatLng(0, 0);
  void updateCameraPosition() async {
    Position position = await locationController.getPosition();
    position2 = LatLng(position.latitude, position.longitude);
    // Get the current zoom level
    double currentZoomLevel = await _mapController?.getZoomLevel() ?? 16.0;

    // Update the map to the new position
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: currentZoomLevel,
        ),
      ),
    );
  }

  void toggleLiveLocation() {
    if (isLiveLocationOn) {
      liveLocationTimer?.cancel();
    } else {
      liveLocationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        updateMarker();
      });
    }
    setState(() {
      isLiveLocationOn = !isLiveLocationOn;
    });
  }

  @override
  void dispose() {
    liveLocationTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mapHeight = MediaQuery.of(context).size.height / 2.5;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  List<int> scores = [0, 0, 0]; // Positive, Negative, Neutral scores
  @override
  Widget build(BuildContext context) {
    super.build(context); // Add this line
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Explore",
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
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease,
                  height: mapHeight,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 16.0,
                          ),
                          markers: _markers,
                          // plot a circle around the current location
                          circles: {
                            Circle(
                              circleId: const CircleId('current_position'),
                              center: LatLng(
                                  position2.latitude, position2.longitude),
                              radius: 200,
                              // make color dynamic based on the score
                              fillColor: circleColor,
                              strokeWidth: 0,
                            ),
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              toggleLiveLocation();
                              updateCameraPosition();
                            },
                            child: isLiveLocationOn
                                ? SvgPicture.asset(
                                    'assets/SVG/LiveOn.svg',
                                    height: 30,
                                  )
                                : SvgPicture.asset(
                                    'assets/SVG/LiveOff.svg',
                                    height: 30,
                                  ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  Prediction? p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey:
                                        'AIzaSyA3wfl35CzCuXjk1wCkz64hZawNYyWjHDg',
                                    mode: Mode.overlay, // Mode.fullscreen
                                    language: "en",
                                    components: [],
                                  );

                                  if (p != null) {
                                    print('Place selected: ${p.description}');
                                    // get detail (lat/lng)
                                    PlacesDetailsResponse detail = await places
                                        .getDetailsByPlaceId(p.placeId!);
                                    double lat =
                                        detail.result.geometry!.location.lat;
                                    double lng =
                                        detail.result.geometry!.location.lng;
                                    print('Place details: lat=$lat, lng=$lng');

                                    // update the map
                                    _mapController?.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: LatLng(lat, lng),
                                          zoom: 16.0,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print("Prediction is null");
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      children: [
                                        Icon(Icons.search),
                                        SizedBox(width: 8),
                                        Text("Search"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: MediaQuery.of(context).size.width / 2 - 25,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFullScreen = !isFullScreen;
                        mapHeight = isFullScreen
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.height / 2.5;
                      });
                    },
                    child: isFullScreen
                        ? SvgPicture.asset('assets/SVG/Pill_up.svg')
                        : SvgPicture.asset('assets/SVG/Pill_down.svg'),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/feedback');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8AE990),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    child: const Text(
                      'Go to Feedback',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            Position position =
                                await locationController.getPosition();
                            String city = await fetchCity(
                                position.latitude, position.longitude);
                            List<int> newScores = await fetchScore(city);
                            print('City: $city');
                            setState(() {
                              scores = newScores;
                            });
                            setState(() {
                              _isLoading = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8AE990),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    child:
                    _isLoading
                        ? const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator( color: Colors.white, strokeWidth: 2,)
                          )
                        :                    
                     const Text('Fetch Score',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
            // Create a rectungular bar consider it as 100% and divide it into 3 parts and fill the parts with the color based on the score percentage
            Container(
              // Add the same margin as the map container
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 4, 7, 28),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Yatrazen Score of current location:',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Container(
                        height: 10,
                        margin: const EdgeInsetsDirectional.only(
                            start: 20, end: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: const [
                              Colors.green,
                              Colors.yellow,
                              Colors.red
                            ],
                            stops: [
                              scores[0] /
                                  100, // Adjust the stop according to your score
                              (scores[0] + scores[1]) / 100,
                              1.0,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              const Text(
                                'Positive',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.green),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              const Text(
                                'Neutral',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.yellow),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red,
                                ),
                              ),
                              const Text(
                                'Negative',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
