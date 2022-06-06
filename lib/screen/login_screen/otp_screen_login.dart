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
  EmailAuth emailAuth;
  String userEmail;
  LoginOTPScreen(this.emailAuth, this.userEmail, {Key? key}) : super(key: key);

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  var selectedValue;

  final String path = "asset/images/signup/";

  int chngBtn2 = 55;

  @override
  initState() {
    super.initState();
    // TODO: implement initState
  }

  sendotp() async {
    bool result = await widget.emailAuth
        .sendOtp(recipientMail: widget.userEmail, otpLength: 4);
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
        AnimatedContainer(
                color: Colors.white60,
                duration: Duration(seconds: 1),
                width: chngBtn2 == 0 ? 50 : 100,
                height: 50,
                alignment: Alignment.center,
                child: buildButton1())
            .pOnly(bottom: 32),
        buildPinPut(context),
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
        print(email);
        bool shit = widget.emailAuth
            .validateOtp(recipientMail: widget.userEmail, userOtp: pin);
        if (shit) {
          try {
            chngBtn2 = 0;
            setState(() {});
            await Future.delayed(Duration(milliseconds: 5000));
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
            chngBtn2 = 2;
            setState(() {});
            await Future.delayed(Duration(milliseconds: 2000));
            await Navigator.of(context).push(Routes.createSchedulingRoute());
            print(FirebaseAuth.instance.currentUser);
          } on FirebaseAuthException catch (e) {
            setState(() {
              chngBtn2 = 55;
            });
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

  Container buildButton1() {
    if (chngBtn2 == 0) {
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
}
