import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Components Section/Text Field Component/Text_Field_Container.dart';

import 'User_Screen_back.dart';
import '../Login_Screen/Login_Screen_main.dart';

import '../../User Section/Create Unique User Section/Create_Static_User_info.dart';

class Body extends StatefulWidget {
  final String phone, email, Type;
  const Body({
    super.key,
    required this.phone,
    required this.email,
    required this.Type,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isPasswordVisible = true;
  bool allowNavigation = false;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final Username_Controller = TextEditingController();
  final Password_Controller = TextEditingController();
  final confirm_password_Controller = TextEditingController();

  late String Username = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Username_Controller.dispose();
    Password_Controller.dispose();
    confirm_password_Controller.dispose();
  }

  void Submit_Btn_Pressed() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        createStaticDetail(
          context,
          Username_Controller.text.toString().trim(),
          Password_Controller.text.toString().trim(),
          widget.phone,
          widget.email,
          widget.Type,
        );
      } catch (e) {
        setState(() {
          loading = false;
        });
      }
    }
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
                    "Sign Up",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/Icons/Sign_Up_Process.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldContainer(
                    child: TextFormField(
                      controller: Username_Controller,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.alternate_email,
                          color: kPrimaryColor,
                        ),
                        hintText: "Create Your Username : ",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a valid username";
                        }

                        // Check for white spaces
                        if (value.contains(RegExp(r'\s'))) {
                          return "should not contain blank spaces";
                        }

                        // Check for the length limit
                        if (value.length > 20) {
                          return "should be at most 20 characters";
                        }

                        // Count the number of special characters
                        int specialCharCount = 0;
                        for (int i = 0; i < value.length; i++) {
                          if ("!@#\$%^&*()_-+=<>?/".contains(value[i])) {
                            specialCharCount++;
                            if (specialCharCount > 1) {
                              return "should contain only one special character";
                            }
                          }
                        }

                        // Check if the username starts with a number
                        if (RegExp(r'^[0-9]').hasMatch(value)) {
                          return "should not start with a number";
                        }

                        // Check if the username consists of all numbers
                        if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "should not consist of all numbers";
                        }

                        return null;
                      },
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      controller: Password_Controller,
                      obscureText: isPasswordVisible,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Create your Password",
                        icon: const Icon(
                          Icons.lock_open,
                          color: kPrimaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:
                                kPrimaryColor, // Customize the visibility icon color
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }

                        // Check for white spaces
                        if (value.contains(RegExp(r'\s'))) {
                          return "should not contain blank spaces";
                        }

                        // Check for the length limit
                        if (value.length < 8) {
                          return "should be at least 8 characters";
                        }

                        // Check for the length limit
                        if (value.length > 20) {
                          return "should be at most 20 characters";
                        }

                        return null;
                      },
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      controller: confirm_password_Controller,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        hintText: "Re-Write your Password",
                        icon: Icon(
                          Icons.lock_outline,
                          color: kPrimaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }

                        if (value != Password_Controller.text) {
                          return "Passwords do not match";
                        }

                        return null;
                      },
                    ),
                  ),
                  RoundedButton(
                    loading: loading,
                    text: 'Create Account',
                    press: Submit_Btn_Pressed,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
