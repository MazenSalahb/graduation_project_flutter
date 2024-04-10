import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/primary_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the app!',
              style: TextStyle(fontSize: 26),
            ),
            SvgPicture.asset(
              'assets/svg/book_start.svg',
              height: 250,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                "Explore the books around you",
                style: TextStyle(fontSize: 26),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              'Explore the world of reading. Find your perfect books from a huge collection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            PrimaryButton(
              text: 'Get Started',
              onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
            ),
          ],
        ),
      ),
    );
  }
}
