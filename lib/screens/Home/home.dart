import 'package:flutter/material.dart';
import 'package:yatrazen/components/Home/cards.dart';
import 'package:yatrazen/components/Home/greetings.dart';
import 'package:yatrazen/components/Home/news.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff0e1219),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Greeting(),
            SizedBox(height: 20),
            Cards(),
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: News(),
            ),
          ],
        ),
      )),
    );
  }
}
