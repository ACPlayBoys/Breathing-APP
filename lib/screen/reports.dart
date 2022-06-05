// ignore_for_file: prefer_const_constructors

import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

import '../util/Storage.dart';

class Reports extends StatefulWidget {
  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final String path = "asset/images/shopping/";

  String currentUid = '';
  String actDoc = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> reportMap = [];
  List weekDayBreatheTime = [];

  bool dataRetrieved = false;

  @override
  void initState() {
    // TODO: implement initState
    currentUid = _auth.currentUser!.uid;
    print(currentUid);
    actDoc = currentUid +
        DateFormat.y().format(DateTime.now()) +
        DateFormat.M().format(DateTime.now()) +
        DateFormat.d().format(DateTime.now());

    getStreamDetails();
    super.initState();
  }

  List<Map<String, dynamic>> get weekReportDetails {
    return List.generate(7, (index) {
      var dayBreatheTime;
      var totalTime;
      var day;

      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      print(DateFormat.yMd().format(weekDay));
      for (int i = 0; i < reportMap.length; i++) {
        if (reportMap[i]['date'] == DateFormat.yMd().format(weekDay)) {
          weekDayBreatheTime.add(reportMap[i]['breatheTime']);
          dayBreatheTime = reportMap[i]['breatheTime'];
          day = reportMap[i]['day'];
          totalTime = reportMap[i]['totalTime'];
          print('if wala day of date ${reportMap[i]['date']}: $dayBreatheTime');
          break;
        } else {
          dayBreatheTime = 0;
          day = weekDay.day;
          print('else wala day of date ${reportMap[i]['date']}: $day');
          totalTime = 300;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'breatheTime': dayBreatheTime,
        'totalTime': totalTime
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> reportMap = {};
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: _firestore.collection('report').doc(currentUid).snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(),
            );
          }
          var snap = snapshot.data!.data()!;
          int todayTotalMinutes = (snap['todayTotal'] / 60).truncate();
          int totalTimeMinutes = (snap['totalTime'] / 60).truncate();

          print('snap : $snap');
          var percent = snap['todayTotal'] / snap['totalTime'] * 100;
          var days = snap['streak'];
          return Material(
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        Text(
                          days.toString(),
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.875,
                        ),
                        "Days".text.xl2.bold.color(Colors.white).make(),
                      ],
                    ),
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                            radius: 1,
                            colors: [Color(0xff2C6AE4), Color(0xffC4C4C4)]),
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
                                "${todayTotalMinutes} out of ${totalTimeMinutes} Minutes today"
                                    .text
                                    .bold
                                    .make(),
                              ],
                            ),
                          ],
                        ),
                        buildContainer(
                            child: Container(
                                width: x / 8,
                                height: x / 8,
                                child: "${percent.toStringAsFixed(0)}%"
                                    .text
                                    .makeCentered()
                                    .p8()))
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
                  Container(
                    height: 150,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: weekReportDetails.map((data) {
                        print('chart row widget started');
                        if (data.isNotEmpty && dataRetrieved == true) {
                          double percentage = ((data['breatheTime'] ?? 0.0) /
                              (snap['totalTime'] ?? 1));
                          print('breatheTime ${data['breatheTime']}');
                          print('percent $percent');
                          return Flexible(
                            fit: FlexFit.tight,
                            child: ChartBar(data['day'].toString(), percentage),
                          );
                        }
                        return Container();
                      }).toList(),
                    ).px(x / 16),
                  ),
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
        });
  }

  getStreamDetails() async {
    print('getStreamdetails started');
    QuerySnapshot query = await _firestore
        .collection('report')
        .doc(currentUid)
        .collection('everydayActivity')
        .get();
    final allData =
        query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      reportMap = allData;
      print('reportMap: $reportMap');
      setState(() {
        if (reportMap.isNotEmpty) {
          dataRetrieved = true;
        }
      });
    });
  }

  Widget getChartBar() {
    return RotatedBox(
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
    );
  }
}

class ChartBar extends StatelessWidget {
  final String day;
  final double percentage;

  ChartBar(this.day, this.percentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.7,
            width: 10,
            child: Stack(
              children: [
                Container(
                  width: 11,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                ),
                FractionallySizedBox(
                  heightFactor: 1 - percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(-500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.1,
          ),
          Container(height: constraints.maxHeight * 0.15, child: Text(day)),
        ],
      );
    });
  }
}
