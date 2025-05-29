import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  Future adduserDetails(Map<String, dynamic> userinfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userinfoMap);
  }

  Future adduserOrderDetails(
    Map<String, dynamic> userOrderMap,
    String id,
    String orderid,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Orders")
        .doc(orderid)
        .set(userOrderMap);
  }

  Future addAdminrOrderDetails(
    Map<String, dynamic> userOrderMap,
    String orderid,
  ) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(orderid)
        .set(userOrderMap);
  }

  Future<Stream<QuerySnapshot>> getUserOrders(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Orders")
        .snapshots();
  }

  Future<QuerySnapshot> getUserWalletbyemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future updateUserWallet(String amount, String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).update({
      "Wallet": amount,
    });
  }

  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .where("Status", isEqualTo: "Pending")
        .snapshots();
  }

  Future updateAdminOrder(String id) async {
    return await FirebaseFirestore.instance.collection("Orders").doc(id).update(
      {"Status": "Delivered"},
    );
  }

  Future updateUserOrder(String userid, String docid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .collection("Orders")
        .doc(docid)
        .update({"Status": "Delivered"});
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }

  Future addUserTransaction(
    Map<String, dynamic> userOrderMap,
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Transaction")
        .add(userOrderMap);
  }

  Future<Stream<QuerySnapshot>> getUserTransactions(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Transaction")
        .snapshots();
  }

  Future<QuerySnapshot> search(String updatename) async {
    return await FirebaseFirestore.instance
        .collection("Food")
        .where("SearchKey", isEqualTo: updatename.substring(0, 1).toUpperCase())
        .get();
  }
}
