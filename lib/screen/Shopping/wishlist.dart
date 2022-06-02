import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class WishList extends StatefulWidget {
  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final String path = "asset/images/shopping/";

  List<MusicModel> list = [];

  @override
  void initState() {
    MusicModel m = MusicModel(
        duration: "300", name: "Rajashtan Mist", image: path + "rajasthan.png");
    list.add(m);
    list.add(m);
    list.add(m);
    list.add(m);

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Material(
      child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Image.asset(path + "back.png").onInkTap(() {
              Navigator.of(context).pop();
            }),
            Spacer(),
            "Wishlist".text.xl3.bold.make(),
            Spacer(),
          ],
        ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
        Container(
          height: y / 20,
          child: TextField(
            decoration: InputDecoration(
              label: Row(
                children: [
                  Image.asset(
                    path + "search.png",
                    color: Color.fromARGB(105, 0, 0, 0),
                  ).pOnly(right: 10),
                  "Search Wishlist".text.make(),
                ],
              ).px4(),
              contentPadding: EdgeInsets.only(left: 10, right: 20),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(y / 20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(y / 20)),
            ),
          ),
        ).px(x / 16),
        ListView.separated(
                itemBuilder: ((context, index) {
                  MusicModel m = list[index];
                  return Container(
                    child: Row(
                      children: [
                        buildContainer(
                          child: Image.asset(
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
                            Image.asset(path + "play.png"),
                          ],
                        ).expand()
                      ],
                    ),
                  ).px(x / 16).py(y / 128);
                }),
                separatorBuilder: (context, index) {
                  return Divider(thickness: 1).px16();
                },
                itemCount: list.length)
            .py(y / 64)
            .expand(),
      ])),
    );
  }
}
