// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Details extends StatefulWidget {
  PageController pageController;
  Details(this.pageController, {Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var gender;

  final String path = "asset/images/signup/";

  var countryname;

  String name = "";

  String age = "";

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
                    path + "logo1.png",
                    fit: BoxFit.cover,
                  ).expand(),
                ],
              ).pOnly(bottom: y / 32),
              Container(
                height: y / 16,
                child: TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 20),
                    label: "Enter Your Name".text.make().px8(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(y / 20)),
                  ),
                ),
              ).pOnly(bottom: y / 64, left: x / 16, right: x / 16),
              Container(
                height: y / 16,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    age = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 20),
                    label: "Enter Your Age".text.make().px8(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(y / 20)),
                  ),
                ),
              ).pOnly(bottom: y / 64, left: x / 16, right: x / 16),
              Row(
                children: [
                  Container(
                    height: y / 16,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(124, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(100)),
                    child: DropdownButton(
                      hint: "Enter your Country".text.make().px8(),
                      isDense: true,
                      isExpanded: true,
                      value: countryname,
                      items: countryList,
                      onChanged: (Object? value) {
                        countryname = value;
                        setState(() {});
                      },
                    ).centered(),
                  ).expand(),
                ],
              ).pOnly(bottom: y / 64, left: x / 16, right: x / 16),
              Row(
                children: [
                  Container(
                    height: y / 16,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(124, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(100)),
                    child: DropdownButton(
                      hint: "Your Gender".text.make().px8(),
                      isDense: true,
                      isExpanded: true,
                      value: gender,
                      items: genderList,
                      onChanged: (Object? value) {
                        gender = value;
                        setState(() {});
                      },
                    ).centered(),
                  ).expand(),
                ],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            "Next"
                                .text
                                .fontFamily("Poppins")
                                .normal
                                .size(25)
                                .fontWeight(FontWeight.w700)
                                .center
                                .color(Colors.white)
                                .make(),
                            Image.asset(path + "next.png").px8()
                          ],
                        ).px12(),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 38, 101, 228),
                                width: 1),
                            gradient: RadialGradient(
                                radius: 4,
                                colors: [Color(0xff2C6AE4), Color(0xffC4C4C4)]),
                            borderRadius: BorderRadius.circular(50)),
                      )
                    ],
                  ).onInkTap(() {
                    if (name.isEmptyOrNull) {
                      showToast(context, "Please Enter Name");
                      return;
                    }
                    if (age.isEmptyOrNull) {
                      showToast(context, "Please Enter Age");
                      return;
                    }
                    if (!age.isNumber()) {
                      showToast(context, "Please Enter Correct Age");
                      return;
                    }
                    if (countryname == null) {
                      showToast(context, "Please Select Country");
                      return;
                    }
                    if (gender == null) {
                      showToast(context, "Please Select Gender");
                      return;
                    }
                    var r = {
                      "name": name,
                      "age": age,
                      "country": countryname,
                      "gender": gender
                    };
                    userDetails = r;
                    widget.pageController.animateToPage(
                        widget.pageController.page!.toInt() + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  }),
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

  List<DropdownMenuItem<String>> get countryList {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get genderList {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "male"),
      DropdownMenuItem(child: Text("Female"), value: "female"),
    ];
    return menuItems;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
