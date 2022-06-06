// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:convert';
import 'dart:io';

//import 'package:breathing_app/models/gifdata.dart';
import 'package:breathing_app/models/gifdata.dart';
import 'package:breathing_app/models/musicmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';

List<XFile> gifFiles = [];

String image1 = "", image2 = "", image3 = "", image4 = "";

class Storage {
  static List<String> gifPath = ["", "", "", "", "", "", "", "", "", ""];
  static GifData gifUrl = GifData(
      name: "default",
      link:
          "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/images%2Fdefault.gif?alt=media&token=3f062989-ba7f-414c-8098-b29da240fc5a",
      frames: 3);

  static void setDeafultGif() {
    GifData gif = GifData(
        name: "default",
        link:
            "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/images%2Fdefault.gif?alt=media&token=3f062989-ba7f-414c-8098-b29da240fc5a",
        frames: 3);
    FirebaseFirestore.instance
        .collection("Gif")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(gif.toMap());
  }

  static void uploadGIf(File mal, context, frames) {
    var uuid = Uuid();
    final _firebaseStorage = FirebaseStorage.instance.ref();
    //thumb
    showToast(context, "uploading Gif");

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

      showToast(context, "Gif Uploaded");
    }));
  }

  static void getGif() {
    CollectionReference giff = FirebaseFirestore.instance.collection("Gif");
    giff
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot docSnapshot) {
      if (docSnapshot.exists) {
        print(docSnapshot.data());
        var json = jsonEncode(docSnapshot.data()); // I am getting stuck here
        GifData details = GifData.fromJson(json) as GifData;
        gifUrl = details;
        print(details);
      } else {
        print('Data not present in Database..');
      }
    });
  }

  static Future<void> addDummy(context) async {
    // List<String> names = [
    //   "Rajsthan mist",
    //   "Kashmiri Snow",
    //   "Marathi Rain",
    //   "Punjabi Thand",
    //   "Chennai Express",
    //   "Bihari Chai"
    // ];

    // FilePickerResult? result = await FilePicker.platform
    //     .pickFiles(allowMultiple: true, type: FileType.audio);
    // if (result != null) {
    //   List<File> files = result.paths.map((path) => File(path!)).toList();
    //   int i = 0;
    //   for (File file in files) {
    //     Uuid uid = Uuid();
    //     String name = names[i];
    //     DocumentReference audioo =
    //         FirebaseFirestore.instance.collection("popular").doc(name);

    //     final _firebaseStorage = FirebaseStorage.instance.ref();

    //     final snapshot1 =
    //         _firebaseStorage.child('shoppingAudio/${name}.mp3').putFile(file);
    //     showToast(context, "Uplaoding music $i");
    //     snapshot1.whenComplete((() async {
    //       var audio = await snapshot1.snapshot.ref.getDownloadURL();
    //       String thumb =
    //           "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/shoppingImage%2Frajasthan.png?alt=media&token=427e1a1a-6c6b-499c-a649-3af2f0b5fafe";
    //       MusicModel m = MusicModel(
    //           link: audio, duration: "300", name: name, image: thumb);

    //       audioo.set(m.toMap());
    //     }));
    //     i++;
    //     //
    //   }
    // } else {
    //   // User canceled the picker

    // }
  }

  static final audios = ValueNotifier<List<MusicModel>>([]);
  static List<MusicModel> allmusic = [];
  static void getAllMusic() async {
    audios.value = [];
    audios.notifyListeners();
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
        .collection('Wishlist')
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
}
