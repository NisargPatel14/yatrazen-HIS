import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatrazen/screens/Home/home.dart';
import 'package:yatrazen/screens/translate/translate.dart';
import 'package:yatrazen/screens/weather/weather.dart';
import 'package:yatrazen/screens/hospital/hospital.dart';
import 'package:yatrazen/screens/emergency/emergency.dart';
import 'package:yatrazen/screens/Yatri/yatri.dart';
import 'package:yatrazen/screens/explore/explore.dart';
import 'package:yatrazen/screens/feedback/feedback.dart';
import 'package:yatrazen/screens/auth/auth.dart';
import 'package:yatrazen/controllers/location_controller.dart';
import 'package:yatrazen/screens/auth/api/auth_api.dart';
import 'package:yatrazen/screens/auth/pages/login_page.dart';
import 'package:yatrazen/screens/auth/pages/register_page.dart';
import 'package:yatrazen/screens/auth/pages/account_page.dart';

void main() {
  Get.put(LocationController()); // Initialize LocationController here
  runApp(
    ChangeNotifierProvider(
      create: ((context) => AuthAPI()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Get.find<LocationController>().getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (controller) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xff0E1219),
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ).copyWith(
                bodySmall: GoogleFonts.syne(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
                displayMedium: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.displayMedium,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
                displaySmall: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.displaySmall,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white,
                )),
          ),
          debugShowCheckedModeBanner: false,
          title: 'v4',
          initialRoute: "/",
          routes: {
            '/loading': (context) => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
            '/': (context) => const Home(),
            '/auth': (context) => const Auth(),
            '/translate': (context) => const Translate(),
            '/weather': (context) => Weather(
                  location: controller.currentLocation ?? "Mumbai",
                ),
            '/hospital': (context) => const Hospital(),
            '/emergency': (context) => const Emergency(),
            '/yatri': (context) => const Yatri(),
            '/explore': (context) => const Explore(),
            '/login': (context) => const LoginPage(),
            '/feedback': (context) => const FeedbackForm(),
            '/register': (context) => const RegisterPage(),
            '/account': (context) => const AccountPage(),
          },
        );
      },
    );
  }
}
