// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class Breathe extends StatelessWidget {
  var selectedValue;

  Breathe({Key? key}) : super(key: key);
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
            "Set your Breathing Rate".text.xl3.bold.make(),
            Spacer()
          ],
        ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
        Row(
          children: [
            Image.asset(
              path + "breathe.png",
              fit: BoxFit.cover,
            ).expand(),
          ],
        ),
        "Breathing Rate"
            .text
            .xl2
            .bold
            .make()
            .pOnly(top: y / 35, bottom: y / 300, left: x / 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: y / 18,
              width: x / 3,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffC4C4C4)),
                  borderRadius: BorderRadius.circular(y / 18)),
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                value: selectedValue,
                items: gender,
                onChanged: (Object? value) {},
              ).centered(),
            ),
            "To".text.xl.bold.color(Color(0xff999999)).make(),
            Container(
              height: y / 18,
              width: x / 3,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffC4C4C4)),
                  borderRadius: BorderRadius.circular(y / 18)),
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                value: selectedValue,
                items: gender,
                onChanged: (Object? value) {},
              ).centered(),
            ),
          ],
        ).px(x / 16).pOnly(top: y / 32, bottom: y / 45),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: ["Set Your Breathing Rate".text.bold.lg.makeCentered()],
        ).pOnly(bottom: y / 64).expand()
      ],
    ));
  }

  List<DropdownMenuItem<String>> get gender {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "male"),
      DropdownMenuItem(child: Text("Female"), value: "female"),
    ];
    return menuItems;
  }
}
