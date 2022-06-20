import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../util/routes.dart';
import 'payments/Paypal.dart';

class Subscription extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> plans = ["3 Months Plan", "6 Months Plan", "1 Year Plan"];
  final List<String> price = ["99", "299", "699"];
  final String path = "asset/images/shopping/";

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: MDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Image.asset(path + "menu.png").onInkTap(() {
                //   _scaffoldKey.currentState?.openDrawer();
                // }),
                Spacer(),
                "Your Subscriptions".text.xl3.bold.make(),
                Spacer(),
              ],
            ).pOnly(top: y / 24, bottom: y / 8).px(x / 24),
            "Choose Your Subscription"
                .text
                .lg
                .semiBold
                .make()
                .pOnly(top: y / 64, bottom: y / 64, left: y / 64),
            VxSwiper.builder(
                height: y / 2,
                enlargeCenterPage: true,
                itemCount: 3,
                itemBuilder: (context, i) {
                  MusicModel m = MusicModel(
                      duration: '',
                      name: plans[i],
                      image: '',
                      link: '',
                      type: '',
                      price: int.parse(price[i]));
                  return Container(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  plans[i]
                                      .text
                                      .xl2
                                      .makeCentered()
                                      .pOnly(top: y / 64, bottom: y / 64),
                                  "45 Breathes"
                                      .text
                                      .lg
                                      .makeCentered()
                                      .pOnly(bottom: y / 128, left: y / 128),
                                  "10 Music"
                                      .text
                                      .lg
                                      .makeCentered()
                                      .pOnly(bottom: y / 128, left: y / 128),
                                  "12 Animations"
                                      .text
                                      .lg
                                      .makeCentered()
                                      .pOnly(bottom: y / 128, left: y / 128),
                                ],
                              ).expand(),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: y / 8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                Routes.createPaypalRoute(
                                                    m, 'subscribe'));
                                          },
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            width: x / 2.5,
                                            height: y / 16,
                                            child: "Buy Now"
                                                .text
                                                .lg
                                                .bold
                                                .makeCentered()
                                                .px16(),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        y / 16)),
                                          ),
                                        ),
                                        '\$${price[i]}'.text.xl.make()
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(123, 255, 255, 255),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          decoration: kGradientBoxDecoration)
                      .px(x / 24);
                }),
          ],
        ),
      ),
    );
  }
}
