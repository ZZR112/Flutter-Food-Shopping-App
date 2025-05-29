import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:grub_go/service/constand.dart';
import 'package:grub_go/service/database.dart';
import 'package:grub_go/service/shared_pref.dart';
import 'package:grub_go/service/widget_support.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {
  String image, name, price;
  DetailPage({required this.image, required this.name, required this.price});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController addresscontroller = new TextEditingController();
  Map<String, dynamic>? paymentIntent;
  String? name, id, email, address, wallet;
  int quantity = 1, totalprice = 0;

  getthesharedpref() async {
    name = await SharedpreferenceHelper().getUserName();
    id = await SharedpreferenceHelper().getUserId();
    email = await SharedpreferenceHelper().getUserEmail();
    address = await SharedpreferenceHelper().getUserAddress();
    print(id);
    print(email);
    setState(() {});
  }

  getUserWallet() async {
    await getthesharedpref();
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserWalletbyemail(
      email!,
    );
    wallet = "${querySnapshot.docs[0]["Wallet"]}";
    print(wallet);
    setState(() {});
  }

  @override
  void initState() {
    totalprice = int.parse(widget.price);
    getUserWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xffef2b39),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Image.asset(
                widget.image,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.0),
            Text(widget.name, style: AppWidget.HeadlineTextFeildStyle()),
            Text("\₱" + widget.price, style: AppWidget.priceTextFeildStyle()),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                "A cheese pizza is a classic dish made with a baked crust topped with tomato sauce and melted mozzarella cheese. It's simple, savory, and widely loved for its rich, gooey texture and tangy flavor.",
                style: AppWidget.SimpleTextFeildStyle(),
              ),
            ),
            SizedBox(height: 10.0),
            Text("Quantity", style: AppWidget.SimpleTextFeildStyle()),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    quantity = quantity + 1;
                    totalprice = totalprice + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  quantity.toString(),
                  style: AppWidget.boldTextFeildStyle(),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      quantity = quantity - 1;
                      totalprice = totalprice - int.parse(widget.price);
                      setState(() {});
                    }
                  },

                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffef2b39),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.remove, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Color(0xffef2b39),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "\₱" + totalprice.toString(),
                        style: AppWidget.boldWhiteTextFeildStyle(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30.0),
                GestureDetector(
                  onTap: () async {
                    if (address == null) {
                      openBox();
                    } else if (int.parse(wallet!) > totalprice) {
                      int updatedwallet = int.parse(wallet!) - totalprice;
                      await DatabaseMethods().updateUserWallet(
                        updatedwallet.toString(),
                        id!,
                      );
                      String orderId = randomAlphaNumeric(10);
                      Map<String, dynamic> userOrderMap = {
                        "Name": name,
                        "Id": id,
                        "Quantity": quantity.toString(),
                        "Total": totalprice.toString(),
                        "Email": email,
                        "FoodName": widget.name,
                        "FoodImage": widget.image,
                        "OrderId": orderId,
                        "Status": "Pending",
                        "Address": address ?? addresscontroller.text,
                      };
                      await DatabaseMethods().adduserOrderDetails(
                        userOrderMap,
                        id!,
                        orderId,
                      );
                      await DatabaseMethods().addAdminrOrderDetails(
                        userOrderMap,
                        orderId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        (SnackBar(
                          backgroundColor: Colors.greenAccent,
                          content: Text(
                            "Order Placed Successfully!",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Add some money to your Wallet",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 70,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "ORDER NOW",
                          style: AppWidget.WhiteTextFeildStyle(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            String orderId = randomAlphaNumeric(10);
            Map<String, dynamic> userOrderMap = {
              "Name": name,
              "Id": id,
              "Quantity": quantity.toString(),
              "Total": totalprice.toString(),
              "Email": email,
              "FoodName": widget.name,
              "FoodImage": widget.image,
              "OrderId": orderId,
              "Status": "Pending",
              "Address": address ?? addresscontroller.text,
            };
            await DatabaseMethods().adduserOrderDetails(
              userOrderMap,
              id!,
              orderId,
            );
            await DatabaseMethods().addAdminrOrderDetails(
              userOrderMap,
              orderId,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              (SnackBar(
                backgroundColor: Colors.greenAccent,
                content: Text(
                  "Order Placed Successfully!",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              )),
            );
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
                        "Add the Address",
                        style: TextStyle(
                          color: Color(0xff008080),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text("Add Address"),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: addresscontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Address",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      address == addresscontroller.text;
                      await SharedpreferenceHelper().saveUserAddress(
                        addresscontroller.text,
                      );
                      Navigator.pop(contex);
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
