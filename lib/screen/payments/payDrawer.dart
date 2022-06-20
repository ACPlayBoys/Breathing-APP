import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/musicmodel.dart';

class payDrawer extends StatefulWidget {
  MusicModel m;
  String pay;
  payDrawer({Key? key, required this.m,required this.pay}) : super(key: key);

  @override
  State<payDrawer> createState() => _payDrawerState();
}

class _payDrawerState extends State<payDrawer> {
  final String path = "asset/images/home/";
  final String path2 = "asset/images/signup/";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: LayoutBuilder(builder: (context, constraints) {
          var x = constraints.maxWidth;
          var y = constraints.maxHeight;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  buildContainer(
                      child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL.isEmptyOrNull
                        ? path + "profile.png"
                        : FirebaseAuth.instance.currentUser!.photoURL!,
                    width: x / 8,
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FirebaseAuth
                          .instance.currentUser!.displayName!.text.bold.lg
                          .make(),
                      SizedBox(
                          width: x - x / 3,
                          child: FirebaseAuth.instance.currentUser!.email!.text
                              .maxLines(1)
                              .overflow(TextOverflow.ellipsis)
                              .size(10)
                              .make()),
                    ],
                  ).pOnly(left: x / 32),
                ],
              ).pOnly(left: x / 16, top: y / 16),
              Row(
                children: [
                  Image.asset(
                    path + "home.png",
                    width: x / 16,
                  ),
                  "Paypal".text.xl2.bold.make().pOnly(left: x / 16),
                ],
              ).onInkTap(() {
                Navigator.push(
                    context,
                    Routes.createPaypalRoute(
                      widget.m,widget.pay
                    ));
              }).pOnly(
                left: x / 10,
                top: y / 12,
              ),
              Row(
                children: [
                  Image.asset(
                    path + "stats.png",
                    width: x / 16,
                  ),
                  "Stripe".text.xl2.bold.make().pOnly(left: x / 16),
                ],
              ).onInkTap(() {
                Navigator.push(
                    context,
                    Routes.createStripeRoute(
                      widget.m,widget.pay
                    ));
              }).pOnly(
                left: x / 10,
                top: y / 64,
              ),
            ],
          );
        }),
      ),
    );
  }
}
