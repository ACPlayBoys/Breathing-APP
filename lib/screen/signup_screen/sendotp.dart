// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:email_auth/email_auth.dart';

class SendOTP extends StatelessWidget {
  var selectedValue;
  PageController pageController;
  EmailAuth emailAuth;

  String cnfEmail = "";

  String curemail = "";
  SendOTP(this.pageController, this.emailAuth, {Key? key}) : super(key: key);
  final String path = "asset/images/signup/";

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              "Sign Up"
                  .text
                  .fontFamily("Poppins")
                  .bold
                  .size(25)
                  .fontWeight(FontWeight.w700)
                  .center
                  .make()
                  .centered()
                  .pOnly(top: y / 16, bottom: y / 32),
              Row(
                children: [
                  Image.asset(
                    path + "logo2.png",
                    fit: BoxFit.cover,
                    height: y / 3,
                  ).expand(),
                ],
              ).pOnly(bottom: y / 32),
              Container(
                height: y / 16,
                child: TextFormField(
                  onChanged: ((value) {
                    curemail = value;
                  }),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 20),
                    label: "Enter Your Email Id".text.make().px8(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(y / 20)),
                  ),
                ),
              ).pOnly(bottom: y / 32, left: x / 16, right: x / 16),
              Container(
                height: y / 16,
                child: TextField(
                  onChanged: ((value) {
                    cnfEmail = value;
                  }),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 20),
                    label: "Confirm Your Email ID".text.make().px8(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(y / 20)),
                  ),
                ),
              ).pOnly(bottom: y / 32, left: x / 16, right: x / 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: x / 2.5,
                        height: y / 16,
                        child: Image.asset(path + "otp.png"),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 101, 228),
                                width: 1),
                            gradient: RadialGradient(
                                radius: 4,
                                colors: [Color(0xff2C6AE4), Color(0xffC4C4C4)]),
                            borderRadius: BorderRadius.circular(y / 16)),
                      ).onInkTap(() {
                        if (cnfEmail != curemail) return;
                        if (!curemail.isValidEmail()) return;
                        email = curemail;
                        sendotp();
                      })
                    ],
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Divider(
                            color: Color.fromARGB(88, 0, 0, 0),
                            thickness: 1,
                          )),
                    ),
                    Text("OR"),
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(
                            color: Color.fromARGB(88, 0, 0, 0),
                            thickness: 1,
                          )),
                    ),
                  ]).pOnly(top: y / 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(path + "apple.png").p8(),
                      Image.asset(path + "google.png").p8(),
                      Image.asset(path + "fb.png").p8(),
                      Image.asset(path + "twitter.png").p8(),
                    ],
                  ).pOnly(bottom: y / 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Already a Member"
                          .text
                          .size(15)
                          .fontWeight(FontWeight.w300)
                          .make()
                          .pOnly(right: 8),
                      "Login Here"
                          .text
                          .size(15)
                          .fontWeight(FontWeight.w400)
                          .underline
                          .make()
                          .onInkTap(() {
                        Navigator.of(context).push(Routes.createLoginRoute());
                      })
                    ],
                  )
                ],
              )
            ],
          ).pOnly(bottom: y / 32),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  Future<void> sendotp() async {
    try {
      bool result = await emailAuth.sendOtp(recipientMail: email, otpLength: 4);
      pageController.animateToPage(pageController.page!.toInt() + 1,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
