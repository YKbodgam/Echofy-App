import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Or_Divider.dart';
import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Components Section/Text Field Component/Text_Field_Container.dart';
import '../Login_Screen/Login_Screen_main.dart';
import '../Username_Screen/User_Screen_main.dart';
import '../Email_Verify_Screen/Email_Screen_main.dart';
import '../Phone_Verify_Screen/Phone_Screen_main.dart';

import '../../Authentication Section/Sign_In_Authentication/Sign_In_Google_auth.dart';

import 'SignUp_Screen_back.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool allowNavigation = false;
  User? user;
  Timer? timer;
  bool loading = false;
  bool UserExists = false;
  String Type = "Google";

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  //Google Auth credentials
  void Google_Btn_Pressed() {
    // Do nothing
    SignInWithGoogle().then(
      (user) async {
        if (user == null) {
          showToast_bad("Sign in Failed ! Please try again");
        } else {
          bool userExistsWithEmail =
              await checkIfUserExistsWithEmail(user.email.toString());
          if (userExistsWithEmail) {
            showToast_bad(
                "User already exists with this email ! Please Log In");

            setState(() {
              allowNavigation = true; // Enable navigation after login
            });

            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else {
            setState(
              () {
                this.user = user;
              },
            );
            showToast_good(
              "Login successfully",
            );

            setState(() {
              allowNavigation = true; // Enable navigation after login
            });
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsernameScreen(
                  phone: "None",
                  email: user.email.toString(),
                  Type: Type,
                ),
              ),
            );
          }
        }
      },
    );
  }

  void Phone_Btn_Pressed() {
    setState(() {
      allowNavigation = true; // Enable navigation after login
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PhoneVerificationScreen(),
        ));
  }

  Future<bool> checkIfUserExistsWithEmail(String emailId) async {
    final emailQuery = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email_Address', isEqualTo: emailId)
        .get();

    if (emailQuery.docs.isNotEmpty) {
      return UserExists = true;
    }
    return UserExists = false;
  }

  // ignore: non_constant_identifier_names
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

  // ignore: non_constant_identifier_names
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

  void Verify_Btn_Pressed() {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        allowNavigation = true; // Enable navigation after login
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationScreen(
            email: emailController.text.toString().trim(),
          ),
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }

  //
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
                    "Sign Up",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/Icons/signup.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldContainer(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.alternate_email,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(
                            width:
                                10), // Add some spacing between the icon and the input field
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Enter your Email Address : ",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundedButton(
                    loading: loading,
                    text: "Verify",
                    press: Verify_Btn_Pressed,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already Have An Account ? ",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            allowNavigation =
                                true; // Enable navigation after login
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  const OrDivider(),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: Google_Btn_Pressed,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: kPrimaryLightColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/Icons/google-plus.svg",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
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
                        child: Container(
                          margin: const EdgeInsets.only(left: 40),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: kPrimaryLightColor,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/Icons/phone.svg",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
