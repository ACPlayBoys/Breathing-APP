// ignore_for_file: prefer_const_constructors
import 'package:breathing_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var selectedValue;

  int dd = 0;

  int mm = 0;

  int yy = 0;

  late TextEditingController controllerMM;

  var controllerDD;

  var controllerYY;

  final String path = "asset/images/schedule/";

  late TextEditingController controllerTimeTo;

  late TextEditingController controllerTimeFrom;

  String startTime = "";

  String endTime = "";
  @override
  void initState() {
    // TODO: implement initState

    controllerMM = TextEditingController();
    controllerDD = TextEditingController();
    controllerYY = TextEditingController();
    controllerTimeFrom = TextEditingController();
    controllerTimeTo = TextEditingController();
    super.initState();
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
            "Schedule a Session".text.xl3.bold.make(),
            Spacer()
          ],
        ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
        Row(
          children: [
            Image.asset(
              path + "schedule.png",
              fit: BoxFit.cover,
            ).expand(),
          ],
        ),
        "Schedule"
            .text
            .xl2
            .bold
            .make()
            .pOnly(top: y / 35, bottom: y / 300)
            .px32(),
        "Date".text.xl.make().pOnly(bottom: y / 400).px(x / 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: y / 20,
              width: x / 4,
              child: TextField(
                readOnly: true,
                controller: controllerDD,
                onTap: () {
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    dd = date.day;
                    mm = date.month;
                    yy = date.year;
                    controllerMM.text = mm.toString();
                    controllerDD.text = dd.toString();
                    controllerYY.text = yy.toString();
                    setState(() {});
                    print('confirm ${date}');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 20),
                  label: "DD".text.makeCentered().px8(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(y / 20)),
                ),
              ),
            ),
            "-".text.bold.color(Color.fromARGB(54, 0, 0, 0)).make(),
            Container(
              height: y / 20,
              width: x / 4,
              child: TextField(
                readOnly: true,
                controller: controllerMM,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 20),
                  label: "MM".text.makeCentered().px8(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(y / 20)),
                ),
                onTap: () {
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    dd = date.day;
                    mm = date.month;
                    yy = date.year;
                    controllerMM.text = mm.toString();
                    controllerDD.text = dd.toString();
                    controllerYY.text = yy.toString();
                    setState(() {});
                    print('confirm ${date}');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ),
            ),
            "-".text.bold.color(Color.fromARGB(54, 0, 0, 0)).make(),
            Container(
              height: y / 20,
              width: x / 4,
              child: TextField(
                readOnly: true,
                controller: controllerYY,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 20),
                  label: "YYYY".text.makeCentered().px8(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(y / 20)),
                ),
                onTap: () {
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    dd = date.day;
                    mm = date.month;
                    yy = date.year;
                    controllerMM.text = mm.toString();
                    controllerDD.text = dd.toString();
                    controllerYY.text = yy.toString();
                    setState(() {});
                    print('confirm ${date}');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ),
            ),
          ],
        ).px(x / 12),
        "Time".text.xl.make().pOnly(top: 8, bottom: 4).px(x / 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: y / 18,
              width: x / 3,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(y / 18)),
              child: TextField(
                readOnly: true,
                controller: controllerTimeFrom,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 20),
                  label: "Select Time".text.sm.makeCentered().px8(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(y / 20)),
                ),
                onTap: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      showSecondsColumn: false, onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    startTime =
                        date.hour.toString() + ":" + date.minute.toString();
                    controllerTimeFrom.text =
                        date.hour.toString() + " : " + date.minute.toString();
                    setState(() {});
                    print('confirm ${date}');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ).centered(),
            ),
            "To".text.xl.bold.color(Color(0xff999999)).make(),
            Container(
              height: y / 18,
              width: x / 3,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(y / 18)),
              child: TextField(
                readOnly: true,
                controller: controllerTimeTo,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 20),
                  label: "Select Time".text.sm.makeCentered().px8(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(y / 20)),
                ),
                onTap: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      showSecondsColumn: false, onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    endTime =
                        date.hour.toString() + ":" + date.minute.toString();
                    controllerTimeTo.text =
                        date.hour.toString() + " : " + date.minute.toString();
                    setState(() {});
                    print('confirm ${date}');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ).centered(),
            ),
          ],
        ).px(x / 12).pOnly(bottom: y / 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                "Add More"
                    .text
                    .size(15)
                    .color(Color(0xff2C6AE4))
                    .make()
                    .pOnly(right: 4),
                Image.asset(path + "button.png")
              ],
            ).onInkTap(() {
              setSession(context);
            }),
          ],
        ).px(x / 12)
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

  void setSession(BuildContext context) {
    if (dd == 0) {
      showToast(context, "Please Set Date");
      return;
    }
    if (mm == 0) {
      showToast(context, "Please Set Month");
      return;
    }
    if (yy == 0) {
      showToast(context, "Please Set year");
      return;
    }
    if (startTime.isEmptyOrNull) {
      showToast(context, "Please Set Start Time");
      return;
    }
    if (endTime.isEmptyOrNull) {
      showToast(context, "Please Set End Time");
      return;
    }
    showToast(context, "Session Schedule");
  }
}
