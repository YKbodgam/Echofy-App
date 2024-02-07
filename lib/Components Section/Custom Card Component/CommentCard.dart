import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_User_Body_Text.dart';
import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

import '../Colour Component/UIColours.dart';
import '../../Classes ( New ) Section/Create_New_Post_Comment_Class.dart';

class CommentCard extends StatefulWidget {
  final Comments postComment;
  final String userId;

  const CommentCard({
    super.key,
    required this.postComment,
    required this.userId,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late String imgPath = '';
  late String commentBody = '';
  late String commentAuthorname = '';

  @override
  void initState() {
    super.initState();

    getImage();
    getUsername();
    getLocalPostBody();
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.postComment.commentAuthorId);
    setState(() {
      commentAuthorname = user;
    });
  }

  Future<void> getLocalPostBody() async {
    final lame = await getPostBody(widget.postComment.commentBodyId);
    setState(() {
      commentBody = lame;
    });
  }

  Future<void> getImage() async {
    imgPath = await getProfileImg(widget.postComment.commentAuthorId);
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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45.0),
                  border: Border.all(
                    color: kPrimaryColor, // Set the border color
                    width: 1, // Set the border width
                  ),
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage: imgPath != 'null' && imgPath != ''
                      ? CachedNetworkImageProvider(imgPath) as ImageProvider
                      : const AssetImage("assets/Images/Profile.jpg"),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                commentAuthorname,
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(fontSize: 11),
                ),
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Column(
                children: [
                  Text(
                    getTime(widget.postComment.commentedTime,
                        widget.postComment.commentedDate),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
              size.width * 0.075,
              0,
              size.width * 0.01,
              size.height * 0.005,
            ),
            padding: EdgeInsets.all(size.width * 0.01),
            child: Text(
              commentBody,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(fontSize: 11),
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                child: Text(
                  "See More  >",
                  style: TextStyle(
                    fontSize: 9,
                    color: kPrimaryColor.withOpacity(0.8),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
