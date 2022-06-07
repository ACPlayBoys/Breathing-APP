import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    checkUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Image.asset("asset/images/home/splash.png").centered()),
    );
  }

  void checkUser() async {
    var v = (FirebaseAuth.instance.currentUser);
    if (v != null) {
      await Future.delayed(Duration(seconds: 3));
      await Navigator.of(context).push(Routes.createHomeRoute());
    } else {
      await Future.delayed(Duration(seconds: 3));
      await Navigator.of(context).push(Routes.createSignUpRoute());
    }
  }
}
