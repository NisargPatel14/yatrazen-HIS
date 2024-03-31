import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yatrazen/controllers/location_controller.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatefulWidget {
  const Emergency({super.key});

  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  ShakeDetector? detector;
  bool isShakeDetected = false;

  @override
  void initState() {
    super.initState();
    var locationController = Get.put(LocationController());
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      print("Shake detected");
      locationController?.getCurrentLocation();
      setState(() {
        isShakeDetected = true;
      });
    });
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      init: LocationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Emergency",
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
          body: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          controller.currentLocation == null
                              ? 'Location not found'
                              : controller.currentLocation!,
                          style: TextStyle(
                            fontSize: 23,
                            color: isShakeDetected ? Colors.red : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (emergencyContactNumbers.isNotEmpty)
                        ...emergencyContactNumbers.map((contactNumber) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: () => launch('tel:$contactNumber'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                              child: Text(
                                'Emergency Contact: $contactNumber',
                                 style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))
                              ),
                            ),
                          );
                        }),
                      if (emergencyContactNumbers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'No emergency contact numbers found for this location.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
