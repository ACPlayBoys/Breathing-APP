import 'package:flutter/material.dart';
import 'dart:math' as math;

String email = "";
final borderColor = Color(0xff2C6AE4);
final kInnerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Colors.white),
  borderRadius: BorderRadius.circular(32),
);
// border for all 3 colors
final kGradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
    Color(0xfffb70cf),
    Color(0xffffD29B),
    Color(0xffb5e0fd),
  ]),
  borderRadius: BorderRadius.circular(32),
);
Widget buildContainer({child}) {
  return ClipOval(
    clipBehavior: Clip.antiAlias,
    child: Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0), //width of the border
        child: ClipOval(
          clipBehavior: Clip.antiAlias,
          child: Container(
            // this height forces the container to be a circle
            child: child,

            decoration: kInnerDecoration,
          ),
        ),
      ),
      decoration: kGradientBoxDecoration,
    ),
  );
}

void showToast(BuildContext context, String msg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg.toString()),
      duration: Duration(seconds: 2),
    ),
  );
}

Map userDetails=Map();
