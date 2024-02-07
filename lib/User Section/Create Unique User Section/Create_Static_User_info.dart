import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Notification Section/User_Notification_Services.dart';
import '../../Screens/Login_Screen/Login_Screen_main.dart';
import 'Create_Dynamic_User_info.dart';

DateTime currentDate = DateTime.now();
String formattedDate =
    "${currentDate.year}-${currentDate.month}-${currentDate.day}";

Future createStaticDetail(
  BuildContext context,
  String Username,
  String Password,
  String phone,
  String email,
  String Type,
) async {
  try {
    final usernameQuery = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: Username)
        .get();

    final usernameQuery2 = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: Username.toLowerCase())
        .get();

    if (usernameQuery.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Username '$Username' is already used! Please try another.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (usernameQuery2.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg:
            "Username '$Username' is already used in a different case! Please try another.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      await FirebaseFirestore.instance.collection('Users').add(
        {
          'Username': Username,
          'Password': Password,
          'Type': Type,
          'Email_Address': email,
          'Phone_Number': phone,
          'Status': 'Available',
          'Joined_At': formattedDate,
          'Bio': '',
          'State': 'Online',
          'Last_Online': '',
          'Device-Token': await GetDeviceToken(),
        },
      );
      await createDynamicDetail(Username);
      Fluttertoast.showToast(
        msg: "Sign Up Successfully ! Please Login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  } catch (e) {
    print(e);
    Fluttertoast.showToast(
      msg: e.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
