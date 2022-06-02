// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class OnPage4 extends StatelessWidget {
  const OnPage4({Key? key}) : super(key: key);
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
                path + "logo4.png",
                fit: BoxFit.cover,
              ).expand(),
            ],
          ).pOnly(top: 128),
          "Focus your breathe in your heart"
              .text
              .fontFamily("Poppins")
              .bold
              .size(25)
              .fontWeight(FontWeight.w700)
              .center
              .make()
              .px16()
              .pOnly(top: 32),
        ],
      ),
    ));
  }
}
