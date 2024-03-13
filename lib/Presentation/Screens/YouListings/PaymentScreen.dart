import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../Themes/Themes.dart';


class PaymentScreen extends StatefulWidget {
  final String title;
  final String employeerName;
  final String freelancerEmail;
  final String freelancername;
  final String proposedPrice;
  final String completionDate;
  final String employeerEmail;
  const PaymentScreen(
      {Key? key,
      required this.title,
      required this.employeerName,
      required this.freelancerEmail,
      required this.freelancername,
      required this.proposedPrice,
      required this.completionDate,
      required this.employeerEmail})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  late Razorpay _razorpay;
bool isFinished=false;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');


    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_w8v5KuRWJ8TzJI',
      'amount': num.parse(widget.proposedPrice) * 100,
      'name': '${widget.freelancername}',
      'description': '${widget.freelancerEmail}',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9265235635', 'email': '${widget.employeerEmail}'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      print('ERROR->>>>>>>>>>$e');
    }
  }

//*************************

  // List<PaymentItem> paymentItems = [];
  // bool isCompleted = false;
  // void onGooglePayResult(res) {
  //   setState(() {
  //     isCompleted = true;
  //   });
  //   final String dateformat = DateFormat('dd-MM-y').format(DateTime.now());
  //   final String format = DateFormat('hh:mm a').format(DateTime.now());
  //   FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(widget.freelancerEmail)
  //       .collection("Completed")
  //       .doc(widget.title)
  //       .update({"PaymentStatus": "Completed"});
  //   FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(widget.employeerEmail)
  //       .collection("Completed")
  //       .doc(widget.title)
  //       .update({"PaymentStatus": "Completed"});
  //   FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(widget.freelancerEmail)
  //       .collection("Notification")
  //       .doc("Chat ${widget.employeerEmail}")
  //       .set({
  //     "Message":
  //         "You have be paid by ${widget.employeerName},Amount: Rs.${widget.proposedPrice}",
  //     "MarkAsRead": false,
  //     "Time": DateTime.now().microsecondsSinceEpoch,
  //     "Time1": format,
  //     "Type": "Chat",
  //     "Applier": widget.freelancername,
  //     "Client": widget.employeerName,
  //     "Title": widget.title,
  //     "ApplierEmail": widget.employeerEmail,
  //     "ClientEmail": widget.freelancerEmail
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.title),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Freelancer",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.freelancername),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Email",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.freelancerEmail),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Employeer",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.employeerName),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Completion Date",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.completionDate),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Price",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            Text(widget.proposedPrice),
            const SizedBox(
              height: 40,
            ),
            // isCompleted
            //     ?
            // MaterialButton(
            //         height: 50,
            //         minWidth: double.infinity,
            //         color: Colors.black,
            //         onPressed: () {
            //           openCheckout();
            //           Fluttertoast.showToast(msg: "Complete");
            //         },
            //         child: Text(
            //           "Pay",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            Center(
              child: SwipeableButtonView(
                buttonText: 'Slide to Pay | INR ${widget.proposedPrice}',
                buttonWidget: Container(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),),
                activeColor: Color(0xFF009C41),
                isFinished: isFinished,
                onWaitingProcess: () {
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      isFinished = true;
                    });
                  });
                },
                onFinish: () async {
                 openCheckout();
                  //TODO: For reverse ripple effect animation
                  setState(() {
                    isFinished = false;
                  });
                },
              ),
            ),

                // : GooglePayButton(
                //     paymentConfigurationAsset: "gpay.json",
                //     onPressed: () {},
                //     width: double.infinity,
                //     height: 50,
                //     onPaymentResult: onGooglePayResult,
                //     paymentItems: paymentItems)
          ],
        ),
      )),
    );
  }
}
