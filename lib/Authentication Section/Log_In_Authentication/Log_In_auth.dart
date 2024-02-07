import 'package:echofy_app/User%20Section/Authenticate%20User%20Section/Get_User_Identification.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> loginAuthentication(String username, String password) async {
  // Check if the username exists in Firestore
  final querySnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('Username', isEqualTo: username)
      .get();

  if (querySnapshot.docs.isEmpty) {
    Fluttertoast.showToast(
      msg: "Username Not found ! Please Check for Case sensitive",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    final userDoc = querySnapshot.docs.first;
    final storedPassword = userDoc.data()['Password'];

    if (password != storedPassword) {
      Fluttertoast.showToast(
        msg: "Password is incorrect",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      final result = await getUserIdByUsername(username);

      if (result != 'null') {
        return result;
      }
    }
  }
  return 'null';
}
