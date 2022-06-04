// ignore_for_file: prefer_const_constructors, unnecessary_new
import 'dart:convert';

import 'package:breathing_app/models/userdetails.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:email_auth/email_auth.dart';

class LoginOTPScreen extends StatefulWidget {
  String email;
  LoginOTPScreen(this.email, {Key? key}) : super(key: key);

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  var selectedValue;

  final String path = "asset/images/signup/";

  var emailAuth;

  @override
  initState() {
    super.initState();
    // TODO: implement initState

    emailAuth = new EmailAuth(sessionName: "Breathing App Login");
    sendotp();
  }

  sendotp() async {
    bool result =
        await emailAuth.sendOtp(recipientMail: widget.email, otpLength: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          children: [
            Image.asset(
              path + "logo3.png",
              fit: BoxFit.cover,
            ).expand(),
          ],
        ).pOnly(top: 64),
        "Enter OTP"
            .text
            .fontFamily("Poppins")
            .bold
            .size(25)
            .fontWeight(FontWeight.w700)
            .center
            .make()
            .centered()
            .pOnly(bottom: 32),
        buildPinPut(context)
      ]),
    );
  }

  Widget buildPinPut(BuildContext context) {
    double radius = 70;
    final defaultPinTheme = PinTheme(
      width: radius,
      height: radius,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(35, 0, 0, 0)),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      onCompleted: (pin) async {
        //bool shit =            emailAuth.validateOtp(recipientMail: widget.email, userOtp: pin);
        if (true) {
          try {
            final credential = FirebaseAuth.instance.currentUser;
            CollectionReference users =
                FirebaseFirestore.instance.collection('Users');
            users
                .doc(credential!.uid)
                .get()
                .then((DocumentSnapshot docSnapshot) {
              if (docSnapshot.exists) {
                print(docSnapshot.data());
                var json =
                    jsonEncode(docSnapshot.data()); // I am getting stuck here
                var details = UserDetails.fromJson(json) as UserDetails;
                print(details);
              } else {
                print('Data not present in Database..');
              }
            });
            Navigator.of(context).push(Routes.createHomeRoute());
            print(FirebaseAuth.instance.currentUser);
            Storage.getGif();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              showToast(context, 'No user found for that email.');
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              showToast(context, 'Wrong password provided for that user.');
              print('Wrong password provided for that user.');
            }
          }
        }
      },
    );
  }
}
