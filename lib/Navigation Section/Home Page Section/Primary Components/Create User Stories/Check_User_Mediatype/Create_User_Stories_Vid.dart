// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../../Screens/Home_Screen/Home_Screen_main.dart';
import '../../../../../Components Section/Colour Component/UIColours.dart';
import '../../../../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../../../../Class Methods ( New ) Section/Create_New_Stories_Class_Method.dart';
import '../../../../../Authentication Section/Database_Authentication/Upload To Database/Upload_Stories_Banner_Img.dart';

class VideoCheckScreen extends StatefulWidget {
  final Size size;
  final String url;
  final String userId;

  const VideoCheckScreen({
    super.key,
    required this.size,
    required this.url,
    required this.userId,
  });

  @override
  State<VideoCheckScreen> createState() => _VideoCheckScreenState();
}

class _VideoCheckScreenState extends State<VideoCheckScreen> {
  late VideoPlayerController _controller;

  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();

  late String descriptiontext = '';
  late String alterUsername = '';

  bool validatetext = false;
  bool validatevalue = false;
  bool isTextFocused = false;
  bool isDescription = false;
  bool isTextform = false;

  bool fullWidth = false;
  bool isfill = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUsername();
    getVideo();
    focusNode.addListener(() {
      setState(() {
        isTextFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.userId);
    setState(() {
      alterUsername = user;
    });
  }

  Future<void> getVideo() async {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then(
        (_) {
          setState(() {});

          _controller.play();
        },
      );
  }

  void _validateAndSubmit() {
    // Manual validation
    if (textController.text.isEmpty || textController.text == '') {
      setState(() {
        validatetext = true;
      });
    } else {
      setState(() {
        validatetext = false;
      });
      if (textController.text.length > 100) {
        setState(() {
          validatevalue = true;
        });
      } else {
        setState(() {
          validatevalue = false;
          isDescription = true;
          descriptiontext = textController.text;
          isTextform = !isTextform;
          isTextFocused = false;
        });
      }
    }
  }

  Future<void> submitStories() async {
    setState(() {
      loading = true;
    });

    final timestamp = DateTime.now();
    final formatted = DateFormat.yMMMEd().format(timestamp);
    final timepost =
        "${timestamp.hour}:${timestamp.minute} ${timestamp.hour >= 12 ? 'PM' : 'AM'}";

    try {
      String imgPath = await uploadStoryVidToFirebase(
        widget.userId,
        widget.url,
        timepost,
        formatted,
      );

      createStoriesMethod(
        widget.userId,
        isDescription ? descriptiontext : '',
        'Video',
        imgPath,
        [isfill ? 'fill' : 'not', fullWidth ? 'width' : 'not'],
      );
    } catch (error) {
      print("Error On Uploading: $error");
      // Handle the error as needed.
    } finally {
      setState(() {
        loading = false;
      });
    }

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(UserId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.05,
              vertical: widget.size.height * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45.0),
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent, // Set the color to transparent
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: kPrimaryColor,
                      size: 15,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 30, maxWidth: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(UserId: widget.userId)),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isfill = !isfill;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Image.asset(
                    "assets/Flaticon/resize-expand.png",
                    color: kPrimaryColor,
                    cacheHeight: 15,
                  ),
                ),
              ),
              SizedBox(
                width: widget.size.width * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    fullWidth = !fullWidth;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Image.asset(
                    "assets/Flaticon/fit.png",
                    color: kPrimaryColor,
                    cacheHeight: 15,
                  ),
                ),
              ),
              SizedBox(
                width: widget.size.width * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTextform = !isTextform;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Image.asset(
                    "assets/Flaticon/font.png",
                    color: kPrimaryColor,
                    cacheHeight: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.05,
              vertical: widget.size.height * 0.03,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: fullWidth ? 0 : widget.size.width * 0.05,
              vertical: isfill ? 0 : widget.size.height * 0.03,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Visibility(
                  visible: isDescription,
                  child: Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.size.width * 0.01,
                      ),
                      child: Container(
                        height: widget.size.height * 0.1,
                        width: widget.size.width * 0.9,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.size.width * 0.05,
                          vertical: widget.size.height * 0.015,
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(220, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Description :",
                                    style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    constraints: const BoxConstraints(
                                        maxHeight: 20, minHeight: 20),
                                    onPressed: () {
                                      isDescription = !isDescription;
                                    },
                                    icon: const Icon(
                                      Icons.close_outlined,
                                      color: kPrimaryColor,
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                descriptiontext,
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    fontSize: 9,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: isTextFocused
              ? 370
              : isTextform
                  ? 170
                  : 100,
          padding: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.05,
              vertical: isTextFocused ? 15 : widget.size.height * 0.02),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: isTextFocused ? 15 : widget.size.height * 0.02,
                ),
                Visibility(
                  visible: isTextform,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isTextFocused
                              ? kPrimaryColor
                              : Colors.grey), // Border color // Border color
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(45),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {});
                        },
                        controller: textController,
                        focusNode: focusNode,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: _validateAndSubmit,
                              icon: Icon(
                                Icons.send_rounded,
                                color:
                                    isTextFocused ? kPrimaryColor : Colors.grey,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 10, 12),
                            hintText: "Enter Image Description :",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: validatetext,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.size.width * 0.02,
                        vertical: widget.size.height * 0.005),
                    child: Text(
                      "Description Cannot be Empty",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: validatevalue,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.size.width * 0.02,
                        vertical: widget.size.height * 0.005),
                    child: Text(
                      "Cannot Exceed 100 character count",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isTextform,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.size.width * 0.03,
                            vertical: widget.size.height * 0.005),
                        child: Row(
                          children: [
                            Text(
                              "Hint : Please enter description for the image",
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 10, color: kPrimaryColor),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Count: ${textController.text.length} / 100',
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 9, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: widget.size.height * 0.01,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      submitStories();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      side: const BorderSide(
                        color: kPrimaryColor,
                      ),
                      backgroundColor: kPrimaryColor.withOpacity(0.8),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                        : const Text(
                            'Your Story',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
