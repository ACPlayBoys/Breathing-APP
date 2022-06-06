// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/home_screen/mdrawer.dart';
import 'package:breathing_app/util/constants.dart';

class MusicScreen extends StatefulWidget {
  MusicModel m;
  MusicScreen({
    Key? key,
    required this.m,
  }) : super(key: key);
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late Razorpay razorpay;

  final String path = "asset/images/shopping/";
  late MusicModel m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<MusicModel> list = [];

  @override
  void initState() {
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerSucess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExtWallet);

    m = widget.m;
    list.add(m);
    list.add(m);
    list.add(m);
    list.add(m);

    super.initState();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_ERMWIEMeuGzC4C",
      "amount": 200, //m.price (add price to music model)
      "name": "Breathe App",
      "description": "Payment for ${m.name}",
      "prefill": {"contact": "2323232323", "email": "shdjsdh@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  handlerSucess() {
    showToast(context, 'Payment Sucessful');
  }

  handlerError() {
    showToast(context, 'Payment Failed');
  }

  handlerExtWallet() {
    showToast(context, 'External Wallet');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: MDrawer(),
        body: SafeArea(
            child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Image.asset(path + "back.png").onInkTap(() {
                    Navigator.of(context).pop();
                  }),
                  Spacer(),
                  Image.asset(path + "search.png").onInkTap(() {
                    Navigator.of(context).pop();
                  }),
                ],
              ).pOnly(top: y / 25, bottom: y / 30).px(x / 24),
              buildContainer(child: Image.asset(m.image).p8()).centered(),
              m.name.text.xl2.bold.makeCentered(),
              "${m.duration} Mins".text.lg.makeCentered(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildContainer(
                      child: Image.asset(path + "playdeep.png").p8()),
                ],
              ),
              "Similar Tracks".text.bold.color(borderColor).make(),
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
                                  Image.asset(
                                      "asset/images/shopping/" + "play.png"),
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
                  .expand(),
            ]),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: y / 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: x / 2.5,
                        height: y / 16,
                        child: "Add to WishList"
                            .text
                            .lg
                            .bold
                            .makeCentered()
                            .px16(),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(y / 16)),
                      ),
                      GestureDetector(
                        onTap: () {
                          openCheckout();
                        },
                        child: Container(
                          width: x / 2.5,
                          height: y / 16,
                          child: "Buy Now".text.lg.bold.makeCentered().px16(),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(y / 16)),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: borderColor.withOpacity(0.1),
                        offset: Offset(0.0, -19.0), //(x,
                        blurRadius: 50.0,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )));
  }
}
