// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';

class MusicScreen extends StatefulWidget {
  MusicModel m;
  bool isBought;
  MusicScreen({Key? key, required this.m, required this.isBought})
      : super(key: key);
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final _firestore = FirebaseFirestore.instance;
  late User u;
  final String path = "asset/images/shopping/";
  late MusicModel m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool playing = false;
  bool mainPlaying = false;
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer mainPlayer = AudioPlayer();
  List<MusicModel> list = [];

  @override
  void initState() {
    //razorpay.on("error", handlerError);
    u = FirebaseAuth.instance.currentUser!;

    m = widget.m;
    list.add(m);
    list.add(m);
    list.add(m);
    list.add(m);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("recents")
        .doc(m.name)
        .set(m.toMap())
        .then((value) => FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("recents")
            .doc(m.name)
            .set({"time": DateTime.now().toIso8601String()},
                SetOptions(merge: true)));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    mainPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: MDrawer(),
        body: SafeArea(
            child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Image.asset(path + "back.png").onInkTap(() {
                    Navigator.of(context).pop();
                  }),
                  Spacer(),
                  Image.asset(path + "search.png").onInkTap(() {
                    Navigator.of(context).pop();
                  }),
                ],
              ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
              buildContainer(
                      child: CircleAvatar(
                backgroundImage: NetworkImage(m.image),
                radius: y / 8,
              ).p8())
                  .centered(),
              m.name.text.xl2.bold.makeCentered(),
              "${m.duration} Mins".text.lg.makeCentered(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildContainer(
                      child: Image.asset(!playing
                              ? path + "playdeep.png"
                              : path + "pausedeep.png")
                          .onInkTap(() {
                    playing = !playing;
                    setState(() {});
                    if (playing)
                      mainPlayer.play(m.link);
                    else
                      mainPlayer.pause();
                  }).p8()),
                ],
              ),
              "Similar Tracks".text.bold.color(borderColor).make(),
              ListView.separated(
                      itemBuilder: ((context, index) {
                        MusicModel m = Storage.allmusic[index];
                        return Container(
                          child: Row(
                            children: [
                              buildContainer(
                                child: Image.network(
                                  m.image,
                                  width: 60,
                                ).p4(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  m.name.text.extraBold.make(),
                                  m.duration.text.extraBold.make(),
                                ],
                              ).px(x / 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(!playing
                                          ? (path + "play.png")
                                          : (path + "pause.png"))
                                      .onInkTap(() {
                                    playing = !playing;
                                    //setState(() {});
                                    if (playing)
                                      player.play(m.link);
                                    else
                                      player.pause();
                                  }),
                                ],
                              ).expand()
                            ],
                          ),
                        )
                            .onInkTap(() {
                              Navigator.of(context).pushReplacement(
                                  Routes.createMusicRoute(m, false));
                            })
                            .px(x / 16)
                            .py(y / 128);
                      }),
                      separatorBuilder: (context, index) {
                        return Divider(thickness: 1).px16();
                      },
                      itemCount: Storage.allmusic.length)
                  .expand(),
            ]),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: y / 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: x / 2.5,
                        height: y / 16,
                        child: "Add to WishList"
                            .text
                            .lg
                            .bold
                            .makeCentered()
                            .px16(),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(y / 16)),
                      ).onInkTap(() {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("wishlist")
                            .doc(m.name)
                            .set(m.toMap())
                            .then((value) =>
                                showToast(context, "Added to Wishlist"));
                      }),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          widget.isBought == false
                              ? Navigator.of(context)
                                  .push(Routes.createPaypalRoute(m, 'buy'))
                              : Storage.downloadMusic(m.link, prefs);
                          widget.isBought == false
                              ? {}
                              : _firestore.collection('Users').doc(u.uid).set(
                                  {'audioType': 'userAudio'},
                                  SetOptions(merge: true));

                          widget.isBought == false
                              ? {}
                              : _firestore
                                  .collection('Users')
                                  .doc(u.uid)
                                  .collection('audioCollection')
                                  .add({
                                  'link': m.link,
                                  'timeStamp': DateTime.now(),
                                });
                        },
                        child: Container(
                          width: x / 2.5,
                          height: y / 16,
                          child: widget.isBought == false
                              ? "Buy Now".text.lg.bold.makeCentered().px16()
                              : m.type == 'music'
                                  ? "Set Music"
                                      .text
                                      .lg
                                      .bold
                                      .makeCentered()
                                      .px16()
                                  : m.type == 'picture'
                                      ? "Set Picture"
                                          .text
                                          .lg
                                          .bold
                                          .makeCentered()
                                          .px16()
                                      : m.type == 'animation'
                                          ? "Set Animation"
                                              .text
                                              .lg
                                              .bold
                                              .makeCentered()
                                              .px16()
                                          : "Set"
                                              .text
                                              .lg
                                              .bold
                                              .makeCentered()
                                              .px16(),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(y / 16)),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: borderColor.withOpacity(0.1),
                        offset: Offset(0.0, -19.0), //(x,
                        blurRadius: 50.0,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )));
  }
}
