// ignore_for_file: prefer_const_constructors, unnecessary_new, dead_code_on_catch_subtype

import 'dart:convert';
import 'dart:io';
import 'package:breathing_app/util/Storage.dart';
import 'package:intl/intl.dart';
import 'package:breathing_app/models/userdetails.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPScreen extends StatefulWidget {
  EmailAuth emailAuth;

  OTPScreen(PageController pageController, this.emailAuth, {Key? key})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var selectedValue;

  var _first = false;

  final String path = "asset/images/signup/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Image.asset(
                path + "logo3.png",
                fit: BoxFit.cover,
              ).expand(),
            ],
          ).pOnly(top: 64),
          AnimatedContainer(
                  color: Colors.white60,
                  duration: Duration(seconds: 1),
                  width: chngBtn2 == 0 ? 50 : 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: buildButton1())
              .pOnly(bottom: 32),
          buildPinPut(context).px4(),
        ]),
      ),
    );
  }

  int chngBtn2 = 55;
  Container buildButton1() {
    if (chngBtn2 == 1) {
      return Container(child: CircularProgressIndicator());
    } else if (chngBtn2 == 2) {
      return Container(
        child: Icon(
          Icons.done,
        ),
      );
    } else {
      return Container(
          child: "Enter OTP"
              .text
              .fontFamily("Poppins")
              .bold
              .size(25)
              .fontWeight(FontWeight.w700)
              .center
              .make()
              .centered());
    }
  }

  Widget buildPinPut(BuildContext context) {
    double radius = 60;
    final defaultPinTheme = PinTheme(
      width: radius,
      height: radius,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(35, 0, 0, 0)),
        borderRadius: BorderRadius.circular(100),
      ),
    );
    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      onCompleted: (pin) async {
        // bool shit =
        //     widget.emailAuth.validateOtp(recipientMail: email, userOtp: pin);
        print(email);

        if (true) {
          try {
            setState(() {
              chngBtn2 = 1;
            });
            final credential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: email,
            );
            CollectionReference users =
                FirebaseFirestore.instance.collection('Users');
            var mail = credential.user!.email;
            UserDetails dr = UserDetails(
                name: userDetails["name"],
                age: userDetails["age"],
                gender: userDetails["gender"],
                country: userDetails["country"],
                uid: credential.user!.uid,
                time: DateTime.now().toIso8601String(),
                email: email,
                adminSubscription: false,
                audioType: '',
                block: false,
                buyDate: 0,
                buyMonth: '',
                endDate: 0,
                expMonth: '',
                rewards: false,
                subMonths: 0,
                subscription: false);
            users.doc(credential.user!.uid).set(dr.toMap());

            credential.user!.updateDisplayName(userDetails["name"]);
            credential.user!.updatePhotoURL(
                "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/profile.png?alt=media&token=b631601b-b247-493b-a228-55d2c4b8ac3a");
            FirebaseFirestore.instance
                .collection('report')
                .doc(credential.user!.uid)
                .set({
              'previousBreatheDate': DateFormat.yMd().format(DateTime.now()),
              'streak': 0,
              'todayTotal': 0,
              'totalTime': 300
            });
            Storage.setDeafultGif(context);
            FirebaseFirestore.instance
                .collection('Users')
                .doc(credential.user!.uid)
                .set({'audioType': 'default'}, SetOptions(merge: true));
            //showToast(context, 'Default Audio Selected');
            _first = true;
            setState(() {
              chngBtn2 = 2;
            });

            await Future.delayed(Duration(seconds: 2));
            await Navigator.of(context).push(Routes.createLoginRoute());
          } on FirebaseAuthException catch (e) {
            setState(() {
              chngBtn2 = 55;
            });
            if (e.code == 'weak-password') {
              showToast(context, 'The password provided is too weak.');
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              showToast(context,
                  'The account already exists for that email. Please Login');
              print('The account already exists for that email.');
            }
          } on FirebaseAuthException catch (e) {
            setState(() {
              chngBtn2 = 55;
            });
            if (e.code == 'user-not-found') {
              showToast(context, 'No user found for that email.');
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              showToast(context, 'Wrong password provided for that user.');
              // ignore: avoid_print
              print('Wrong password provided for that user.');
            }
          }
        } else
          showToast(context, "Wrong Otp");
      },
    );
  }
}
