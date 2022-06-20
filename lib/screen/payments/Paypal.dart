import 'package:breathing_app/screen/payments/payDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/musicmodel.dart';
import '../../util/routes.dart';
import '../Shopping/music_page.dart';
import 'PaypalPayment.dart';

class Paypal extends StatefulWidget {
  MusicModel m;
  String pay;
  Paypal({Key? key, required this.m, required this.pay}) : super(key: key);

  @override
  State<Paypal> createState() => _PaypalState();
}

class _PaypalState extends State<Paypal> {
  final GlobalKey<ScaffoldState> _payScaffoldKey = GlobalKey<ScaffoldState>();
  final String path = "asset/images/home/";
  late User u;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _payScaffoldKey,
      drawer: payDrawer(
        m: widget.m,
        pay: widget.pay,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(path + "menu.png").onInkTap(() {
                _payScaffoldKey.currentState?.openDrawer();
              }),
              "PayPal".text.xl3.bold.makeCentered(),
            ],
          ).pOnly(top: y / 24, bottom: y / 8).px(x / 24),
          'Order Details'.text.xl3.bold.make(),
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        width: 300,
                        child: Row(
                          children: [
                            'Product Name'.text.xl.make(),
                            Spacer(),
                            '${widget.m.name}'.text.xl.make(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(''),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        width: 300,
                        child: Row(
                          children: [
                            'Total Amount'.text.xl.make(),
                            Spacer(),
                            'Rs. ${widget.m.price.toString()}'.text.xl.make()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalPayment(
                          onFinish: (number) async {
                            // payment done
                            print('order id: ' + number);
                            if (widget.pay == 'subscribe') {
                              Map<String, dynamic> paymentMap = {
                                'adminSubscription': false,
                                'buyDate':
                                    DateTime.now().millisecondsSinceEpoch,
                                'endDate': DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month +
                                            (widget.m.name == '3 Months Plan'
                                                ? 3
                                                : widget.m.name ==
                                                        '6 Months Plan'
                                                    ? 6
                                                    : 12),
                                        DateTime.now().day)
                                    .millisecondsSinceEpoch,
                                'buyMonth': DateFormat('MM-yyyy')
                                    .format(DateTime.now()),
                                'expMonth': DateFormat('MM-yyyy').format(
                                    DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month +
                                            (widget.m.name == '3 Months Plan'
                                                ? 3
                                                : widget.m.name ==
                                                        '6 Months Plan'
                                                    ? 6
                                                    : 12),
                                        DateTime.now().day)),
                                'subMonths': widget.m.name == '3 Months Plan'
                                    ? 3
                                    : widget.m.name == '6 Months Plan'
                                        ? 6
                                        : 12,
                                'subscription': true,
                                'rewards': true
                              };
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(u.uid)
                                  .set(paymentMap, SetOptions(merge: true));
                              Navigator.of(context)
                                  .push(Routes.createSchedulingRoute());
                            } else {
                              Map<String, dynamic> paymentMap = {
                                'orderId': number,
                                'customer name': u.displayName,
                                'payer id': u.uid,
                                'payment id': 'pay_' + number,
                                'Total amount': widget.m.price,
                                'product name': widget.m.name,
                                'time': DateTime.now().millisecondsSinceEpoch,
                                'status': 'Success'
                              };
                              FirebaseFirestore.instance
                                  .collection('payments')
                                  .doc(number)
                                  .set(paymentMap, SetOptions(merge: true));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MusicScreen(
                                            m: widget.m,
                                          )));
                            }
                          },
                          m: widget.m,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(y / 16)),
                    margin: EdgeInsets.only(
                        left: 70, right: 70, bottom: 10, top: 260),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        'Pay With  '.text.xl3.bold.make(),
                        Container(
                          width: 100,
                          height: 40,
                          child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/580b57fcd9996e24bc43c530.png?alt=media&token=e6ce6d25-c484-413e-890e-6abb31967314'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
