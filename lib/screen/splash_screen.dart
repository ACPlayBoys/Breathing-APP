import 'dart:convert';

import 'package:breathing_app/models/userdetails.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
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

    await Permission.storage.request();
    if (v != null) {
      await Future.delayed(Duration(seconds: 3));
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      users.doc(v.uid).get().then((DocumentSnapshot docSnapshot) async {
        if (docSnapshot.exists) {
          print(docSnapshot.data());
          var json = jsonEncode(docSnapshot.data()); // I am getting stuck here
          var details = UserDetails.fromJson(json) as UserDetails;
          await Future.delayed(Duration(milliseconds: 1000));
          if (DateTime.now().millisecondsSinceEpoch < details.endDate)
            await Navigator.of(context).push(Routes.createHomeRoute());
          else
            await Navigator.of(context).push(Routes.createSubscriptionRoute());
        }
      });
    } else {
      await Future.delayed(Duration(seconds: 3));
      await Navigator.of(context).push(Routes.createSignUpRoute());
    }
  }
}
