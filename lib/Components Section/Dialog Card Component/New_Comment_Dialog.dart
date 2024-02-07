import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';

class CommentDialog extends StatefulWidget {
  final String username;
  final String userId;
  final String status;
  final String body;
  final Post post;

  const CommentDialog({
    super.key,
    required this.username,
    required this.userId,
    required this.status,
    required this.body,
    required this.post,
  });

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  late String commentImgPath = '';
  late String postImgPath = '';

  late String commentAuthorname = '';
  late String status = '';

  bool loading = false;
  bool isTextFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        isTextFocused = _focusNode.hasFocus;
      });
    });

    getUsername();
    getImage();
    getStatus();
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.userId);
    setState(() {
      commentAuthorname = user;
    });
  }

  Future<void> getImage() async {
    postImgPath = await getProfileImg(widget.post.postAuthorId);
    commentImgPath = await getProfileImg(widget.userId);
  }

  Future<void> getStatus() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: commentAuthorname)
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != null &&
        verifiedStatus != '' &&
        verifiedStatus != 'None') {
      status = verifiedStatus;
    } else {
      status = 'Available';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Form(
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
                        textStyle: const TextStyle(fontSize: 22),
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
                        Navigator.pop(context, 'Null'); // Close the dialog.
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Center(
                child: Container(
                  height: 1.0, // Set the height of the line
                  color: kPrimaryColor, // Set the color of the line
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.005),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              backgroundImage:
                                  postImgPath != 'null' && postImgPath != ''
                                      ? CachedNetworkImageProvider(postImgPath)
                                          as ImageProvider
                                      : const AssetImage(
                                          "assets/Images/Profile.jpg"),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.username,
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                widget.post.postedDate,
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: size.width * 0.035),
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.056),
                            width: 1.0, // Set the height of the line
                            color: kPrimaryColor, // Set the color of the line
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: size.width * 0.6,
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.width * 0.01),
                                child: Text(
                                  widget.body,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.width * 0.05),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.005),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: Column(
                    children: [
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
                              backgroundImage: commentImgPath != 'null' &&
                                      commentImgPath != ''
                                  ? CachedNetworkImageProvider(commentImgPath)
                                      as ImageProvider
                                  : const AssetImage(
                                      "assets/Images/Profile.jpg"),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentAuthorname,
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                status,
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size.width * 0.1),
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
                            controller: _commentController,
                            maxLines: 3, // Allow multiple lines
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: // Margin of 20px
                    ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Get the text from the controller.
                      String replyText = _commentController.text;
                      Navigator.pop(context, replyText);
                    }
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
                    child: loading
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                        : const Text(
                            'Comment',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
