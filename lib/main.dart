import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatrazen/screens/Home/home.dart';
import 'package:yatrazen/screens/translate/translate.dart';
// import 'package:v4/screens/weather/weather.dart';
import 'package:yatrazen/screens/hospital/hospital.dart';
// import 'package:v4/screens/emergency/emergency.dart';
// import 'package:v4/screens/yatri/yatri.dart';
import 'package:yatrazen/screens/explore/explore.dart';
// import 'package:v4/screens/feedback/feedback.dart';
import 'package:yatrazen/screens/auth/auth.dart';
import 'package:yatrazen/controllers/location_controller.dart';
import 'package:yatrazen/screens/auth/api/auth_api.dart';
// import 'package:v4/screens/auth/pages/login_page.dart';
// import 'package:v4/screens/auth/pages/register_page.dart';
// import 'package:v4/screens/auth/pages/account_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: ((context) => AuthAPI()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());
    // location controller is not working properly
    final value = context.watch<AuthAPI>().status;
    print('TOP CHANGE Value changed to: $value!');

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
        // '/weather': (context) => const Weather(
        //       location: "Mehsana",
        //     ),
        '/hospital': (context) => const Hospital(),
        // '/emergency': (context) => const Emergency(),
        // '/yatri': (context) => const Yatri(),
        '/explore': (context) => const Explore(),
        // '/login': (context) => const LoginPage(),
        // '/feedback': (context) => const FeedbackForm(),
        // '/register': (context) => const RegisterPage(),
        // '/account': (context) => const AccountPage(),
      },
    );
  }
}
