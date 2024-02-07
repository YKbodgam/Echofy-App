import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_User_Body_Text.dart';
import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

import '../Colour Component/UIColours.dart';
import '../../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';

import '../Delete Button Component/Delete_Button_Reply.dart';
import '../Display New Posts/Users_Profile_Img_Liked.dart';

class ReplyCard extends StatefulWidget {
  final Reply reply;
  final Size size;
  final String userId;

  const ReplyCard(
      {super.key,
      required this.reply,
      required this.size,
      required this.userId});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  late Reply reply;
  late Size size;

  late String status = '';
  late String postBody = '';
  late String replyBody = '';

  late String replyAuthorname = '';
  late String postAuthorUsername = '';

  late String replyImgPath = '';
  late String postImgpath = '';

  @override
  void initState() {
    super.initState();
    reply = widget.reply;
    size = widget.size;

    getUsername();
    getLocalPostBody();
    getImage();
    getStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUsername() async {
    final postUser = await getUsernameByUserId(reply.originalAuthorId);
    final replyUser = await getUsernameByUserId(reply.replyAuthorId);

    setState(() {
      postAuthorUsername = postUser;
      replyAuthorname = replyUser;
    });
  }

  Future<void> getLocalPostBody() async {
    final postlame = await getPostBody(reply.originalBodyId);
    final replylame = await getPostBody(reply.replyBodyId);

    setState(() {
      postBody = postlame;
      replyBody = replylame;
    });
  }

  Future<void> getImage() async {
    postImgpath = await getProfileImg(reply.originalAuthorId);
    replyImgPath = await getProfileImg(reply.replyAuthorId);
  }

  Future<void> getStatus() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: replyAuthorname)
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != 'None' || verifiedStatus != null) {
      setState(() {
        status = verifiedStatus;
      });
    } else {
      status = 'Available';
    }
  }

  void like(Function callback) {
    setState(() {
      callback();
    });
  }

  void follows(Function callback) {
    setState(() {
      callback();
    });
  }

  void dislike(Function callback) {
    setState(() {
      callback();
    });
  }

  TimeOfDay parseTime(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1].toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String getTime(String time, String dateString) {
    DateTime currentTime = DateTime.now();
    TimeOfDay originalPostTime = parseTime(time);
    DateTime originalDate = DateFormat('EEE, MMM dd, yyyy').parse(dateString);

    DateTime originalDateTime = DateTime(originalDate.year, originalDate.month,
        originalDate.day, originalPostTime.hour, originalPostTime.minute);

    Duration difference = currentTime.difference(originalDateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes == 1) {
      return '1 minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 14) {
      return '1 week ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => like(
        () => reply.likeRely(widget.userId),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            size.width * 0.03, size.height * 0.01, size.width * 0.03, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          elevation:
              0, // Set the elevation to 0 to remove Card's default shadow
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Adjust the border radius as needed
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.015,
              horizontal: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          replyImgPath != 'null' && replyImgPath != ''
                              ? CachedNetworkImageProvider(replyImgPath)
                                  as ImageProvider
                              : const AssetImage("assets/Images/Profile.jpg"),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              replyAuthorname,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Text(
                              getTime(reply.repliedTime, reply.repliedDate),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            // Text(
                            //   "${reply.UserFollowed.length}  •  Followers",
                            //   style: const TextStyle(
                            //     fontSize: 10,
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ],
                        ),
                        Text(
                          "Replying To $postAuthorUsername",
                          style: TextStyle(
                            fontSize: 10,
                            color: kPrimaryColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 30, // Margin of 20px
                      child: reply.replyAuthorId == widget.userId
                          ? buildDeleteButton(reply, context)
                          : reply.userRequested.contains(widget.userId)
                              ? OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                    side: const BorderSide(
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  child: const Text(
                                    'Requested',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                )
                              : reply.userFollowers.contains(widget.userId)
                                  ? const Text(
                                      'Followed',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: kPrimaryColor,
                                          fontStyle: FontStyle.italic),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => follows(
                                        () => reply.Request(widget.userId),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(45)),
                                        side: const BorderSide(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      child: const Text(
                                        'Follow',
                                        style: TextStyle(
                                            fontSize: 11, color: kPrimaryColor),
                                      ),
                                    ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.008),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(size.width * 0.05,
                          size.width * 0.01, size.width * 0.01, 0),
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.05,
                      ),
                      width: 1.2,
                      color: kPrimaryColor, // Set the color of the line
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    Container(
                      width: size.width * 0.75,

                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kPrimaryColor, // Set the border color
                          width: 0.5, // Set the border width
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 25, // Set the desired width
                                height: 25, // Set the desired height
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(
                                        0.5), // Set the border color
                                    width: 1, // Set the border width
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: postImgpath != 'null' &&
                                          postImgpath != ''
                                      ? CachedNetworkImageProvider(postImgpath)
                                          as ImageProvider
                                      : const AssetImage(
                                          "assets/Images/Profile.jpg"),
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Text(
                                postAuthorUsername,
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                reply.repliedDate,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.width * 0.01),
                          Padding(
                            padding: EdgeInsets.all(size.width * 0.01),
                            child: Text(
                              postBody,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          SizedBox(height: size.width * 0.01),
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "See Original",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: kPrimaryColor.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      //
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.01),
                  child: Text(
                    replyBody,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                // SizedBox(height: size.height * 0.01),
                // Center(
                //   child: Container(
                //     height: 1.0, // Set the height of the line
                //     color: kPrimaryColor, // Set the color of the line
                //   ),
                // ),
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: widget.size.width * 0.03),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => like(
                          () => widget.reply.likeRely(widget.userId),
                        ),
                        color: widget.reply.userLiked.contains(widget.userId)
                            ? kPrimaryColor
                            : Colors.grey,
                        icon: widget.reply.userLiked.contains(widget.userId)
                            ? const Icon(Icons.favorite_outlined)
                            : const Icon(Icons.favorite_border_outlined),
                        iconSize: 15,
                      ),
                      Text(
                        widget.reply.userLiked.length.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: widget.size.width * 0.005,
                      ),
                      IconButton(
                        onPressed: () =>
                            dislike(() => widget.reply.disliked(widget.userId)),
                        color: widget.reply.userDisliked.contains(widget.userId)
                            ? kPrimaryColor
                            : Colors.grey,
                        icon: widget.reply.userDisliked.contains(widget.userId)
                            ? const Icon(Icons.thumb_down)
                            : const Icon(Icons.thumb_down_alt_outlined),
                        iconSize: 15,
                      ),
                      Text(
                        widget.reply.userDisliked.length.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: widget.size.width * 0.005,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: kPrimaryColor,
                          size: 15,
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "You Can't share Now...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      ),
                      Text(
                        '0',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_outline_outlined,
                          color: kPrimaryColor,
                          size: 15,
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "You Can't Bookmark Post Now...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                reply.userLiked.isNotEmpty
                    ? likedByWidget(
                        reply.userLiked
                            .map((userId) => userId.toString())
                            .toList(),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: Text(
                          "* No One Liked Till Now",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey,
                            size: 16,
                          ),
                          Text(
                            " 0  comments",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${reply.repliedTime}  •  ${reply.repliedDate}  ",
                      style: const TextStyle(
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      "•  ${reply.userViewed.length} Views",
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
