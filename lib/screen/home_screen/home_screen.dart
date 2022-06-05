import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

class HomeSCreen extends StatefulWidget {
  const HomeSCreen({Key? key}) : super(key: key);

  @override
  State<HomeSCreen> createState() => _HomeSCreenState();
}

class _HomeSCreenState extends State<HomeSCreen> with TickerProviderStateMixin {
  final String path = "asset/images/home/";
  MusicModel m = MusicModel(
      duration: "300",
      name: "Rajashtan Mist",
      link: "mal",
      image: "asset/images/home/" + "rajasthan.png");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MusicModel> list = [];

  bool isPlaying = false;

  late GifController controller;
  int speed = 1000;
  @override
  void initState() {
    controller = GifController(vsync: this);
    list.add(m);
    list.add(m);
    list.add(m);
    list.add(m);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: MDrawer(),
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Image.asset(path + "menu.png").onInkTap(() {
                _scaffoldKey.currentState?.openDrawer();
              }),
              Spacer(),
              "Breathe In".text.xl3.bold.make(),
              Spacer(),
              buildContainer(child: Icon(CupertinoIcons.volume_off).p4())
            ],
          ).pOnly(top: y / 24, bottom: y / 8).px(x / 24),
          GifImage(
            height: y / 4,
            image: NetworkImage(Storage.gifUrl.link),
            controller: controller,
          ).centered().pOnly(bottom: y / 8),
          "Breathing Rate"
              .text
              .xl2
              .bold
              .make()
              .pOnly(bottom: y / 64)
              .centered(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child:
                    buildContainer(child: Image.asset(path + "add.png").p2()),
              ).onInkTap(() {
                speed > 200 ? speed -= 200 : speed = 200;
                controller.repeat(
                    min: 0, max:Storage.gifUrl.frames, period: Duration(milliseconds: speed));
              }).pOnly(right: x / 32),
              Container(
                child:
                    buildContainer(child: Image.asset(path + "minus.png").p2()),
              ).onInkTap(() {
                speed < 2000 ? speed += 200 : speed = 2000;
                controller.repeat(
                    min: 0, max:Storage.gifUrl.frames, period: Duration(milliseconds: speed));
              }).pOnly(left: x / 32)
            ],
          ).pOnly(bottom: y / 32),
          Container(
            child: buildContainer(
                child: Image.asset(
                        !isPlaying ? path + "playdeep.png" : path + "pausedeep.png")
                    .onInkTap(() {
              setState(() {
                isPlaying
                    ? controller.stop()
                    : controller.repeat(
                        min: 0, max:Storage.gifUrl.frames, period: Duration(milliseconds: speed));
                isPlaying = !isPlaying;
              });
            }).p8()),
          ).centered()
        ])));
  }
}
