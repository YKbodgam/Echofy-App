// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Round Button Component/Resend_Button.dart';
import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Components Section/Text Field Component/Text_Field_Container.dart';

import '../Username_Screen/User_Screen_main.dart';
import '../Phone_Verify_Screen/Phone_Screen_main.dart';

import '../../Authentication Section/Sign_In_Authentication/Sign_In_Phone_auth.dart';

import 'Otp_Screen_back.dart';

class Body extends StatefulWidget {
  final String verification_Id;
  final String Phone_number;

  const Body({
    super.key,
    required this.verification_Id,
    required this.Phone_number,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool allowNavigation = false;
  bool isResendButtonEnabled = true;
  int _timerSeconds = 30;
  bool loading = false;
  Timer? _timer;
  String Type = "Phone";

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final Verify_Controller = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    Verify_Controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void otpVerifyBtnPressed() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verification_Id,
        smsCode: Verify_Controller.text.toString(),
      );

      try {
        await _auth.signInWithCredential(credential);

        setState(() {
          loading = false;
        });

        Fluttertoast.showToast(
          msg: "Sign Up successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        setState(() {
          allowNavigation = true; // Enable navigation after login
        });

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsernameScreen(
              phone: widget.Phone_number,
              email: "None",
              Type: Type,
            ),
          ),
        );

        setState(() {
          allowNavigation = false; // Enable navigation after login
        });
      } catch (e) {
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
    setState(
      () {
        loading = false;
      },
    );
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
    ResendPhoneNumberAuth(context, widget.Phone_number);
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Phone Verification",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),

                  SizedBox(height: size.height * 0.08),
                  // Replace with your string
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20), // Adjust the padding as needed
                    child: Center(
                      child: Text(
                        "Thank you for signing up! \n \n We've just sent a verification code, to your number Please enter the code below to verify your phone number",
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
                  TextFieldContainer(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(
                            width:
                                10), // Add some spacing between the icon and the input field
                        Expanded(
                          child: TextFormField(
                            controller: Verify_Controller,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Enter your 6 digit code here : ",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Provided Code';
                              } else {
                                if (value.length != 6) {
                                  return "Code must be 6 Digits";
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundedButton(
                    loading: loading,
                    text: "Verify",
                    press: otpVerifyBtnPressed,
                  ),
                  ResendButton(
                    text: isResendButtonEnabled
                        ? "Resend"
                        : "Resend Code ( $_timerSeconds seconds )",
                    press: () {
                      isResendButtonEnabled
                          ? handleResendButtonPressed()
                          : null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20), // Adjust the padding as needed
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          allowNavigation =
                              true; // Enable navigation after login
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PhoneVerificationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Change Your Number',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
