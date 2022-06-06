import 'package:breathing_app/dummy.dart';
import 'package:breathing_app/screen/Shopping/shopping.dart';
import 'package:breathing_app/screen/Shopping/wishlist.dart';
import 'package:breathing_app/screen/home_screen/home_screen.dart';
import 'package:breathing_app/screen/login_screen/login.dart';
import 'package:breathing_app/screen/onboarding_screens/onboarding.dart';
import 'package:breathing_app/screen/scheduling_screen/schedule.dart';
import 'package:breathing_app/screen/signup_screen/signup_screen.dart';
import 'package:breathing_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context)
                .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          ),
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen());
  }
}
