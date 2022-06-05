import 'package:breathing_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:velocity_x/velocity_x.dart';

class Rewards extends StatelessWidget {
  const Rewards({Key? key}) : super(key: key);

  final String path = "asset/images/shopping/";
  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Material(
      child: SafeArea(
          child: StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(path + "back.png").onInkTap(() {
                            Navigator.of(context).pop();
                          }),
                          "Rewards".text.xl3.bold.make(),
                          Container()
                        ],
                      ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
                      "Completed"
                          .text
                          .bold
                          .color(borderColor)
                          .make()
                          .px(x / 24)
                          .pOnly(bottom: y / 64),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: x - x / 5,
                                  child:
                                      "Congratulations,You have won a Music Track for completing 20 days, WOHOO!"
                                          .text
                                          .bold
                                          .make(),
                                ).pOnly(bottom: y / 64),
                                Row(
                                  children: [
                                    buildContainer(
                                            child: Image.asset(
                                      path + "rajasthan.png",
                                      height: 50,
                                    ).p4())
                                        .centered(),
                                  ],
                                ).pOnly(bottom: y / 64),
                                "View Music"
                                    .text
                                    .color(borderColor)
                                    .makeCentered(),
                              ],
                            ),
                          ],
                        ).px(x / 32).py(y / 128),
                        decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(20)),
                      ).px(x / 24),
                      "Upcoming"
                          .text
                          .bold
                          .color(borderColor)
                          .make()
                          .px(x / 24)
                          .pOnly(bottom: y / 128, top: y / 64),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('rewards')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return ListView.builder(
                                itemCount: 2,
                                shrinkWrap: true,
                                itemBuilder: ((context, index) {
                                  return buildRewardTile(
                                      x, y, snapshot.data!.docs[index].data());
                                }));
                          })
                    ]);
              })),
    );
  }

  Widget buildRewardTile(x, y, snap) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "${snap['rewardTitle']}".text.bold.lg.make(),
              Row(
                children: [
                  "${snap['rewardDescription']}".text.make(),
                ],
              ),
            ],
          ),
          buildContainer(
              child: Container(
                  width: x / 8,
                  height: x / 8,
                  child: "90%".text.makeCentered().p8()))
        ],
      ).px(x / 32).py(y / 128),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(50)),
    ).px(x / 24).pOnly(
          bottom: y / 64,
        );
  }
}
