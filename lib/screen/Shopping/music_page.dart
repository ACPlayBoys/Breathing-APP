// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';

class MusicScreen extends StatefulWidget {
  MusicModel m;
  MusicScreen({
    Key? key,
    required this.m,
  }) : super(key: key);
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final String path = "asset/images/shopping/";
  late MusicModel m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isplaying = false;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  @override
  void initState() {
    m = widget.m;

    audioPlayer.setUrl(widget.m.link);

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // TODO: implement dispose
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              buildContainer(child: Image.network(m.image).p8()).centered(),
              m.name.text.xl2.bold.makeCentered(),
              "${m.duration} Mins".text.lg.makeCentered(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildContainer(
                      child: Image.asset(!isplaying
                              ? path + "playdeep.png"
                              : path + "pause.png")
                          .onInkTap(() {
                    isplaying = !isplaying;
                    if (isplaying) {
                      audioPlayer.resume();
                    } else {
                      audioPlayer.pause();
                    }
                    setState(() {});
                  }).p8()),
                ],
              ),
              "Similar Tracks".text.bold.color(borderColor).make(),
              ListView.separated(
                      itemBuilder: ((context, index) {
                        MusicModel m = Storage.audios.value[index];
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
                                  Image.asset("asset/images/shopping/play.png")
                                      .onInkTap(() {}),
                                ],
                              ).expand()
                            ],
                          ),
                        )
                            .onInkTap(() {
                              //audioPlayer.dispose();
                              Navigator.of(context)
                                  .pushReplacement(Routes.createMusicRoute(m));
                            })
                            .px(x / 16)
                            .py(y / 128);
                      }),
                      separatorBuilder: (context, index) {
                        return Divider(thickness: 1).px16();
                      },
                      itemCount: Storage.audios.value.length)
                  .expand(),
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
                        ),
                        Container(
                          width: x / 2.5,
                          height: y / 16,
                          child: "Buy Now".text.lg.bold.makeCentered().px16(),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(y / 16)),
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
            ])));
  }
}
