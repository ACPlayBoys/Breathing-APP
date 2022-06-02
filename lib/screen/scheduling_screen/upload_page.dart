// ignore_for_file: prefer_const_constructors, unnecessary_new
import 'dart:io';

import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/gifgenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Upload extends StatelessWidget {
  var selectedValue;

  Upload({Key? key}) : super(key: key);
  final String path = "asset/images/schedule/";
  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Spacer(),
              "Upload Your Images".text.xl3.bold.make(),
              Spacer()
            ],
          ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
          Image.asset(
            path + "upload.png",
            height: y / 4,
            fit: BoxFit.fitWidth,
          ).centered().pOnly(bottom: y / 30).px(x / 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: x / 6,
                height: x / 6,
                child: image1.isEmptyOrNull
                    ? Icon(
                        Icons.add,
                        color: Colors.blue,
                      )
                    : CircleAvatar(
                        radius: x / 6,
                        backgroundImage: Image.file(File(image1)).image,
                      ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(x / 6)),
              ).onInkTap(() {
                showPicker(context, 0);
              }),
              Container(
                width: x / 6,
                height: x / 6,
                child: image2.isEmptyOrNull
                    ? Icon(
                        Icons.add,
                        color: Colors.blue,
                      )
                    : CircleAvatar(
                        radius: x / 6,
                        backgroundImage: Image.file(File(image2)).image,
                      ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(x / 6)),
              ).onInkTap(() {
                showPicker(context, 1);
              }),
              Container(
                width: x / 6,
                height: x / 6,
                child: image3.isEmptyOrNull
                    ? Icon(
                        Icons.add,
                        color: Colors.blue,
                      )
                    : CircleAvatar(
                        radius: x / 6,
                        backgroundImage: Image.file(File(image3)).image,
                      ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(x / 6)),
              ).onInkTap(() {
                showPicker(context, 2);
              }),
              Container(
                width: x / 6,
                height: x / 6,
                child: image4.isEmptyOrNull
                    ? Icon(
                        Icons.add,
                        color: Colors.blue,
                      )
                    : CircleAvatar(
                        radius: x / 6,
                        backgroundImage: Image.file(File(image4)).image,
                      ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(x / 6)),
              ).onInkTap(() {
                showPicker(context, 3);
              }),
            ],
          ).px(x / 8).pOnly(bottom: y / 45),
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
                    child: InkWell(
                      radius: 37,
                      onTap: () {},
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ).onInkTap(() async {
                        makegif(context);
                      }),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                  )
                ],
              ),
            ],
          ).px(x / 8).pOnly(bottom: y / 45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: x / 3,
                height: y / 16,
                child: "Use Default".text.lg.bold.makeCentered().px16(),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(y / 16)),
              ),
              Container(
                width: x / 3,
                height: y / 16,
                child: "Submit".text.lg.bold.makeCentered().px16(),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(y / 16)),
              ),
            ],
          ).px(x / 10).pOnly(bottom: y / 45)
        ],
      ),
    ));
  }

  List<DropdownMenuItem<String>> get gender {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "male"),
      DropdownMenuItem(child: Text("Female"), value: "female"),
    ];
    return menuItems;
  }

  void showCustomDialog(BuildContext context, File gifPath) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: y / 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Preview"
                      .text
                      .xl
                      .bold
                      .color(Colors.black)
                      .makeCentered()
                      .pOnly(bottom: y / 32),
                  SizedBox(
                      height: y / 6,
                      child: Image.file(
                        gifPath,
                        fit: BoxFit.fill,
                      )).pOnly(bottom: y / 32),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: constraints.maxWidth / 3,
                            height: y / 20,
                            child: "cancel".text.bold.makeCentered(),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(y / 20),
                                border: Border.all(color: Colors.blue)),
                          ).onInkTap(() {
                            Navigator.of(context).pop();
                          }),
                          Container(
                            width: constraints.maxWidth / 3,
                            height: y / 20,
                            child: "Set as GIf".text.bold.makeCentered(),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(y / 20),
                                border: Border.all(color: Colors.blue)),
                          ).onInkTap(() {
                            Storage.uploadGIf(gifPath, context);
                          })
                        ],
                      );
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
            ));
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  showPicker(context, int i) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Please Pick an Image".text.make(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                          _getFromGallery(true, i);
                        }),
                        child: "Camera".text.make()),
                    TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                          _getFromGallery(false, i);
                        }),
                        child: "Gallery".text.make()),
                  ],
                )
              ],
            ).p8(),
          );
        });
  }

  _getFromGallery(bool camera, int i) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    print(pickedFile!.path);
    if (pickedFile != null) {
      switch (i) {
        case 0:
          image1 = (pickedFile.path);
          return;
        case 1:
          image2 = (pickedFile.path);
          return;
        case 2:
          image3 = (pickedFile.path);
          return;
        case 3:
          image4 = (pickedFile.path);
          return;
      }
    }
  }

  makegif(context) async {
    if (image1.isEmptyOrNull) {
      showToast(context, "Please Select First Image");
      return;
    }
    if (image2.isEmptyOrNull) {
      showToast(context, "Please Select Second Image");
      return;
    }
    if (image3.isEmptyOrNull) {
      showToast(context, "Please Select Third Image");
      return;
    }
    if (image4.isEmptyOrNull) {
      showToast(context, "Please Select Fourth Image");
      return;
    }

    showLoaderDialog(context);
    gifFiles.add(XFile(image1));
    gifFiles.add(XFile(image2));
    gifFiles.add(XFile(image3));
    gifFiles.add(XFile(image4));
    File gifPath = await genrategiff(gifFiles);
    Navigator.of(context).pop();
    print(gifPath);
    showCustomDialog(context, gifPath);
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
