import 'package:breathing_app/screen/signup_screen/detail.dart';
import 'package:breathing_app/screen/signup_screen/otp_screen.dart';
import 'package:breathing_app/screen/signup_screen/sendotp.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:email_auth/email_auth.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  PageController _pageController = PageController();
  EmailAuth emailAuth = new EmailAuth(sessionName: "Breathing App");
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        previousPage();
        return false;
      },
      child: Scaffold(
          body: Column(children: <Widget>[
        PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            Details(_pageController),
            SendOTP(_pageController, emailAuth),
            OTPScreen(_pageController, emailAuth),
          ],
        ).expand(),
      ])),
    );
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);

    setState(() {});
  }

  void previousPage() {
    if (_pageController.page! > 0) {
      _pageController.animateToPage(_pageController.page!.toInt() - 1,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      setState(() {});
    }
  }
}
