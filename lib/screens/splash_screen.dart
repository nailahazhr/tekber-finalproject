import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ns_apps/constants/colors.dart';
import 'package:ns_apps/constants/images.dart';
import 'package:ns_apps/screens/onboarding_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 2), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingScreen(),
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: tPrimaryColor,
        ),
        child: Column(
          children: [
            const Spacer(), // Pushes the logo to the center vertically
            Image.asset(tLogoSplash), // Centered logo
            const Spacer(), // Pushes "2024" to the bottom
            const Padding(
              padding: EdgeInsets.only(bottom: 30), // Adds 30 pixels from the bottom
              child: Text(
                "2024",
                style: TextStyle(
                  color: tWhiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
