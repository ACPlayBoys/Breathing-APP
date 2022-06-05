import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeSCreen extends StatefulWidget {
  const HomeSCreen({Key? key}) : super(key: key);

  @override
  State<HomeSCreen> createState() => _HomeSCreenState();
}

class _HomeSCreenState extends State<HomeSCreen> with TickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String currentUid = '';
  final String path = "asset/images/home/";
  MusicModel m = MusicModel(
      duration: "300",
      name: "Rajashtan Mist",
      link: "mal",
      image: "asset/images/home/" + "rajasthan.png");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MusicModel> list = [];

  bool isPlaying = false;

  bool canPlay = false;
  bool isMute = true;
  bool docExist = false;
  bool checkdone = false;

  AudioPlayer audioPlayer = AudioPlayer();

  int time = 0;

  String url =
      'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/breathe.mp3?alt=media&token=36329fe1-4243-46f5-ba62-cdb9a2055f55';

  late GifController controller;
  int speed = 1000;
  @override
  void initState() {
    currentUid = _auth.currentUser!.uid;
    getAudio();

    controller = GifController(vsync: this);
    list.add(m);
    list.add(m);
    list.add(m);
    list.add(m);

    // checkDoc();
    super.initState();
  }

  getAudio() async {
    var snap = await _firestore
        .collection('Users')
        .doc('15OX5wUmgcUU5r2NxpIHUdXYsZl1')
        .get();
    var audioType = snap['audioType'];
    print('audioType $audioType');
    if (audioType == 'default') {
      setState(() {
        url =
            'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/breathe.mp3?alt=media&token=36329fe1-4243-46f5-ba62-cdb9a2055f55';
      });
    } else if (audioType == 'userAudio') {
      var snapshot = await _firestore
          .collection('Users')
          .doc('15OX5wUmgcUU5r2NxpIHUdXYsZl1')
          .collection('audioCollection')
          .orderBy('timeStamp', descending: false)
          .get();
      print(snapshot.docs.length);
      var reqdoc = snapshot.docs.length - 1;
      print(snapshot.docs[reqdoc].data()['link']);
      setState(() {
        if (url != null) {
          url = snapshot.docs[reqdoc].data()['link'];
        } else {
          url =
              'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/breathe.mp3?alt=media&token=36329fe1-4243-46f5-ba62-cdb9a2055f55';
        }
        print('url $url');
      });
    }
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    audioPlayer.setUrl(url).then((value) => setState(() {
          canPlay = true;
        }));
  }

  onPause() async {
    controller.stop();
    // pauseHandler();
    await audioPlayer.pause();
    print('audio Paused');
  }

  onPlay() async {
    controller.repeat(min: 0, max: 9, period: Duration(milliseconds: speed));
    // playHandler();
    await audioPlayer.resume();

    print('audio Playing');
  }

  onMute() async {
    await audioPlayer.setVolume(0);
  }

  timer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isPlaying == true) {
        setState(() {
          time = time + 1;
        });
      } else {
        timer.cancel();
        // addTime();
      }
    });
  }

  // addTime()async{
  //   _firestore.collection('collectionPath').doc('').collection('collectionPath').doc
  // }

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
            image: NetworkImage(Storage.gifUrl),
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
                    min: 0, max: 3, period: Duration(milliseconds: speed));
              }).pOnly(right: x / 32),
              Container(
                child:
                    buildContainer(child: Image.asset(path + "minus.png").p2()),
              ).onInkTap(() {
                speed < 2000 ? speed += 200 : speed = 2000;
                controller.repeat(
                    min: 0, max: 3, period: Duration(milliseconds: speed));
              }).pOnly(left: x / 32)
            ],
          ).pOnly(bottom: y / 32),
          Container(
            child: buildContainer(
                child: Image.asset(
                        !isPlaying ? path + "play.png" : path + "pause.png")
                    .onInkTap(() {
              setState(() {
                isPlaying ? onPause() : onPlay();
                isPlaying = !isPlaying;
              });
            }).p8()),
          ).centered()
        ])));
  }

  addReport() {
    // _firestore.collection('report').doc(currentUid).set({
    //   'previousBreatheDate': DateFormat.yMd().format(DateTime.now()),
    //   'streak': 0,
    //   'todayTotal': 0,
    //   'totalTime': 5
    // });
    String actDoc = currentUid + DateFormat.yMd().format(DateTime.now());

    _firestore
        .collection('report')
        .doc(currentUid)
        .collection('everydayActivity');
  }
}
