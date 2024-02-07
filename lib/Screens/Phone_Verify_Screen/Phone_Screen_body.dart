import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Authentication Section/Sign_In_Authentication/Sign_In_Phone_auth.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Components Section/Text Field Component/Text_Field_Container.dart';
import 'Phone_Screen_back.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool allowNavigation = false;

  final _formKey = GlobalKey<FormState>();
  final Phone_Controller = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    Phone_Controller.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void Phone_Verify_Btn_Pressed() {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      Phone_Number_Auth(context, Phone_Controller.text);
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg: "Something Went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
                    "Phone Verification",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: size.height * 0.15),
                  SvgPicture.asset(
                    "assets/Icons/Verification.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldContainer(
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.local_phone_outlined,
                            color: kPrimaryColor,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: Text(
                            "+91 ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18, // Adjust the font size as needed
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: Phone_Controller,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Enter your phone number",
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Phone no.';
                              } else {
                                if (value.length != 10) {
                                  return "Phone no. Should Be of 10 Digits";
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
                    press: Phone_Verify_Btn_Pressed,
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
