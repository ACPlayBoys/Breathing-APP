import 'dart:convert';

import 'package:breathing_app/models/musicmodel.dart';
import 'package:breathing_app/screen/Shopping/music_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:breathing_app/screen/payments/payDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../../util/routes.dart';

class StripeScreen extends StatefulWidget {
  MusicModel m;
  String pay;
  StripeScreen({Key? key, required this.m, required this.pay})
      : super(key: key);

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  late User u;
  final GlobalKey<ScaffoldState> _payScaffoldKey = GlobalKey<ScaffoldState>();
  final String path = "asset/images/home/";

  Map<String, dynamic>? paymentIData;

  @override
  void initState() {
    // TODO: implement initState
    u = FirebaseAuth.instance.currentUser!;

    print(widget.m.name);
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
              "Stripe".text.xl3.bold.makeCentered(),
            ],
          ).pOnly(top: y / 24, bottom: y / 8).px(x / 24),
          'Order Details'.text.xl3.bold.make(),
          SizedBox(
            height: 50,
          ),
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
          Spacer(),
          GestureDetector(
            onTap: makePayment,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(y / 16)),
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  'Pay With'.text.xl3.bold.make(),
                  Container(
                    width: 100,
                    height: 40,
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/internship-df344.appspot.com/o/Stripe_logo%2C_revised_2016.png?alt=media&token=d217f811-d30f-4ee8-8a24-835c242aec56'),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIData = await createPaymentInt('${widget.m.price}', 'INR');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Breathe App',
          merchantCountryCode: 'IND',
          paymentIntentClientSecret: paymentIData!['client_secret'],
        ),
      );

      dispPaySheet();
    } catch (e) {
      print(e.toString());
    }
  }

  dispPaySheet() async {
    try {
      var response = await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
              clientSecret: paymentIData!['client_secret'],
              confirmPayment: true));

      print('payment successful');
      print('${u.uid} && ${widget.pay}');
      if (widget.pay == 'subscribe') {
        Map<String, dynamic> paymentMap = {
          'adminSubscription': false,
          'buyDate': DateTime.now().millisecondsSinceEpoch,
          'endDate': DateTime(
                  DateTime.now().year,
                  DateTime.now().month +
                      (widget.m.name == '3 Months Plan'
                          ? 3
                          : widget.m.name == '6 Months Plan'
                              ? 6
                              : 12),
                  DateTime.now().day)
              .millisecondsSinceEpoch,
          'buyMonth': DateFormat('MM-yyyy').format(DateTime.now()),
          'expMonth': DateFormat('MM-yyyy').format(DateTime(
              DateTime.now().year,
              DateTime.now().month +
                  (widget.m.name == '3 Months Plan'
                      ? 3
                      : widget.m.name == '6 Months Plan'
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
        Navigator.of(context).push(Routes.createSchedulingRoute());
      } else {
        Map<String, dynamic> paymentMap = {
          'orderId': paymentIData!['id'],
          'customer name': u.displayName,
          'payer id': u.uid,
          'payment id': 'pay_' + paymentIData!['id'],
          'Total amount': widget.m.price,
          'product name': widget.m.name,
          'time': DateTime.now().millisecondsSinceEpoch,
          'status': 'Success'
        };
        FirebaseFirestore.instance
            .collection('payments')
            .doc(paymentIData!['id'])
            .set(paymentMap, SetOptions(merge: true));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MusicScreen(
                      m: widget.m,
                    )));
      }
      setState(() {
        paymentIData = null;
      });
    } on StripeException catch (e) {
      print(e.toString());
    }
  }

  createPaymentInt(String amt, String Curr) async {
    try {
      Map<String, dynamic> body = {
        'amount': calcAmt(amt),
        'currency': Curr,
        'payment_method_types[]': 'card',
      };
      var resp = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51LAOxASHNhuzOJlfer7vUYHEa4QJRG3lMjrXiujCZBhLDNoO06JiIQ1ImQTnxSHPV5rnEOKY6DxpQjgVoY2kicZr00WOyaRXU8',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(resp.body.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  calcAmt(String amt) {
    final price = int.parse(amt) * 100;
    return price.toString();
  }
}
