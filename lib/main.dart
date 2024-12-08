import 'package:flutter/material.dart';
import 'package:ns_apps/data_to_cloud/pageAddMakan.dart';
import 'package:ns_apps/screens/profil_screen.dart';
import 'package:ns_apps/screens/splash_screen.dart';
import 'package:ns_apps/screens/personalisasi_screen.dart';
import 'package:ns_apps/screens/home_page.dart';
import 'package:ns_apps/screens/login_screen.dart';
import 'package:ns_apps/screens/signup_screen.dart';
import 'package:ns_apps/screens/articles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Splashscreen(), // Initially display the splash screen
        routes: {
          '/personalization': (context) => PersonalisasiScreen(),
          '/home': (context) => HomePage(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/articles': (context) => ArticlesPage(),
          '/addMakan': (context) => PageAddMakan(),
          '/profil': (context) => ProfilScreen(),
        });
  }
}
