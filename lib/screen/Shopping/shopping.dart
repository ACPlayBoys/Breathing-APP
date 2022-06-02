import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Shopping extends StatefulWidget {
  const Shopping({Key? key}) : super(key: key);

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  final String path = "asset/images/shopping/";
  List<MusicModel> list = [];
  @override
  void initState() {
    MusicModel mu = MusicModel(
        duration: "300", name: "Rajashtan Mist", image: path + "rajasthan.png");
    list.add(mu);
    list.add(mu);
    list.add(mu);
    list.add(mu);

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              "Shopping".text.xl3.bold.make(),
              Spacer(),
              Image.asset(path + "musiclist.png").onInkTap(() {
                Navigator.of(context).push(Routes.createWishlistRoute());
              }),
            ],
          ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
          Row(
            children: [
              Container(
                width: x / 5,
                height: y / 25,
                child: "Recent".text.extraBold.makeCentered(),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(y / 16)),
              ).pOnly(right: x / 32),
              Container(
                width: x / 5,
                height: y / 25,
                child: "Popular".text.extraBold.makeCentered(),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(y / 16)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(path + "search.png"),
                ],
              ).expand()
            ],
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
                    )
                        .onInkTap(() {
                          Navigator.of(context)
                              .push(Routes.createMusicRoute(m));
                        })
                        .px(x / 16)
                        .py(y / 128);
                  }),
                  separatorBuilder: (context, index) {
                    return Divider(thickness: 1).px16();
                  },
                  itemCount: list.length)
              .py(y / 64)
              .expand(),
        ])));
  }
}
