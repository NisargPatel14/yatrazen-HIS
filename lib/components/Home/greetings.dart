import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  String getGreeting() {
  var hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning!';
  } else if (hour < 17) {
    return 'Good Afternoon!';
  } else {
    return 'Good Evening!';
  }
}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
           const SizedBox(
              height: 5,
            ),
            const Text(
              "Discover The India",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/auth');
          },
          customBorder: const CircleBorder(), // This will make the ink splash circular
          child: CircleAvatar(
            radius: 20,
            child: SvgPicture.asset(
              'assets/SVG/Profile_icon.svg',
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}
