// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
//import 'package:breathing_app/models/gifdata.dart';
import 'package:breathing_app/models/gifdata.dart';
import 'package:breathing_app/models/musicmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';

List<XFile> gifFiles = [];

String image1 = "", image2 = "", image3 = "", image4 = "";

class Storage {
  static String userGif = "";
  static List<String> gifPath = [];
  static GifData gifUrl = GifData(
      name: "default",
      link:
          "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/images%2Fdefault.gif?alt=media&token=3f062989-ba7f-414c-8098-b29da240fc5a",
      frames: 19);

  static void setDeafultGif(BuildContext context) {
    GifData gif = GifData(
        name: "default",
        link:
            "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/images%2Fdefault.gif?alt=media&token=3f062989-ba7f-414c-8098-b29da240fc5a",
        frames: 19);
    FirebaseFirestore.instance
        .collection("Gif")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(gif.toMap())
        .then((value) => showToast(context, "Default Gif Added"));

    downloadGif(gif);
  }

  static void uploadGIf(File mal, context, frames) {
    var uuid = Uuid();
    final _firebaseStorage = FirebaseStorage.instance.ref();
    //thumb
    //showToast(context, "uploading Gif");

    var firestore = FirebaseFirestore.instance;
    CollectionReference giff = firestore.collection("Gif");
    String name = FirebaseAuth.instance.currentUser!.uid;
    print(mal.exists());
    final snapshot1 = _firebaseStorage.child('images/$name').putFile(mal);
    snapshot1.whenComplete((() async {
      var thumbUrl = await snapshot1.snapshot.ref.getDownloadURL();

      GifData gif = GifData(
          frames: double.parse(frames.toString()), link: thumbUrl, name: name);
      giff.doc(FirebaseAuth.instance.currentUser!.uid).set(gif.toMap());
      gifUrl = gif;
      downloadGif(gif);

      //showToast(context, "Gif Uploaded");
      //Navigator.of(context).pop();
    }));
  }

  static ValueNotifier giffer = ValueNotifier<int>(0);
  static void getGif() async {
    CollectionReference giff = FirebaseFirestore.instance.collection("Gif");
    giff
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot docSnapshot) async {
      if (docSnapshot.exists) {
        print(docSnapshot.data());
        var json = jsonEncode(docSnapshot.data()); // I am getting stuck here
        GifData details = GifData.fromJson(json) as GifData;
        gifUrl = details;

        print(details);
        giffer.value = 1;
        downloadGif(details);
      } else {
        print('Data not present in Database..');
      }
    });
  }

  static downloadGif(GifData details) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(await Permission.storage.request());
    final gsReference = FirebaseStorage.instance.refFromURL(details.link);
    Directory? appDocDirectory = await getExternalStorageDirectory();
    String path = appDocDirectory!.path + "/currentgif.gif";
    final file = File(path);
    final downloadTask = gsReference.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          GifData local = GifData(
              name: details.name, link: file.path, frames: details.frames);

          prefs.setString('gifData', local.toJson());
          break;
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
  }

  static Future<void> addDummy(context) async {
    List<String> names = ["ny", "downtown", "tokyo", "shanghai"];

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.any);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      int i = 0;
      for (File file in files) {
        Uuid uid = Uuid();
        String name = names[i];
        DocumentReference audioo =
            FirebaseFirestore.instance.collection("allMusic").doc(name);

        final _firebaseStorage = FirebaseStorage.instance.ref();

        final snapshot1 =
            _firebaseStorage.child('shoppingAudio/${name}.mp3').putFile(file);
        showToast(context, "Uplaoding music $i");
        snapshot1.whenComplete((() async {
          var audio = await snapshot1.snapshot.ref.getDownloadURL();
          String thumb = audio;
          MusicModel m = MusicModel(
              type: "animation",
              link: audio,
              duration: "300",
              name: name,
              image: thumb,
              price: 300);

          audioo.set(m.toMap());
        }));
        i++;
        //
      }
    } else {
      // User canceled the picker

    }
  }

  static final audios = ValueNotifier<List<MusicModel>>([]);
  static List<MusicModel> allmusic = [];
  static void getAllMusic([bool bula = true]) async {
    if (bula) {
      audios.value = [];
      allmusic = [];
      audios.notifyListeners();
    }
    FirebaseFirestore.instance
        .collection("allMusic")
        .get()
        .then((var docSnapshot) {
      print(docSnapshot.docs);
      for (var b in docSnapshot.docs) {
        audios.value.add(MusicModel.fromJson(jsonEncode(b.data())));
        allmusic.add(MusicModel.fromJson(jsonEncode(b.data())));
      }

      audios.notifyListeners();
    });
  }

  static void getPictures([bool bula = true]) async {
    audios.value = [];
    allmusic.forEach((element) {
      if (element.type == "picture") audios.value.add(element);
    });
    audios.notifyListeners();
  }

  static void getAnimation([bool bula = true]) async {
    audios.value = [];
    allmusic.forEach((element) {
      if (element.type == "animation") audios.value.add(element);
    });
    audios.notifyListeners();
  }

  static void getMusic([bool bula = true]) async {
    audios.value = [];
    allmusic.forEach((element) {
      if (element.type == "music") audios.value.add(element);
    });
    audios.notifyListeners();
  }

  static void getRecent() async {
    audios.value = [];
    audios.notifyListeners();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("recents")
        .orderBy("time")
        .get()
        .then((var docSnapshot) {
      print(docSnapshot.docs);
      for (var b in docSnapshot.docs) {
        print(jsonEncode(b.data()));
        audios.value.add(MusicModel.fromJson(jsonEncode(b.data())));
      }
      audios.notifyListeners();
    });
  }

  static void getPouplar() async {
    audios.value = [];
    audios.notifyListeners();
    FirebaseFirestore.instance
        .collection("popular")
        .get()
        .then((var docSnapshot) {
      print(docSnapshot.docs);
      for (var b in docSnapshot.docs) {
        audios.value.add(MusicModel.fromJson(jsonEncode(b.data())));
      }
      audios.notifyListeners();
    });
  }

  static void getSearch(String name) async {
    audios.value = [];
    audios.notifyListeners();

    allmusic.forEach((music) {
      if (music.name.toLowerCase().contains(name.toLowerCase()))
        audios.value.add(music);
    });
    audios.notifyListeners();
  }

  static final whishlist = ValueNotifier<List<MusicModel>>([]);
  static List<MusicModel> allwhishlist = [];
  static void getWishlist() async {
    whishlist.value = [];
    whishlist.notifyListeners();
    allwhishlist = [];
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishlist')
        .get()
        .then((var docSnapshot) {
      print(docSnapshot.docs);
      for (var b in docSnapshot.docs) {
        whishlist.value.add(MusicModel.fromJson(jsonEncode(b.data())));
        allwhishlist.add(MusicModel.fromJson(jsonEncode(b.data())));
      }
      whishlist.notifyListeners();
    });
  }

  static void searchWishlist(String name) {
    whishlist.value = [];
    whishlist.notifyListeners();
    allwhishlist.forEach((music) {
      if (music.name.toLowerCase().contains(name.toLowerCase()))
        whishlist.value.add(music);
    });
    whishlist.notifyListeners();
  }

  static downloadMusic(String Url, SharedPreferences prefs) async {
    final gsReference = FirebaseStorage.instance.refFromURL(Url);
    print(await Permission.storage.request());
    Directory? appDocDirectory = await getExternalStorageDirectory();
    String path = appDocDirectory!.path + "/currentMusic.mp3";
    final file = File(path);
    final downloadTask = gsReference.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          print(file.path);

          prefs.setString('audioUrl', file.path);
          break;
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
