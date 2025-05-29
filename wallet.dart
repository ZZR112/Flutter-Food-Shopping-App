import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:grub_go/service/constand.dart';
import 'package:grub_go/service/database.dart';
import 'package:grub_go/service/shared_pref.dart';
import 'package:grub_go/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  TextEditingController amountcontroller = new TextEditingController();
  Map<String, dynamic>? paymentIntent;
  String? email, wallet, id;

  getthesharedpref() async {
    email = await SharedpreferenceHelper().getUserEmail();
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
  }

  getUserWallet() async {
    await getthesharedpref();

    email = await SharedpreferenceHelper().getUserEmail();
    id = await SharedpreferenceHelper().getUserId();
    print("🔍 SharedPrefs → id = $id, email = $email");
    setState(() {});

    try {
      walletStream = await DatabaseMethods().getUserTransactions(id!);
      QuerySnapshot querySnapshot = await DatabaseMethods()
          .getUserWalletbyemail(email!);

      wallet = "${querySnapshot.docs[0]["Wallet"]}";
      print(wallet);
      setState(() {});
    } catch (e) {
      print("Error fetching wallet data: $e");
    }
  }

  @override
  void initState() {
    getUserWallet();
    super.initState();
  }

  Stream? walletStream;

  Widget allTransactions() {
    return StreamBuilder(
      stream: walletStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                    bottom: 20.0,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        ds["Date"],
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        children: [
                          Text("Amount added to wallet"),
                          Text(
                            "\₱" + ds["Amount"],
                            style: TextStyle(
                              color: Color(0xffef2b39),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          wallet == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Wallet",
                          style: AppWidget.HeadlineTextFeildStyle(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xFFececf8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20.0),
                            Container(
                              margin: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Material(
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "images/wallet.png",
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 50.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your Wallet",
                                            style:
                                                AppWidget.boldTextFeildStyle(),
                                          ),
                                          Text(
                                            "\₱" + wallet!,
                                            style:
                                                AppWidget.HeadlineTextFeildStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      makePayment("100");
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black45,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\₱100",
                                          style:
                                              AppWidget.priceTextFeildStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      makePayment("50");
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black45,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\₱50",
                                          style:
                                              AppWidget.priceTextFeildStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      makePayment("200");
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black45,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\₱200",
                                          style:
                                              AppWidget.priceTextFeildStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.0),
                            GestureDetector(
                              onTap: () {
                                openBox();
                                makePayment(amountcontroller.text);
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0xffef2b39),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Add Money",
                                    style: AppWidget.boldWhiteTextFeildStyle(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Your Transactions",
                                      style: AppWidget.boldTextFeildStyle(),
                                    ),
                                    SizedBox(height: 20.0),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                          3,

                                      child: allTransactions(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'PHP');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan',
            ),
          )
          .then((value) {});
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception: $e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async {
            int updatedwallet = int.parse(wallet!) + int.parse(amount);
            await DatabaseMethods().updateUserWallet(
              updatedwallet.toString(),
              id!,
            );
            await getUserWallet();
            setState(() {});
            DateTime now = DateTime.now();
            String formattedDate = DateFormat("dd MMM").format(now);
            Map<String, dynamic> userTransactions = {
              "Amount": amount,
              "Date": formattedDate,
            };
            await DatabaseMethods().addUserTransaction(userTransactions, id!);

            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            Text("Payment Successfull"),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
            paymentIntent = null;
          })
          .onError((error, stackTrace) {
            print("Error is :---> $error $StackTrace");
          });
    } on StripeException catch (e) {
      print("Error is: ---> $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text("Cancelled")),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculateAmount = (int.parse(amount) * 100);
    return calculateAmount.toString();
  }

  Future openBox() => showDialog(
    context: context,
    builder:
        (contex) => AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(contex);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(width: 30.0),
                      Text(
                        "Add amount",
                        style: TextStyle(
                          color: Color(0xff008080),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text("Enter Amount"),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: amountcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Amount",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      makePayment(amountcontroller.text);
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF008080),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
