// import 'package:flutter/material.dart';
// import 'package:ns_apps/constants/colors.dart';
// import '../model/onboarding_model.dart';
// import '../screens/login_screen.dart';  
// import '../screens/signup_screen.dart'; 

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final controller = OnBoardingItems();
//   final pageController = PageController();
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tWhiteColor,
//       body: Column(
//         children: [
//           // Heading Section
//           Container(
//             padding: EdgeInsets.only(top: 100, bottom: 50),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "NutriSmart",
//                   style: TextStyle(
//                     fontSize: 40,
//                     color: tPrimaryColor,
//                     fontFamily: "Nunito",
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Body of the onboarding screen
//           body(),
          
//           // Dots Indicator for pages
//           buildDots(),
          
//           SizedBox(height: 50),
          
//           // Action Button
//           button(),
          
//           // Sign In Section
//           Container(
//             padding: EdgeInsets.only(bottom: 80),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Apakah sudah memiliki akun?",
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontFamily: "Signika",
//                     color: tGreyColor,
//                   ),
//                 ),
//                 Text(" "),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginScreen()),
//                     );
//                   },
//                   child: Text(
//                     "Masuk",
//                     style: TextStyle(
//                       fontSize: 17,
//                       color: tSecondaryColor,
//                       fontFamily: "Signika",
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Main body that displays the onboarding content
//   Widget body() {
//     return Expanded(
//       child: PageView.builder(
//         controller: pageController,
//         onPageChanged: (value) {
//           setState(() {
//             currentIndex = value;
//           });
//         },
//         itemCount: controller.items.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Image for each onboarding page
//                 Image.asset(controller.items[index].image),
//                 const SizedBox(height: 15),
//                 // Title of the page
//                 Text(
//                   controller.items[index].title,
//                   style: const TextStyle(
//                     fontSize: 25,
//                     color: tThirdColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 // Subtitle/Description
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Text(
//                     controller.items[index].subtitle,
//                     style: const TextStyle(
//                       color: tGreyColor,
//                       fontSize: 16,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Dots indicator to show current page
//   Widget buildDots() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(controller.items.length, (index) {
//         return AnimatedContainer(
//           margin: const EdgeInsets.symmetric(horizontal: 2),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: currentIndex == index ? tSecondaryColor : tAccentColor2,
//           ),
//           height: 10,
//           width: currentIndex == index ? 30 : 10,
//           duration: const Duration(milliseconds: 700),
//         );
//       }),
//     );
//   }

//   // Button for navigation (either Lanjut or Mulai)
//   Widget button() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 20),
//       width: MediaQuery.of(context).size.width * .9,
//       height: 55,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: tThirdColor,
//       ),
//       child: TextButton(
//         onPressed: () {
//           if (currentIndex == controller.items.length - 1) {
//             // Navigate to SignupScreen when "Mulai" button is pressed
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SignUpScreen()),
//             );
//           } else {
//             setState(() {
//               currentIndex++;
//               pageController.jumpToPage(currentIndex);  // Directly jump to next page
//             });
//           }
//         },
//         child: Text(
//           currentIndex == controller.items.length - 1 ? "Mulai" : "Lanjut",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontFamily: "Signika",
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ns_apps/constants/colors.dart';
import '../model/onboarding_model.dart';
import '../screens/login_screen.dart';  
import '../screens/signup_screen.dart'; 

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
      body: SingleChildScrollView(   // Use SingleChildScrollView to avoid overflow
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 30),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NutriSmart",
                    style: TextStyle(
                      fontSize: 40,
                      color: tPrimaryColor,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Onboarding Pages Section
            body(),

            // Dots Indicator for pages
            buildDots(),

            const SizedBox(height: 30),

            // Action Button Section
            button(),

            // Footer Section with Login Prompt
            Container(
              padding: const EdgeInsets.only(bottom: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Apakah sudah memiliki akun?",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Signika",
                      color: tGreyColor,
                    ),
                  ),
                  const Text(" "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 17,
                        color: tSecondaryColor,
                        fontFamily: "Signika",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Body for Onboarding content
  Widget body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // Limit the height of this section
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image for each onboarding page
                Image.asset(controller.items[index].image),

                const SizedBox(height: 15),

                // Title for the page
                Text(
                  controller.items[index].title,
                  style: const TextStyle(
                    fontSize: 25,
                    color: tThirdColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Subtitle/Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    controller.items[index].subtitle,
                    style: const TextStyle(
                      color: tGreyColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Dots Indicator to show current page
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.items.length, (index) {
        return AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index ? tSecondaryColor : tAccentColor2,
          ),
          height: 10,
          width: currentIndex == index ? 30 : 10,
          duration: const Duration(milliseconds: 700),
        );
      }),
    );
  }

  // Button for navigation (either Lanjut or Mulai)
  Widget button() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: tThirdColor,
      ),
      child: TextButton(
        onPressed: () {
          if (currentIndex == controller.items.length - 1) {
            // Navigate to SignupScreen when "Mulai" button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          } else {
            setState(() {
              currentIndex++;
              pageController.jumpToPage(currentIndex);  // Jump to next page
            });
          }
        },
        child: Text(
          currentIndex == controller.items.length - 1 ? "Daftar" : "Lanjut",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "Signika",
          ),
        ),
      ),
    );
  }
}
