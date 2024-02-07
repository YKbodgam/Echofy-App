import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Navigation Section/Notification Page Section/NotificationPage.dart';
import 'Welcome_Screen_back.dart';
import '../Login_Screen/Login_Screen_main.dart';
import '../SignUP_Screen/SignUp_Screen_main.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool allowNavigation = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // Specify The size Of the screen
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
                  "Welcome to Echofy App",
                  style: GoogleFonts.lobster(
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                SvgPicture.asset(
                  "assets/Icons/chat.svg",
                  height: size.height * 0.45,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                RoundedButton(
                  loading: loading,
                  text: 'Login',
                  press: () {
                    setState(() {
                      loading = true;
                    });
                    setState(() {
                      allowNavigation = true; // Enable navigation after login
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                ),
                RoundedButton(
                  loading: loading,
                  text: 'Sign Up',
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
                  press: () {
                    setState(() {
                      loading = true;
                    });
                    setState(() {
                      allowNavigation = true; // Enable navigation after login
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
