// ignore_for_file: prefer_const_constructors

import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class Reports extends StatelessWidget {
  final String path = "asset/images/shopping/";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var days = 22;
  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Material(
      child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Image.asset(path + "back.png").onInkTap(() {
              Navigator.of(context).pop();
            }),
            Spacer(),
            "Reports".text.xl3.bold.make(),
            Spacer(),
            Container()
          ],
        ).pOnly(top: y / 25, bottom: y / 32).px(x / 24),
        "Your Consistency Steak : "
            .text
            .bold
            .xl
            .makeCentered()
            .pOnly(bottom: y / 64),
        buildContainer(
                child: Container(
          height: y / 8,
          width: y / 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              days.text.xl3.bold.color(Colors.white).make(),
              "Days".text.xl2.bold.color(Colors.white).make(),
            ],
          ),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  radius: 1, colors: [Color(0xff2C6AE4), Color(0xffC4C4C4)]),
              borderRadius: BorderRadius.circular(y / 8)),
        ).p8())
            .centered()
            .pOnly(bottom: y / 64),
        "Activity Tracker"
            .text
            .bold
            .color(borderColor)
            .make()
            .px(x / 32)
            .pOnly(bottom: y / 64),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "You have taken a breathe for ".text.bold.make(),
                  Row(
                    children: [
                      "3 out of 5 Minutes ".text.bold.make(),
                      "today".text.bold.make(),
                    ],
                  ),
                ],
              ),
              buildContainer(
                  child: Container(
                      width: x / 8,
                      height: x / 8,
                      child: "71%".text.makeCentered().p8()))
            ],
          ).px(x / 32).py(y / 128),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(50)),
        ).px(x / 32).pOnly(bottom: y / 64),
        "Performance of last 7 days"
            .text
            .bold
            .color(borderColor)
            .make()
            .px(x / 32)
            .pOnly(bottom: y / 64),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: LinearPercentIndicator(
                width: 140.0,
                lineHeight: 14.0,
                percent: 0.5,
                barRadius: Radius.circular(120),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: borderColor.withOpacity(0.4),
                progressColor: borderColor,
              ),
            ),
          ],
        ).px(x / 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            "Sun".text.make(),
            "Mon".text.make(),
            "Tue".text.make(),
            "Wed".text.make(),
            "Thu".text.make(),
            "Fri".text.make(),
            "Sat".text.make(),
          ],
        ).px(x / 16).pOnly(bottom: y / 32),
        Container(
          width: x / 2.5,
          height: y / 16,
          child: "Earned Rewards".text.lg.bold.makeCentered().px16(),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(y / 16)),
        ).onInkTap(() {
          Navigator.of(context).push(Routes.createRewardRoute());
        }).centered(),
      ])),
    );
  }
}
