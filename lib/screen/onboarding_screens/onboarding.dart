// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:breathing_app/screen/onboarding_screens/page1.dart';
import 'package:breathing_app/screen/onboarding_screens/page2.dart';
import 'package:breathing_app/screen/onboarding_screens/page3.dart';
import 'package:breathing_app/screen/onboarding_screens/page4.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class OnBoarding extends StatefulWidget {
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController _pageController = PageController();
  final String path = "asset/images/on_boarding/page2/";

  bool next = true;

  double height = 100;

  var _timer;

  double _progressValue = 0;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_timer) {
      if (_progressValue == 100) _progressValue = 0;
      setState(() {
        _progressValue++;
      });
    });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              OnPage1(),
              OnPage2(),
              OnPage3(),
              OnPage4(),
            ],
          ).expand(),
          Stack(
            children: [
              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0), //width of the border
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        // this height forces the container to be a circle
                        child: Image.asset(next
                                ? "asset/images/on_boarding/button_1.png"
                                : "asset/images/on_boarding/button_2.png")
                            .p8(),

                        decoration: kInnerDecoration,
                      ),
                    ),
                  ),
                  decoration: kGradientBoxDecoration,
                ),
              ).centered(),
              SizedBox(
                child: SfRadialGauge(
                    enableLoadingAnimation: true,
                    axes: <RadialAxis>[
                      RadialAxis(
                        radiusFactor: 1.1,
                        labelOffset: 0,
                        showAxisLine: false,
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        pointers: <GaugePointer>[
                          MarkerPointer(
                            value: _progressValue,
                            enableAnimation: true,
                            animationDuration: 100,
                            animationType: AnimationType.easeInCirc,
                            markerType: MarkerType.circle,
                            color: const Color(0xFF87e8e8),
                          )
                        ],
                      )
                    ]),
                height: height,
                width: height,
              ).centered(),
            ],
          ).onInkTap(() {
            nextPage();
          }),
        ],
      ).pOnly(bottom: 128),
    );
  }

  void nextPage() {
    if (_pageController.page == 3) {
      Navigator.of(context).push(Routes.createSignUpRoute());
    } else {
      _pageController.animateToPage(_pageController.page!.toInt() + 1,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);

      setState(() {
        next = false;
      });
    }
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
