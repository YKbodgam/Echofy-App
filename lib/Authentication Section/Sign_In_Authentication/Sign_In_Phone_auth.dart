import 'package:echofy_app/Screens/Otp_Verify_Screen/Otp_Screen_main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
bool isResendingPhoneVerification = false;

void Phone_Number_Auth(BuildContext context, String phoneNumber) {
  // Firebase Auth requires
  auth.verifyPhoneNumber(
    phoneNumber: "+91$phoneNumber",
    verificationCompleted: (_) {
      Fluttertoast.showToast(
        msg: "Sign In successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        // Handle invalid phone number
        Fluttertoast.showToast(
          msg: "Invalid Phone Number Please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'too-many-requests') {
        // Handle too many requests from this device
        Fluttertoast.showToast(
          msg: "Due To Too Many Requests Number is Blocked, please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Handle other verification failures
        Fluttertoast.showToast(
          msg: "Some Error $e has Occured, please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    },
    codeSent: (String verificationId, int? token) {
      Fluttertoast.showToast(
        msg: "Verification code sent !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            verification_Id: verificationId,
            Phone_no: phoneNumber,
          ),
        ),
      );
    },
    codeAutoRetrievalTimeout: (e) {
      Fluttertoast.showToast(
        msg: "Code Time out ! if you haven't received please click resend code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    },
  );
}

Future<void> ResendPhoneNumberAuth(
    BuildContext context, String phoneNumber) async {
  if (isResendingPhoneVerification) {
    Fluttertoast.showToast(
      msg: "Resending SMS is in progress. Please wait.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.orange, // You can customize the color
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  try {
    isResendingPhoneVerification = true;
    Phone_Number_Auth(context, phoneNumber);
    Fluttertoast.showToast(
      msg: "Verification code sent !",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } finally {
    isResendingPhoneVerification = false;
  }
}
