import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/Storage.dart';
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
  bool playing = false;
  List<bool> chips = [false, false, false, false, false, false, false];
  bool chipRecnt = false;
  bool chipPopular = false;
  final AudioPlayer player = AudioPlayer();
  var searchShow = false;
  @override
  void initState() {
    // Storage.getAllMusic();
    if (Storage.audios.value.isEmpty) {
      Storage.getAllMusic(false);
    }
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
          AnimatedCrossFade(
              firstChild: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: x / 5,
                      height: y / 25,
                      child: FilterChip(
                          selected: chips[0],
                          selectedColor: borderColor,
                          onSelected: (bool value) {
                            for (int u = 0; u < chips.length; u++) {
                              if (u == 0) {
                                chips[0] = value;
                              } else {
                                chips[u] = false;
                              }
                            }
                            setState(() {});
                            if (chips[0])
                              Storage.getRecent();
                            else
                              Storage.getAllMusic();
                          },
                          label: "Recent".text.extraBold.make()),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(y / 16)),
                    ).onInkTap(() {}).pOnly(right: x / 64),
                    Container(
                      width: x / 5,
                      height: y / 25,
                      child: FilterChip(
                          selected: chips[1],
                          selectedColor: borderColor,
                          onSelected: (bool value) {
                            for (int u = 0; u < chips.length; u++) {
                              if (u == 1) {
                                chips[1] = value;
                              } else {
                                chips[u] = false;
                              }
                            }
                            setState(() {});
                            if (chips[1])
                              Storage.getPictures();
                            else
                              Storage.getAllMusic();
                          },
                          label: "Pictures".text.extraBold.make()),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(y / 16)),
                    ).pOnly(right: x / 64),
                    Container(
                      width: x / 5,
                      height: y / 25,
                      child: FilterChip(
                          selected: chips[2],
                          selectedColor: borderColor,
                          onSelected: (bool value) {
                            for (int u = 0; u < chips.length; u++) {
                              if (u == 2) {
                                chips[2] = value;
                              } else {
                                chips[u] = false;
                              }
                            }
                            setState(() {});
                            if (chips[2])
                              Storage.getPouplar();
                            else
                              Storage.getAllMusic();
                          },
                          label: "Musics".text.extraBold.make()),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(y / 16)),
                    ).pOnly(right: x / 64),
                    Container(
                      width: x / 5,
                      height: y / 25,
                      child: FilterChip(
                          selected: chips[3],
                          selectedColor: borderColor,
                          onSelected: (bool value) {
                            chipPopular = value;
                            for (int u = 0; u < chips.length; u++) {
                              if (u == 3) {
                                chips[3] = value;
                              } else {
                                chips[u] = false;
                              }
                            }
                            setState(() {});
                            if (chips[3])
                              Storage.getAnimation();
                            else
                              Storage.getAllMusic();
                          },
                          label: "Animations".text.extraBold.make()),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(y / 16)),
                    ).pOnly(right: x / 64),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(path + "search.png").onInkTap(() {
                          searchShow = true;
                          setState(() {});
                        }),
                      ],
                    )
                  ],
                ).px(x / 16),
              ),
              secondChild: TextFormField(
                autofocus: true,
                onChanged: (value) {
                  Storage.getSearch(value.toString());
                },
                onFieldSubmitted: (value) {
                  searchShow = false;
                  setState(() {});
                  Storage.getSearch(value.toString());
                },
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
              crossFadeState: searchShow
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 500)),
          ValueListenableBuilder(
            builder: (context, value, child) {
              List<MusicModel> list = Storage.audios.value;
              if (Storage.audios.value.isEmpty) {
                return CircularProgressIndicator().centered().py24();
              } else {
                return ListView.separated(
                        itemBuilder: ((context, index) {
                          MusicModel m = list[index];
                          return Container(
                            child: Row(
                              children: [
                                buildContainer(
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(m.image),
                                    radius: 30,
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
                                    Image.asset(!playing
                                            ? (path + "play.png")
                                            : (path + "pause.png"))
                                        .onInkTap(() {
                                      playing = !playing;
                                      //setState(() {});
                                      if (playing)
                                        player.play(m.link);
                                      else
                                        player.pause();
                                    }),
                                  ],
                                ).expand()
                              ],
                            ),
                          )
                              .onInkTap(() {
                                playing = false;
                                player.pause();
                                Navigator.of(context)
                                    .push(Routes.createMusicRoute(m,false));
                              })
                              .px(x / 16)
                              .py(y / 128);
                        }),
                        separatorBuilder: (context, index) {
                          return Divider(thickness: 1).px16();
                        },
                        itemCount: Storage.audios.value.length)
                    .py(y / 64)
                    .expand();
              }
            },
            valueListenable: Storage.audios,
          ),
        ])));
  }
}
