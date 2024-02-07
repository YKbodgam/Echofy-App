import 'dart:async';
import 'package:echofy_app/Screens/SignUP_Screen/SignUp_Screen_main.dart';
import 'package:echofy_app/Screens/Username_Screen/User_Screen_main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
Timer? timer;
String Type = "Email";

@override
void dispose() {
  timer?.cancel();
}

void showToast_good(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showToast_bad(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 10,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<void> checkEmailVerified(
    BuildContext context, User user, String email) async {
  await user.reload();
  user = FirebaseAuth.instance.currentUser!;

  if (user.emailVerified) {
    timer?.cancel();

    showToast_good("Sign In successfully");
    // Navigate to the login page or perform other actions
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UsernameScreen(
                phone: "None",
                email: email,
                Type: Type,
              )),
    );
  }
}

Future<void> sendEmailVerification(
    BuildContext context, User user, String email) async {
  try {
    await user.sendEmailVerification();

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(context, user, email),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      showToast_bad(
        "Account already exists ! Please try again",
      );
    } else {
      if (e.code == 'invalid-email') {
        showToast_bad(
          "Invalid Email Id ! Please try again",
        );
      } else {
        showToast_bad(
          e.toString(),
        );
      }
    }
  }
}

Future<void> Email_Verification_auth(BuildContext context, emailId) async {
  try {
    // interact
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: emailId,
      password: "password",
    );

    showToast_good("Verification email sent. Please check your inbox.");
    sendEmailVerification(context, userCredential.user!, emailId);

    // send
  } on FirebaseAuthException catch (e) {
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );

    if (e.code == 'email-already-in-use') {
      showToast_bad(
        "Account already exists ! Please try again",
      );
    } else {
      if (e.code == 'invalid-email') {
        showToast_bad(
          "Invalid Email Id ! Please try again",
        );
      } else {
        showToast_bad(
          e.toString(),
        );
      }
    }
  }
}

Future<void> ResendEmailVerify(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && !user.emailVerified) {
    try {
      await user.sendEmailVerification();
      showToast_good("Verification email resent. Please check your inbox.");
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'too-many-requests') {
          showToast_bad(
              "Too many verification requests. Please wait and try again later.");
        } else {
          showToast_bad(
              "An error occurredshowToast_bad(An error occurred: ${e.message}");
        }
      } else {
        showToast_bad("An unexpected error occurred.");
      }
    }
  } else {
    showToast_good("Your email is already verified.");
  }
}
