// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class OnPage2 extends StatelessWidget {
  const OnPage2({Key? key}) : super(key: key);
  final String path = "asset/images/on_boarding/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                path + "logo2.png",
                fit: BoxFit.cover,
              ).expand(),
            ],
          ).pOnly(top: 128),
          "Reduce Stress & Anxiety with every breathe"
              .text
              .fontFamily("Poppins")
              .bold
              .size(25)
              .fontWeight(FontWeight.w700)
              .center
              .make()
              .px16()
              .pOnly(bottom: 64),
           ],
      ),
    ));
  }
}
