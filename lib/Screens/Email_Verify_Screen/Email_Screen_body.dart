import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Round Button Component/Resend_Button.dart';
import '../SignUP_Screen/SignUp_Screen_main.dart';

import '../../Authentication Section/Sign_In_Authentication/Sign_In_Email_auth.dart';

import 'Email_Screen_back.dart';

class Body extends StatefulWidget {
  final String email_id;

  const Body({
    super.key,
    required this.email_id,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool allowNavigation = false;
  late String email_id;
  bool isResendButtonEnabled = true;
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    email_id = widget.email_id;
    super.initState();
    startTimer();
    Email_Verification_auth(context, email_id);
  }

  void startTimer() {
    setState(() {
      isResendButtonEnabled = false;
      _timerSeconds = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        setState(() {
          isResendButtonEnabled = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  void handleResendButtonPressed() {
    if (!isResendButtonEnabled) {
      return; // Button is disabled during the countdown
    }
    startTimer();
    ResendEmailVerify(context);
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Prevent navigation when allowNavigation is false (during login process)
          if (!allowNavigation) {
            return false;
          }
          return true; // Allow navigation for other screens
        },
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Email Verification",
                  style: GoogleFonts.lobster(
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                SvgPicture.asset(
                  "assets/Icons/email_verification.svg",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                // Replace with your string
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20), // Adjust the padding as needed
                  child: Center(
                    child: Text(
                      "Thank you for signing up! \n We've just sent a verification email,\n to your address \n \n This Screen Will automatically be \n updated After The verify link is clicked",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                ResendButton(
                  text: isResendButtonEnabled
                      ? "Resend"
                      : "Resend Code ( $_timerSeconds seconds )",
                  press: () {
                    isResendButtonEnabled ? handleResendButtonPressed() : null;
                  },
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20), // Adjust the padding as needed
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        allowNavigation = true; // Enable navigation after login
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Change Your Sign up Email',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
