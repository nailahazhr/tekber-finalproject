import 'package:flutter/material.dart';
import 'package:ns_apps/constants/colors.dart';
import '../model/onboarding_model.dart';
import '../screens/login_screen.dart';  // Import LoginScreen
import '../screens/signup_screen.dart';  // Import SignupScreen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = OnBoardingItems();
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhiteColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 100, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("NutriSmart", style: TextStyle(fontSize: 40, color: tPrimaryColor, fontFamily: "Nunito", fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          body(),
          buildDots(),
          SizedBox(height: 50),
          button(),
          Container(
            padding: EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Apakah sudah memiliki akun?", style: TextStyle(fontSize: 17, fontFamily: "Signika", color: tGreyColor),),
                Text(" "),
                GestureDetector(
                  onTap: () {
                    // Navigate to LoginScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text("Masuk", style: TextStyle(fontSize: 17, color: tSecondaryColor, fontFamily: "Signika", fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body(){
    return Expanded(
      child: Center(
        child: PageView.builder(
            onPageChanged: (value){
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: controller.items.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Images
                    Image.asset(controller.items[currentIndex].image),

                    const SizedBox(height: 15),
                    //Titles
                    Text(controller.items[currentIndex].title,
                      style: const TextStyle(fontSize: 25, color: tThirdColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),

                    //Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(controller.items[currentIndex].subtitle,
                        style: const TextStyle(color: tGreyColor, fontSize: 16), textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  //Dots
  Widget buildDots(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.items.length, (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration:   BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index? tSecondaryColor : tAccentColor2,
          ),
          height: 10,
          width: currentIndex == index? 30 : 10,
          duration: const Duration(milliseconds: 700))),
    );
  }

  //Button
  Widget button(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width *.9,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: tThirdColor
      ),
      child: TextButton(
        onPressed: () {
          if (currentIndex == controller.items.length - 1) {
            // Navigate to SignupScreen when "Mulai" button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),  // Replace with your actual SignupScreen
            );
          } else {
            setState(() {
              currentIndex++;
            });
          }
        },
        child: Text(currentIndex == controller.items.length - 1 ? "Mulai" : "Lanjut",
          style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Signika"),),
      ),
    );
  }
}
