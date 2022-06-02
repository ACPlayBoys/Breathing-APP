// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class Music extends StatelessWidget {
  const Music({Key? key}) : super(key: key);
  final String path = "asset/images/schedule/";
  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.back),
            Spacer(),
            "Set your Music".text.xl3.bold.make(),
            Spacer()
          ],
        ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
        Row(
          children: [
            Image.asset(
              path + "music.png",
              fit: BoxFit.cover,
            ).expand(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: x / 3,
              height: y / 16,
              child: "Use Default".text.lg.bold.makeCentered().px16(),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(y / 16)),
            ),
            Container(
              width: x / 3,
              height: y / 16,
              child: "Submit".text.lg.bold.makeCentered().px16(),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(y / 16)),
            ),
          ],
        ).px(x / 10).pOnly(top: y / 32, bottom: y / 45),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: ["Almost There".text.bold.lg.makeCentered()],
        ).pOnly(bottom: y / 64).expand()
      ],
    ));
  }
}
