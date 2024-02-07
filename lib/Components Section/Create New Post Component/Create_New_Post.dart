import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';
import '../Classic Image Component/SliderRatioContainer.dart';
import '../Classic Image Component/WithAspectRatioCont.dart';
import '../Classic Image Component/WithoutAspectRCont.dart';
import '../../Class Methods ( New ) Section/Create_New_Post_Class_Method.dart';

import 'Choose_Custom_Adjust_Ratio.dart';
import 'Choose_Image_Ratio_Container.dart';

import '../Colour Component/UIColours.dart';
import '../Checkbox Buttons Component/Select_Hashtag_Button.dart';
import '../Bottom Sheet Component/Choose_Post_Img_Content.dart';

import '../../../Notification Section/Send_User_Notification.dart';

import '../../../User Section/Authenticate User Section/Get_User_Identification.dart';
import '../../../Authentication Section/Database_Authentication/Upload To Database/Upload_Post_Banner_Img.dart';

class CreatePost extends StatefulWidget {
  final String Username;
  final String userId;
  const CreatePost({super.key, required this.Username, required this.userId});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final MessageController = TextEditingController();
  final HashTagController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();
  final FocusNode focusNode = FocusNode();

  bool isHashFocused = false;
  bool isTextFocused = false;
  bool Loading = false;

  bool ploading = true;
  bool validatetext = false;
  bool validatevalue = false;

  bool isSelectedFirstPost = false;
  bool isSelectedPopular = false;
  bool isSelectedGoodNote = false;

  bool isSelectedFirstRatio = false;
  bool isSelectedSecondRatio = false;
  bool isSelectedThirdRatio = false;
  bool isSelectedFourthRatio = false;
  bool isSelectedFifthRatio = false;
  bool isSelectedSixthRatio = false;
  bool isSelectedSeventhRatio = false;
  bool isSelectedCustomRatio = true;

  bool isSelectedFill = true;
  bool isSelectedFit = false;
  bool isSelectedAdjust = false;

  bool isFirst = false;
  bool isSecond = false;
  bool isthird = false;

  late String Imgpath = '';

  List<String> ImageContentPath = [];
  late Map<String, double?> FinalImgContent = {};

  List<String> Content = [];
  Set<String> hashs = {};

  late String Status = "";
  late String text = "";

  late String FirstText = "";
  late String SecondText = "";
  late String thirdText = "";

  int NewPageIndex = 0;

  @override
  void initState() {
    super.initState();
    getImage();
    GetStatus();
    _focusNode.addListener(() {
      setState(() {
        isTextFocused = _focusNode.hasFocus;
      });
    });
    focusNode.addListener(() {
      setState(() {
        isHashFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    MessageController.dispose();
    HashTagController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    final upload = await getProfileImg(widget.userId);
    setState(() {
      Imgpath = upload;
    });
  }

  Future<void> GetStatus() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: widget.Username)
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != '' && verifiedStatus != null) {
      setState(() {
        Status = verifiedStatus;
      });
    } else {
      Status = 'Available';
    }
  }

  String sanitizeKey(String key) {
    // Replace disallowed characters with a safe alternative
    String semi = key.replaceAll(RegExp(r'[/#$[\]]'), '_');
    return semi.replaceAll(RegExp(r'[./#$[\]]'), '+');
  }

  String getMessageBody(String message) {
    if (message.length <= 20) {
      return message; // Use the entire string if its length is less than or equal to 10.
    } else {
      return '${message.substring(0, 20)} ....';
    }
  }

  Future<void> newPostPreProsess() async {
    setState(() {
      Loading = true;
    });

    if (formKey.currentState!.validate()) {
      checkSelected();

      double? ratio = CheckFinalRatio();
      if (ratio == 1) {
        setState(() {
          ratio = 1.01;
        });
      }

      final timestamp = DateTime.now();
      final formatted = DateFormat.yMMMEd().format(timestamp);
      final timepost =
          "${timestamp.hour}:${timestamp.minute} ${timestamp.hour >= 12 ? 'PM' : 'AM'}";

      if (ImageContentPath.isNotEmpty) {
        for (var i = 0; i < ImageContentPath.length; i++) {
          String imgPath = await uploadPostImgToFirebase(
            widget.userId,
            ImageContentPath[i],
            timepost,
            formatted,
            (i + 1).toString(),
          );

          FinalImgContent[sanitizeKey(imgPath)] = ratio;
        }
      }

      await createPostMethod(
        widget.userId,
        MessageController.text,
        FinalImgContent,
        hashs,
      );

      setState(() {
        Loading = false;
      });

      FocusScope.of(context).unfocus();
      Navigator.pop(context, "not");

      NotifyUser(
        await getUserIdByUsername(widget.Username),
        '',
        'No',
        'Post',
        getMessageBody(MessageController.text),
      );

      //
    } else {
      setState(() {
        Loading = false;
      });
    }
  }

  void checkSelected() {
    if (isSelectedFirstPost == true) {
      if (isFirst == true) {
        hashs.add(FirstText);
      } else {
        hashs.add('My First Post');
      }
    }
    if (isSelectedPopular == true) {
      if (isSecond == true) {
        hashs.add(SecondText);
      } else {
        hashs.add('UnPopular Opinion');
      }
    }
    if (isSelectedGoodNote == true) {
      if (isthird == true) {
        hashs.add(thirdText);
      } else {
        hashs.add('Special News');
      }
    }
    if (isSelectedFirstPost != true &&
        isSelectedPopular != true &&
        isSelectedGoodNote != true) {
      hashs = {};
    }
  }

  double? CheckFinalRatio() {
    if (isSelectedFirstRatio) {
      return 16 / 9;
    } else if (isSelectedSecondRatio) {
      return 4 / 3;
    } else if (isSelectedThirdRatio) {
      return 1 / 1;
    } else if (isSelectedFourthRatio) {
      return 4 / 5;
    } else if (isSelectedFifthRatio) {
      return 2 / 3;
    } else if (isSelectedSixthRatio) {
      return 3 / 2;
    } else if (isSelectedSeventhRatio) {
      return 5 / 4;
    } else {
      return null;
    }
  }

  void GetContentShape(String Shape) {
    setState(() {
      isSelectedFill = Shape == "fill";
      isSelectedFit = Shape == "fit";
      isSelectedAdjust = Shape == "adjust";
    });
  }

  void ImageRatioSelected(String ratio) {
    setState(() {
      isSelectedFirstRatio = ratio == 'first';
      isSelectedSecondRatio = ratio == 'second';
      isSelectedThirdRatio = ratio == 'third';
      isSelectedFourthRatio = ratio == 'fourth';
      isSelectedFifthRatio = ratio == 'fifth';
      isSelectedSixthRatio = ratio == 'sixth';
      isSelectedSeventhRatio = ratio == 'seventh';
      isSelectedCustomRatio = ratio == 'Custom';
    });
  }

  void hashBtnClicked(String buttonName) {
    if (buttonName == 'First Post') {
      if (Content.contains('First Post')) {
        Content.remove("First Post");
        setState(() {
          isSelectedFirstPost = !isSelectedFirstPost;
        });
      } else {
        Content.add("First Post");
        setState(() {
          isSelectedFirstPost = !isSelectedFirstPost;
        });
      }

      // Add your action for the 'First Post' button here
    } else if (buttonName == 'Popular') {
      if (Content.contains('Popular')) {
        Content.remove("Popular");
        setState(() {
          isSelectedPopular = !isSelectedPopular;
        });
      } else {
        Content.add('Popular');
        setState(() {
          isSelectedPopular = !isSelectedPopular;
        });
      }

      // Add your action for the 'Popular' button here
    } else if (buttonName == 'Good Note') {
      if (Content.contains('Good Note')) {
        Content.remove("Good Note");
        setState(() {
          isSelectedGoodNote = false;
        });
      } else {
        Content.add("Good Note");
        setState(() {
          isSelectedGoodNote = !isSelectedGoodNote;
        });
      }

      // Add your action for the 'Good Note' button here
    }
  }

  void _validateAndSubmit() {
    String hastags = HashTagController.text;

    // Manual validation
    if (hastags.isEmpty || hastags == '') {
      setState(() {
        validatetext = true;
      });
      return;
    } else {
      if (hastags.length > 15) {
        setState(() {
          validatevalue = true;
        });
      } else {
        CreateContent();
      }
    }

    // Validation passed, continue processing
    // ...
  }

  double _getSelectedAspectRatio() {
    if (isSelectedFirstRatio) {
      return 16 / 9;
    } else if (isSelectedSecondRatio) {
      return 4 / 3;
    } else if (isSelectedThirdRatio) {
      return 1 / 1;
    } else if (isSelectedFourthRatio) {
      return 4 / 5;
    } else if (isSelectedFifthRatio) {
      return 2 / 3;
    } else if (isSelectedSixthRatio) {
      return 3 / 2;
    } else if (isSelectedSeventhRatio) {
      return 5 / 4;
    } else {
      return 1 / 1;
    }
  }

  void CreateContent() {
    if (Content.length == 3) {
      Fluttertoast.showToast(
        msg: "Already Three Are Selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      if (Content.contains("First Post")) {
        if (Content.contains("Popular")) {
          Content.add("Good Note");
          setState(
            () {
              thirdText = HashTagController.text;
              isSelectedGoodNote = !isSelectedGoodNote;
              isthird = true;
              HashTagController.clear();
            },
          );
        } else {
          Content.add('Popular');
          setState(() {
            SecondText = HashTagController.text;
            isSelectedPopular = !isSelectedPopular;
            isSecond = true;
            HashTagController.clear();
          });
        }
      } else {
        Content.add("First Post");
        setState(() {
          FirstText = HashTagController.text;
          isSelectedFirstPost = !isSelectedFirstPost;
          isFirst = true;
          HashTagController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Container(
        margin:
            EdgeInsets.all(size.width * 0.02), // Adjust the width as needed.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Echofy",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(fontSize: 24),
                      color: kPrimaryColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.close_outlined,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context, null); // Close the dialog.
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.01),
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 1.0, // Set the height of the line
                        color: kPrimaryColor, // Set the color of the line
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 30, // Set the desired width
                          height: 30, // Set the desired height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45.0),
                            border: Border.all(
                              color: Colors.black
                                  .withOpacity(0.5), // Set the border color
                              width: 1, // Set the border width
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: Imgpath != 'null' && Imgpath != ''
                                ? CachedNetworkImageProvider(Imgpath)
                                    as ImageProvider
                                : const AssetImage("assets/Images/Profile.jpg"),
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.Username,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              Status,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Placeholder for the post image

                    Visibility(
                      visible: ImageContentPath.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageContentPath.length == 1
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.005,
                                      vertical: size.height * 0.01),
                                  child: isSelectedCustomRatio
                                      ? WithoutRatioContainer(
                                          ImagePath: ImageContentPath[0],
                                          size: size,
                                          Shape: isSelectedFill
                                              ? 'Fill'
                                              : isSelectedFit
                                                  ? 'Fit'
                                                  : 'Adjust',
                                        )
                                      : WithRatioContainer(
                                          aspectRatio:
                                              _getSelectedAspectRatio(),
                                          ImagePath: ImageContentPath[0],
                                          size: size,
                                          Shape: isSelectedFill
                                              ? 'Fill'
                                              : isSelectedFit
                                                  ? 'Fit'
                                                  : 'Adjust',
                                        ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.005,
                                      vertical: size.height * 0.01),
                                  child: isSelectedCustomRatio
                                      ? SizedBox(
                                          height: size.height * 0.3,
                                          child: SliderRatioContainer(
                                            Items: ImageContentPath,
                                            size: size,
                                            onPageChangedCallback: (index) {
                                              setState(() {
                                                NewPageIndex = index;
                                              });
                                            },
                                            Shape: isSelectedFill
                                                ? 'Fill'
                                                : isSelectedFit
                                                    ? 'Fit'
                                                    : 'Adjust',
                                          ),
                                        )
                                      : AspectRatio(
                                          aspectRatio:
                                              _getSelectedAspectRatio(), // Adjust the aspect ratio based on your design
                                          child: SliderRatioContainer(
                                            Items: ImageContentPath,
                                            size: size,
                                            onPageChangedCallback: (index) {
                                              setState(() {
                                                NewPageIndex = index;
                                              });
                                            },
                                            Shape: isSelectedFill
                                                ? 'Fill'
                                                : isSelectedFit
                                                    ? 'Fit'
                                                    : 'Adjust',
                                          ),
                                        ),
                                ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < ImageContentPath.length; i++)
                                Container(
                                  height: 4.0,
                                  width: 30.0,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.01),
                                  decoration: BoxDecoration(
                                    color: NewPageIndex == i
                                        ? kPrimaryColor
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => GetContentShape('fill'),
                                child: buildImageFillerWidget(
                                    'Fill', context, isSelectedFill),
                              ),
                              GestureDetector(
                                onTap: () => GetContentShape('fit'),
                                child: buildImageFillerWidget(
                                    'Fit', context, isSelectedFit),
                              ),
                              GestureDetector(
                                onTap: () => GetContentShape('adjust'),
                                child: buildImageFillerWidget(
                                    'Adjust', context, isSelectedAdjust),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('first'),
                                    child: buildImagewithRatioWidget(
                                        16 / 9,
                                        '16 / 9',
                                        context,
                                        isSelectedFirstRatio),
                                  ),
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('second'),
                                    child: buildImagewithRatioWidget(
                                        4 / 3,
                                        '4 : 3',
                                        context,
                                        isSelectedSecondRatio),
                                  ),
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('third'),
                                    child: buildImagewithRatioWidget(1 / 1,
                                        '1 : 1', context, isSelectedThirdRatio),
                                  ),
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('fourth'),
                                    child: buildImagewithRatioWidget(
                                        4 / 5,
                                        '4 / 5',
                                        context,
                                        isSelectedFourthRatio),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('fifth'),
                                    child: buildImagewithRatioWidget(2 / 3,
                                        '2 / 3', context, isSelectedFifthRatio),
                                  ),
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('sixth'),
                                    child: buildImagewithRatioWidget(3 / 2,
                                        '3 / 2', context, isSelectedSixthRatio),
                                  ),
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('seventh'),
                                    child: buildImagewithRatioWidget(
                                        5 / 4,
                                        '5 / 4',
                                        context,
                                        isSelectedSeventhRatio),
                                  ),
                                  GestureDetector(
                                    onTap: () => ImageRatioSelected('Custom'),
                                    child: buildImagewithRatioWidget(
                                        0 / 1,
                                        'Custom',
                                        context,
                                        isSelectedCustomRatio),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    GestureDetector(
                      onTap: () async {
                        if (ImageContentPath.length > 4) {
                          Fluttertoast.showToast(
                            msg: "Only Five Images Are Allowed till now",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          final result = await showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return NewPostImage();
                            },
                          );

                          setState(() {
                            ploading = true;
                          });

                          if (result != 'Null') {
                            setState(() {
                              ImageContentPath.add(result);
                            });
                          }

                          setState(() {
                            ploading = false;
                          });
                        }
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(45),
                        dashPattern: const [10, 10],
                        color: Colors.grey,
                        strokeWidth: 1.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Add a fun icon here
                              const Icon(
                                Icons.image_outlined,
                                size: 18.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8.0),
                              // Add the stylized text "Add Fun Image"
                              ImageContentPath.isEmpty
                                  ? Text(
                                      "Add some fun images",
                                      style: GoogleFonts.nunito(
                                        textStyle:
                                            const TextStyle(fontSize: 12),
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Text(
                                      "Add some more images",
                                      style: GoogleFonts.nunito(
                                        textStyle:
                                            const TextStyle(fontSize: 12),
                                        color: Colors.grey,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isTextFocused
                                    ? kPrimaryColor
                                    : Colors
                                        .grey), // Border color // Border color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: MessageController,
                              maxLines: 5, // Allow multiple lines
                              onChanged: (text) {
                                setState(() {});
                              },
                              focusNode: _focusNode,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Your Thoughts Here : ',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Message cannot be empty \n";
                                } else if (value.length > 400) {
                                  return "Cannot exceed 200 character count \n";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              'Character Count: ${MessageController.text.length} / 400',
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isHashFocused
                                    ? kPrimaryColor
                                    : Colors
                                        .grey), // Border color // Border color
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: HashTagController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.edit_outlined,
                                  color: isHashFocused
                                      ? kPrimaryColor
                                      : Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _validateAndSubmit,
                                  icon: Icon(
                                    Icons.done_outlined,
                                    color: isHashFocused
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: "Enter your Hastags here",
                              ),
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: validatetext,
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * 0.02),
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Hashtags Cannot be Empty",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.withOpacity(0.5),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: validatevalue,
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * 0.02),
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Cannot Exceed 15 character count",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.red.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.008),
                          child: Text(
                            "Hint : You can Enter 3 Hashtags ( Max 15 Per Each )",
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                  fontSize: 10, color: kPrimaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Center(
                      child: Container(
                        height: 1.0, // Set the height of the line
                        color: kPrimaryColor, // Set the color of the line
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () => hashBtnClicked('First Post'),
                              child: buildHashtagWidget(
                                  isFirst ? FirstText : 'My First Post',
                                  context,
                                  isSelectedFirstPost),
                            ),
                            GestureDetector(
                              onTap: () => hashBtnClicked('Popular'),
                              child: buildHashtagWidget(
                                  isSecond ? SecondText : 'UnPopular Opinion',
                                  context,
                                  isSelectedPopular),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => hashBtnClicked('Good Note'),
                              child: buildHashtagWidget(
                                  isthird ? thirdText : 'Special News',
                                  context,
                                  isSelectedGoodNote),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: // Margin of 20px
                  ElevatedButton(
                onPressed: () async {
                  newPostPreProsess();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                    // Rounded corners
                  ),
                  backgroundColor: kPrimaryColor,
                ),
                child: Container(
                  height: 25,
                  alignment: Alignment.center, // Center the label
                  child: Loading
                      ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
