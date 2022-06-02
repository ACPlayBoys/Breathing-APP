// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class OnPage1 extends StatelessWidget {
  OnPage1( {Key? key}) : super(key: key);
  final String path = "asset/images/on_boarding/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Image.asset(path + "logo1.png").centered().pOnly(top: 128),
          "Let's Begin to breathe".text.xl2.bold.make().py24(),
              ],
      ),
    ));
  }

}
