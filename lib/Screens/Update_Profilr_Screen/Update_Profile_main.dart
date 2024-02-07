// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Round Button Component/Round_Button.dart';
import '../../Components Section/Image Loader Component/ImageLoadingCont.dart';
import '../../Components Section/Text Field Component/Text_Field_Container.dart';
import '../../Components Section/Bottom Sheet Component/Choose_Profile_Img_Content.dart';
import '../Profile_Screen/Profile_Screen_main.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';
import '../../Authentication Section/Database_Authentication/Upload To Database/Upload_User_Profile_Img.dart';
import '../../Authentication Section/Database_Authentication/Update User Database/Update_Post_Author.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String UserId;
  final String Status;
  const UpdateProfileScreen({
    super.key,
    required this.UserId,
    required this.Status,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool allowNavigation = false;
  bool ploading = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  bool isEditingStatus = false;
  bool isEditingUsername = false;

  bool Verified = false;
  bool Saved = false;

  late String pathofImg = 'null';
  late String Imgpath = 'null';
  late String Verified_data = '';
  late String NewUsername;
  late String NewStatus;
  late String alterUsername = '';

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.UserId);
    setState(() {
      alterUsername = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    CheckData().then((value) => {Verified_data = value});
    getImage();
  }

  Future<void> getImage() async {
    setState(() {
      ploading = true;
    });
    Imgpath = await getProfileImg(widget.UserId);
    setState(() {
      ploading = false;
    });
  }

  Future<void> SavedBtn() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          Saved = true;
          isEditingUsername = false;
          isEditingStatus = false;
          allowNavigation = true;
          NewUsername = _usernameController.text;
          NewStatus = _statusController.text;
        });

        if (NewUsername == '') {
          setState(() {
            NewUsername = alterUsername;
          });
        }

        if (NewStatus == '') {
          setState(() {
            NewStatus = widget.Status;
          });
        }

        if (pathofImg != 'null') {
          Imgpath = await uploadImageToFirebase(widget.UserId, pathofImg);
        }

        try {
          await updateProfile(alterUsername);
          await updateAuthor(widget.UserId, NewUsername, Imgpath);
        } catch (e) {
          print('Error In updating User Profile Image');
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(UserId: widget.UserId),
          ),
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', NewUsername);

        Fluttertoast.showToast(
          msg: "Profile Updated ! Please Remember to Login With new username",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        print('Error updating profile: $e');
      }
    } else {
      return;
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> updateProfile(String username) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;

        await FirebaseFirestore.instance.collection('Users').doc(userId).update(
          {
            'Username': NewUsername,
            'Status': NewStatus,
          },
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<String> CheckData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: await getUsernameByUserId(widget.UserId))
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedEmail = userDoc.data()['Email_Address'];
    final verifiedPhone = userDoc.data()['Phone_Number'];

    if (verifiedEmail != 'None') {
      setState(() {
        Verified = true;
      });
      return verifiedEmail;
    } else {
      setState(() {
        Verified = false;
      });
      return verifiedPhone;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_outlined),
          color: Colors.white,
          iconSize: 30,
          onPressed: () {
            setState(() {
              allowNavigation = true; // Enable navigation after login
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  UserId: widget.UserId,
                ),
              ),
            );
          },
        ),
        title: Text(
          "Update",
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 22),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Prevent navigation when allowNavigation is false (during the login process)
          if (!allowNavigation) {
            return false;
          }
          return true; // Allow navigation for other screens
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(size.width * 0.08),
              child: Column(
                children: <Widget>[
                  // Profile Picture and QR Code
                  Stack(
                    children: <Widget>[
                      Container(
                        width: size.height * 0.2,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: pathofImg == 'null'
                              ? Imgpath != 'null' && Imgpath != ''
                                  ? CachedNetworkImageProvider(Imgpath)
                                      as ImageProvider
                                  : const AssetImage(
                                      "assets/Images/Profile.jpg")
                              : FileImage(File(pathofImg)),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.08,
                        left: size.height * 0.08,
                        child: ploading
                            ? buildLoadingContainer()
                            : const SizedBox.shrink(),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ProfileImgChange();
                              },
                            );

                            if (result != 'Null' && result != 'Delete') {
                              setState(() {
                                pathofImg = result;
                              });
                            } else if (result != 'Null' && result == 'Delete') {
                              pathofImg = 'null';
                              Imgpath = 'null';
                            } else {
                              pathofImg = 'null';
                            }
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.04),

                  isEditingUsername
                      ? TextFieldContainer(
                          child: TextFormField(
                            controller: _usernameController,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Re-Create Your Username",
                              icon: Icon(
                                Icons.alternate_email_outlined,
                                color: kPrimaryColor,
                              ),
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
                              if (value.length < 8) {
                                return "should be at least 8 characters";
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
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditingUsername = true;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 17),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: kPrimaryLightColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.alternate_email,
                                  color: kPrimaryColor,
                                ),
                                const SizedBox(width: 10),
                                Saved
                                    ? Text(
                                        _usernameController.text,
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    : Text(
                                        alterUsername,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                const Spacer(),
                                const Icon(
                                  Icons.edit,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),

                  isEditingStatus
                      ? TextFieldContainer(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _statusController,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: "Provide your status",
                              icon: Icon(
                                Icons.alternate_email_outlined,
                                color: kPrimaryColor,
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a valid Status";
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
                              if (value.length > 15) {
                                return "should be at most 15 characters";
                              }

                              if (value.isNotEmpty &&
                                  RegExp(r'^[0-9]').hasMatch(value)) {
                                return "Status should not start with a number";
                              }

                              if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return "Status should not consist of all numbers";
                              }

                              return null;
                            },
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditingStatus = true;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 17),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: kPrimaryLightColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: kPrimaryColor,
                                ),
                                const SizedBox(width: 10),
                                Saved
                                    ? Text(
                                        _statusController.text,
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    : Text(
                                        widget.Status,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                const Spacer(),
                                const Icon(
                                  Icons.edit,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),

                  SizedBox(height: size.height * 0.01),

                  const Divider(
                    thickness: 1,
                    color: kPrimaryColor,
                  ),

                  SizedBox(height: size.height * 0.01),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 17),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Row(
                      children: [
                        Verified
                            ? const Icon(
                                Icons.alternate_email_outlined,
                                color: kPrimaryColor,
                              )
                            : const Icon(
                                Icons.phone_outlined,
                                color: kPrimaryColor,
                              ),
                        const SizedBox(width: 10),
                        Text(
                          Verified_data.length > 4
                              ? '${Verified_data.substring(0, 8)} **** '
                              : Verified_data,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.done_outlined,
                          color: Colors.green,
                          size: 25,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),
                  // Create Account Button
                  RoundedButton(
                    loading: loading,
                    text: 'Save',
                    press: SavedBtn,
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
