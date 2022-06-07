import 'dart:async';
import 'dart:developer';

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

  final String path = "asset/images/home/";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MusicModel> list = [];

  String currentUid = '';
  String prevDbDate = '';

  bool isPlaying = false;
  bool canPlay = false;
  bool isMute = true;
  bool docExist = false;
  bool checkdone = false;

  int breatheTime = 0;
  int time = 0;
  int streak = 0;
  double playbackSpeed = 1.0;
  late int playedTime;

  AudioPlayer audioPlayer = AudioPlayer();

  String url =
      'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/breathe.mp3?alt=media&token=36329fe1-4243-46f5-ba62-cdb9a2055f55';

  late GifController controller;
  int speed = 1000;

  @override
  void initState() {
    playedTime = 1;
    audioPlayer.onPlayerStateChanged.listen((event) {
      log(
        "check +${event.toString()}",
        error: event.toString(),
      );
    });
    controller = GifController(vsync: this);

    currentUid = _auth.currentUser!.uid;
    getReportData();
    // addStreak();
    getAudio();
    Storage.getGif();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          drawer: MDrawer(),
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Image.asset(path + "menu.png").onInkTap(() {
                      _scaffoldKey.currentState?.openDrawer();
                    }),
                    Spacer(),
                    "Breathe In".text.xl3.bold.make(),
                    Spacer(),
                    buildContainerOnTap(
                        child: Icon(CupertinoIcons.volume_off).p4())
                  ],
                ).pOnly(top: y / 24, bottom: y / 8).px(x / 24),
                ValueListenableBuilder(
                    valueListenable: Storage.giffer,
                    builder: (context, value, child) {
                      return value == 0
                          ? Container(
                              height: y / 4,
                              width: y / 4,
                              child: CircularProgressIndicator())
                          : GifImage(
                              height: y / 4,
                              image: NetworkImage(Storage.gifUrl.link),
                              controller: controller,
                            );
                    }).centered().pOnly(bottom: y / 8),
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
                      child: buildContainer(
                          child: Image.asset(path + "add.png").p2()),
                    ).onInkTap(() {
                      speed > 200 ? speed -= 200 : speed = 200;
                      controller.repeat(
                          min: 0,
                          max: Storage.gifUrl.frames,
                          period: Duration(milliseconds: speed));
                      onSpeedInc();
                    }).pOnly(right: x / 32),
                    Container(
                      child: buildContainer(
                          child: Image.asset(path + "minus.png").p2()),
                    ).onInkTap(() {
                      speed < 2000 ? speed += 200 : speed = 2000;
                      controller.repeat(
                          min: 0,
                          max: Storage.gifUrl.frames,
                          period: Duration(milliseconds: speed));
                      onSpeedDec();
                    }).pOnly(left: x / 32)
                  ],
                ).pOnly(bottom: y / 32),
                Container(
                  child: buildContainer(
                      child: playedTime == 1
                          ? canPlay
                              ? Image.asset(!isPlaying
                                      ? path + "playdeep.png"
                                      : path + "pausedeep.png")
                                  .onInkTap(() {
                                  setState(() {
                                    isPlaying ? onPause() : onPlay();
                                    isPlaying = !isPlaying;
                                  });
                                }).p8()
                              : CircularProgressIndicator()
                          : Image.asset(!isPlaying
                                  ? path + "playdeep.png"
                                  : path + "pausedeep.png")
                              .onInkTap(() {
                              setState(() {
                                isPlaying ? onPause() : onPlay();
                                isPlaying = !isPlaying;
                              });
                            }).p8()),
                ).centered()
              ]))),
    );
  }

  onSpeedInc() {
    setState(() {
      playbackSpeed += 0.5;
    });
    audioPlayer.setPlaybackRate(playbackSpeed);
  }

  onSpeedDec() {
    setState(() {
      playbackSpeed -= 0.5;
    });
    audioPlayer.setPlaybackRate(playbackSpeed);
  }

  onPause() {
    controller.stop();
    // pauseHandler();
    audioPlayer.pause();
    timer();
    print('audio Paused');
  }

  onPlay() {
    print('depalyed playedtime $playedTime');
    controller.repeat(
        min: 0,
        max: Storage.gifUrl.frames,
        period: Duration(milliseconds: speed));
    // playHandler();

    audioPlayer.resume();
    setState(() {
      canPlay = false;
      print('depalyed caplay $canPlay');
    });
    Timer(Duration(seconds: 5), () {
      setState(() {
        canPlay = true;
        print('depalyed caplay $canPlay');
      });
    });
    timer();
    setState(() {
      playedTime += 1;
    });
    print('depalyed playedtime $playedTime');

    print('audio Playing');
  }

  onMute() {
    if (isMute) {
      audioPlayer.setVolume(0);
      isMute = !isMute;
    } else {
      audioPlayer.setVolume(1);
      isMute = !isMute;
    }
  }

  timer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      print('timerStarted');
      if (isPlaying == true) {
        setState(() {
          time = time + 1;
          print(time);
        });
      } else {
        print('timerStopped $time');
        addReport();
        timer.cancel();
        time = 0;
      }
    });
  }

  getAudio() async {
    setState(() {
      canPlay = false;
    });
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
      print('await complete');
      print(snapshot.docs.length);
      var reqdoc = snapshot.docs.length - 1;
      print(snapshot.docs[reqdoc].data()['link']);
      setState(() {
        if (url != null) {
          url = snapshot.docs[reqdoc].data()['link'];
          print('got url ');
        } else {
          url =
              'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/breathe.mp3?alt=media&token=36329fe1-4243-46f5-ba62-cdb9a2055f55';
          print('got url ');
        }
        print('url $url');
      });
    }
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    audioPlayer.setUrl(url).then((value) => setState(() {
          canPlay = true;
        }));
    ;
    print('audioSet');
  }

  Widget buildContainerOnTap({child}) {
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(2.0), //width of the border
          child: ClipOval(
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: () => onMute(),
              child: Container(
                // this height forces the container to be a circle
                child: child,

                decoration: kInnerDecoration,
              ),
            ),
          ),
        ),
        decoration: kGradientBoxDecoration,
      ),
    );
  }

  getReportData() async {
    print(' got report data');
    var data = await _firestore
        .collection('report')
        .doc(currentUid)
        .get()
        .then((data) {
      setState(() {
        breatheTime = data['todayTotal'];
        prevDbDate = data['previousBreatheDate'];
        streak = data['streak'];
        print('breatheTime $breatheTime preDate $prevDbDate streak $streak');
      });
      addStreak();
    });
  }

  addReport() {
    print('adding report');
    String actDoc = currentUid +
        DateFormat.y().format(DateTime.now()) +
        DateFormat.M().format(DateTime.now()) +
        DateFormat.d().format(DateTime.now());

    breatheTime = breatheTime + time;
    _firestore
        .collection('report')
        .doc(currentUid)
        .collection('everydayActivity')
        .doc(actDoc)
        .set({
      'breatheTime': breatheTime,
      'timeStamp': DateTime.now(),
      'date': DateFormat.yMd().format(DateTime.now())
    }, SetOptions(merge: true));
    _firestore.collection('report').doc(currentUid).set({
      'todayTotal': breatheTime,
    }, SetOptions(merge: true));
  }

  addStreak() {
    final prevDate =
        DateFormat.yMd().format(DateTime.now().subtract(Duration(days: 1)));
    final todayDate = DateFormat.yMd().format(DateTime.now());

    print('$prevDbDate && $prevDate && $todayDate');

    final stream = _firestore.collection('report').doc(currentUid);
    streak += 1;

    if (prevDbDate == prevDate) {
      stream.set({'previousBreatheDate': todayDate, 'streak': streak},
          SetOptions(merge: true));
    } else if (prevDbDate != prevDate && prevDbDate != todayDate) {
      stream.set({'previousBreatheDate': todayDate, 'streak': 0},
          SetOptions(merge: true));
    }
  }
}
