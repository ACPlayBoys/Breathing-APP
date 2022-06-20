import 'package:breathing_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Rewards extends StatefulWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  final String path = "asset/images/shopping/";

  String currUid = FirebaseAuth.instance.currentUser!.uid;
  List uids = [];

  @override
  void initState() {
    // TODO: implement initState
    getCompletedRewards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    print(uids);

    return Material(
      child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        uids == null || uids == []
            ? Column(
                children: [
                  "Completed"
                      .text
                      .bold
                      .color(borderColor)
                      .make()
                      .px(x / 24)
                      .pOnly(bottom: y / 64),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('rewards')
                          .doc(uids[0])
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(),
                          );
                        }
                        var snap = snapshot.data!.data()!;

                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: x - x / 5,
                                    child:
                                        "Congratulations,You have won a Music Track for completing ${snap['days']} days, WOHOO!"
                                            .text
                                            .bold
                                            .make(),
                                  ).pOnly(bottom: y / 64),
                                  Row(
                                    children: [
                                      buildContainer(
                                          child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('allMusic')
                                                  .doc(snap['rewardItem'])
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot<
                                                              Map<String,
                                                                  dynamic>>>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                var snap =
                                                    snapshot.data!.data()!;
                                                return Image.network(
                                                  snap['image'],
                                                  height: 50,
                                                ).p4();
                                              })).centered(),
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
                        ).px(x / 24);
                      }),
                ],
              )
            : Container(),
        "Upcoming"
            .text
            .bold
            .color(borderColor)
            .make()
            .px(x / 24)
            .pOnly(bottom: y / 128, top: y / 64),
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('rewards').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return buildRewardTile(
                        x, y, snapshot.data!.docs[index].data(), currUid);
                  }));
            })
      ])),
    );
  }

  getCompletedRewards() async {
    var snap =
        await FirebaseFirestore.instance.collection('Users').doc(currUid).get();
    print(snap.data());
    setState(() {
      uids = snap.data()!['completedRewards'];
      print(uids);
      if (uids == null) {
        uids = [];
      }
    });
    print(uids);
  }

  Widget buildRewardTile(x, y, snap, u) {
    String percentageStreak = '';
    print(u);
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('report').doc(u).snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(),
            );
          }
          print('object ${snap['rewardId']}');
          if (uids.contains(snap['rewardId'])) {
            return Container();
          } else {
            final colSnap = snapshot.data!.data()!;
            if (snap['type'] == 'streak') {
              percentageStreak =
                  ((((colSnap['minWiseStreak'])) / (snap['days'])) * 100)
                      .toStringAsFixed(0);
            } else if (snap['type'] == 'completeInDays') {
              percentageStreak =
                  ((((colSnap['totTimeCompStreak'])) / (snap['days'])) * 100)
                      .toStringAsFixed(0);
            }
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
                          child:
                              "${percentageStreak}%".text.makeCentered().p8()))
                ],
              ).px(x / 32).py(y / 128),
              decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(50)),
            ).px(x / 24).pOnly(
                  bottom: y / 64,
                );
          }
        });
  }
}
