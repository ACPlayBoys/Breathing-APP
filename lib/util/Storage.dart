// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:convert';
import 'dart:io';

import 'package:breathing_app/models/gifdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';

List<XFile> gifFiles = [];

String image1 = "", image2 = "", image3 = "", image4 = "";

class Storage {
  static String gifUrl =
      "https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/images%2Fdefault.gif?alt=media&token=3f062989-ba7f-414c-8098-b29da240fc5a";
  static void uploadGIf(File mal, context) {
    var uuid = Uuid();
    final _firebaseStorage = FirebaseStorage.instance.ref();
    //thumb
    showToast(context, "uploading Gif");

    var firestore = FirebaseFirestore.instance;
    CollectionReference giff = firestore.collection("Gif");
    String name = uuid.v4();
    print(mal.exists());
    final snapshot1 = _firebaseStorage.child('images/$name').putFile(mal);
    snapshot1.whenComplete((() async {
      var thumbUrl = await snapshot1.snapshot.ref.getDownloadURL();

      var gif = {
        "name": name,
        "link": thumbUrl,
      };
      giff.doc(FirebaseAuth.instance.currentUser!.uid).set(gif);
      gifUrl = thumbUrl;

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
        gifUrl = details.link;
        print(details);
      } else {
        print('Data not present in Database..');
      }
    });
  }
}
