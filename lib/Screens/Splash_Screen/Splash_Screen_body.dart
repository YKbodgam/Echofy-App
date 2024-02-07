// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Splash_Screen_back.dart';
import '../Home_Screen/Home_Screen_main.dart';
import '../Welcome_Screen/Welcome_Screen_main.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../Notification Section/User_Notification_Services.dart';
import '../../Authentication Section/Log_In_Authentication/Internet_Connectivity_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool allowNavigation = true;
  late String newusername = '';

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    requestNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    bool isConnected = await checkInternetConnectivity();

    Fluttertoast.showToast(
      msg: "Checking for internet connection...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No internet connection !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 9,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Wait for a few seconds before checking again
      await Future.delayed(const Duration(seconds: 10));
      await _checkConnectivity(); // Recursively check for connectivity
    } else {
      checkAutoLogin();
    }
  }

  Future<void> checkAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    final userId = prefs.getString('userId');

    if (token != null) {
      try {
        final Username = await getUsernameByUserId(userId!);
        if (Username != 'null') {
          setState(() {
            newusername = Username;
          });

          Fluttertoast.showToast(
            msg: "Already Logged In with $newusername!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Timer(
            const Duration(seconds: 3),
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  UserId: userId,
                ),
              ),
            ),
          );
        } else {
          prefs.remove('userToken');
          prefs.remove('userId');

          Timer(
            const Duration(seconds: 3),
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            ),
          );
        }
      } catch (e) {
        print('Firestore Query Error: $e');
      }
    } else {
      prefs.remove('userToken');
      prefs.remove('userId');

      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Prevent navigation when allowNavigation is false (during login process)
          if (!allowNavigation) {
            return false;
          }
          return true; // Allow navigation for other screens
        },
        child: const CenteredTextWithPadding(),
      ),
    );
  }
}
