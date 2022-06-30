// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

String audioUrl =
    'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/breathe.mp3?alt=media&token=36329fe1-4243-46f5-ba62-cdb9a2055f55';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  final _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final String path = "asset/images/schedule/";
  String currentUid = '';
  AudioPlayer player = AudioPlayer();

  bool playing = false;

  @override
  void initState() {
    // TODO: implement initState
    currentUid = _auth.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.back),
            Spacer(),
            "Set your Music".text.xl3.bold.make(),
            Spacer()
          ],
        ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
        Row(
          children: [
            Image.asset(
              path + "music.png",
              fit: BoxFit.cover,
            ).expand(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                _firestore
                    .collection('Users')
                    .doc(currentUid)
                    .set({'audioType': 'default'}, SetOptions(merge: true));
                showToast(context, 'Default Audio Selected');
              },
              child: Container(
                width: x / 3,
                height: y / 16,
                child: "Use Default".text.lg.bold.makeCentered().px16(),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(y / 16)),
              ),
            ),
            GestureDetector(
              onTap: () {
                selectFile();
                // uploadFile();
              },
              child: Container(
                width: x / 3,
                height: y / 16,
                child: "Add Your Music".text.lg.bold.makeCentered().px16(),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(y / 16)),
              ),
            ),
          ],
        ).px(x / 10).pOnly(top: y / 32, bottom: y / 45),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                "Preview"
                    .text
                    .size(15)
                    .color(Color(0xff2C6AE4))
                    .make()
                    .pOnly(right: x / 64),
                Container(
                  width: 34,
                  height: 34,
                  child: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ).onInkTap(() async {
                    if (pickedFile == null) {
                      showToast(context, "Please Select File");
                      return;
                    }
                    if (playing)
                      player.pause();
                    else
                      player.play(pickedFile!.path!, isLocal: true);

                    playing = !playing;
                  }),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                )
              ],
            ),
          ],
        ).px(x / 8).pOnly(bottom: y / 45),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: ["Almost There".text.bold.lg.makeCentered()],
        ).pOnly(bottom: y / 64).expand()
      ],
    ));
  }

  Future selectFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("Access Granted");
    final result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: false);
    if (result == null) {
      return;
    } else {
      setState(() {
        pickedFile = result.files.single;
      });
      showLoaderDialog(context);
      final path = 'files/$currentUid/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        print(urlDownload);
        audioUrl = urlDownload;
        print(audioUrl);
      });
      //
      _firestore
          .collection('Users')
          .doc(currentUid)
          .set({'audioType': 'userAudio'}, SetOptions(merge: true));
      _firestore
          .collection('Users')
          .doc(currentUid)
          .collection('audioCollection')
          .add({
        'link': urlDownload,
        'timeStamp': DateTime.now(),
      });

      Storage.downloadMusic(urlDownload, prefs);
      Navigator.of(context).pop();
    }

    return 0;
  }
}
