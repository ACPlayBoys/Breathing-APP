// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Breathe extends StatefulWidget {
  Breathe({Key? key}) : super(key: key);

  @override
  State<Breathe> createState() => _BreatheState();
}

class _BreatheState extends State<Breathe> {
  var selectedValue1;
  var selectedValue2;
  String uid = '';

  final String path = "asset/images/schedule/";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

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
                // hint: Text(selectedValue),
                value: selectedValue1,
                items: drop1,
                onChanged: (Object? value) {
                  setState(() {
                    selectedValue1 = value;
                  });
                  FirebaseFirestore.instance.collection('Users').doc(uid).set(
                      {'breatheRateFrom': selectedValue2},
                      SetOptions(merge: true));
                },
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
                // hint: Text(selectedValue),
                value: selectedValue2,
                items: drop2,
                onChanged: (Object? value) {
                  setState(() {
                    selectedValue2 = value;
                  });
                  FirebaseFirestore.instance.collection('Users').doc(uid).set(
                      {'breatheRateTo': selectedValue2},
                      SetOptions(merge: true));
                },
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

  List<DropdownMenuItem<String>> get drop1 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("100"), value: "100"),
      DropdownMenuItem(child: Text("80"), value: "80"),
      DropdownMenuItem(child: Text("60"), value: "60"),
      DropdownMenuItem(child: Text("40"), value: "40"),
      DropdownMenuItem(child: Text("20"), value: "20"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get drop2 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("20"), value: "20"),
      DropdownMenuItem(child: Text("40"), value: "40"),
      DropdownMenuItem(child: Text("60"), value: "60"),
      DropdownMenuItem(child: Text("80"), value: "80"),
      DropdownMenuItem(child: Text("100"), value: "100"),
    ];
    return menuItems;
  }
}
