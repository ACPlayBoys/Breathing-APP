import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/Storage.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyItems extends StatefulWidget {
  const MyItems({Key? key}) : super(key: key);

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  final String path = "asset/images/shopping/";
  bool playing = false;
  List<bool> chips = [true, false];
  bool chipRecnt = false;
  bool chipPopular = false;
  final AudioPlayer player = AudioPlayer();
  var searchShow = false;
  @override
  void initState() {
    // Storage.getAllMusic();
    if (Storage.audios2.value.isEmpty) {
      Storage.getPurchases();
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
              "My Items".text.xl3.bold.make(),
              Spacer(),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02)
            ],
          ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
          AnimatedCrossFade(
              firstChild: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: x / 2.5,
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
                              Storage.getPurchases();
                            else
                              Storage.getPurchases();
                          },
                          label: "My Purchases".text.extraBold.make()),
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
                              Storage.getWishlist();
                            else
                              Storage.getPurchases();
                          },
                          label: "WishList".text.extraBold.make()),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        path + "search.png",
                        color: Color.fromARGB(105, 0, 0, 0),
                      ).pOnly(right: 10),
                      "Search Wishlist".text.make(),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              searchShow = false;
                            });
                          },
                          icon: Icon(Icons.close,
                              color: Color.fromARGB(105, 0, 0, 0)))
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
              List<MusicModel> list = Storage.audios2.value;
              if (Storage.audios2.value.isEmpty) {
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
                                    .push(Routes.createMusicRoute(m,true));
                              })
                              .px(x / 16)
                              .py(y / 128);
                        }),
                        separatorBuilder: (context, index) {
                          return Divider(thickness: 1).px16();
                        },
                        itemCount: Storage.audios2.value.length)
                    .py(y / 64)
                    .expand();
              }
            },
            valueListenable: Storage.audios2,
          ),
        ])));
  }
}
