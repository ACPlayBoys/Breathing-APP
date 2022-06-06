import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MDrawer extends StatefulWidget {
  const MDrawer({Key? key}) : super(key: key);

  @override
  State<MDrawer> createState() => _MDrawerState();
}

class _MDrawerState extends State<MDrawer> {
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
                  "Home".text.xl2.bold.make().pOnly(left: x / 16),
                ],
              ).onInkTap(() {
                Navigator.push(context, Routes.createHomeRoute());
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
                  "Reports".text.xl2.bold.make().pOnly(left: x / 16),
                ],
              ).onInkTap(() {
                Navigator.push(context, Routes.createReportsRoute());
              }).pOnly(
                left: x / 10,
                top: y / 64,
              ),
              Row(
                children: [
                  Image.asset(
                    path + "bag.png",
                    width: x / 16,
                  ),
                  "Shopping".text.xl2.bold.make().pOnly(left: x / 16),
                ],
              ).onInkTap(() {
                Navigator.of(context).push(Routes.createShoppingRoute());
              }).pOnly(
                left: x / 10,
                top: y / 64,
              ),
              Row(
                children: [
                  Image.asset(
                    path + "settings.png",
                    width: x / 16,
                  ),
                  "Settings".text.xl2.bold.make().pOnly(left: x / 16),
                ],
              ).onInkTap(() {
                Navigator.of(context).push(Routes.createSchedulingRoute());
              }).pOnly(
                left: x / 10,
                top: y / 64,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Connect with Us".text.lg.bold.make().py(y / 64),
                  Row(
                    children: [
                      Image.asset(path2 + "google.png").p4(),
                      Image.asset(path2 + "fb.png").p4(),
                      Image.asset(path2 + "twitter.png").p4(),
                    ],
                  ).pOnly(bottom: y / 12),
                  "Version 1.0".text.underline.bold.sm.makeCentered(),
                ],
              ).px(x / 16).py(y / 8).expand(),
            ],
          );
        }),
      ),
    );
  }
}
