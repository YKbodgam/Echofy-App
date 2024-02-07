// ignore_for_file: use_build_context_synchronously, unnecessary_new

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Components Section/Text Field Component/Text_Field_Container.dart';
import 'Login_Screen_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Home_Screen/Home_Screen_main.dart';
import '../SignUP_Screen/SignUp_Screen_main.dart';

import '../../Authentication Section/Log_In_Authentication/Store_Token.dart';
import '../../Authentication Section/Log_In_Authentication/Log_In_auth.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool allowNavigation = false;
  bool loading = false;
  User? user;
  bool isPasswordVisible = true;
  late String AfterUsername;

  final _formKey = GlobalKey<FormState>();
  final UsernameController = TextEditingController();
  final PasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    UsernameController.dispose();
    PasswordController.dispose();
  }

  void LoginBtnPressed() async {
    FocusScope.of(context).unfocus();
    //Setting State of Loader
    setState(() {
      loading = true;
    });

    //Validatory
    if (_formKey.currentState!.validate()) {
      try {
        AfterUsername = await loginAuthentication(
            UsernameController.text, PasswordController.text.toString());

        if (AfterUsername != 'null') {
          // flash message
          final token = generateToken();
          await storeToken(token, AfterUsername);

          setState(
            () {
              loading = false;
            },
          );

          setState(() {
            allowNavigation = true; // Enable navigation after login
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                UserId: AfterUsername,
              ),
            ),
          );

          Fluttertoast.showToast(
            msg: "Login successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }

        setState(
          () {
            loading = false;
          },
        );

        // Exception will be thrown if the form Here
      } catch (e) {
        setState(() {
          loading = false;
        });

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
    } else {
      setState(() {
        loading = false;
      });
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
                    "Login",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  SvgPicture.asset(
                    "assets/Icons/login.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      controller: UsernameController,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: "Enter your username",
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a valid Username";
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      controller: PasswordController,
                      obscureText: isPasswordVisible,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        icon: const Icon(
                          Icons.lock,
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
                          return "Please enter a valid Password";
                        }
                        return null;
                      },
                    ),
                  ),
                  RoundedButton(
                    loading: loading,
                    text: 'Login',
                    press: LoginBtnPressed,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't Have An Account ? ",
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
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
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
