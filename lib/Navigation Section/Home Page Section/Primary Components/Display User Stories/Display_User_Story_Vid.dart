import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Classes ( New ) Section/Create_New_Stories_Class.dart';
import '../../../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';
import '../../../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_User_Body_Text.dart';

class VideoDisplayScreen extends StatefulWidget {
  final Size size;
  final String userId;
  final Stories story;
  final VideoPlayerController videoPlayerController;

  const VideoDisplayScreen({
    super.key,
    required this.userId,
    required this.story,
    required this.size,
    required this.videoPlayerController,
  });

  @override
  State<VideoDisplayScreen> createState() => _VideoDisplayScreenState();
}

class _VideoDisplayScreenState extends State<VideoDisplayScreen> {
  late VideoPlayerController _controller;
  late Size size;

  late String status = '';
  late String imgPath = '';
  late String storyAuthorname = '';
  late String storyBody = '';

  @override
  void initState() {
    super.initState();
    size = widget.size;
    _controller = widget.videoPlayerController;

    getUsername().then(
      (value) => getStatus(),
    );
    getLocalPostBody();
    getImage();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.story.storyAuthorId);
    setState(() {
      storyAuthorname = user;
    });
  }

  Future<void> getImage() async {
    imgPath = await getProfileImg(widget.story.storyAuthorId);
  }

  Future<void> getLocalPostBody() async {
    final lame = await getPostBody(widget.story.storyDescriptionId);
    setState(() {
      storyBody = lame;
    });
  }

  Future<void> getStatus() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where(
          'Username',
          isEqualTo: storyAuthorname,
        )
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != '' && verifiedStatus != null) {
      setState(() {
        status = verifiedStatus;
      });
    } else {
      setState(() {
        status = 'Available';
      });
    }
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
      return '1 min ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours == 1) {
      return '1 hr ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: widget.story.storyContentRatio[0] == 'isfill'
                  ? 0.0
                  : size.height * 0.1,
              horizontal: widget.story.storyContentRatio[1] == 'width'
                  ? 0.0
                  : size.width * 0.05,
            ),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          left: 4.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40, // Set the desired width
                  height: 40,
                  padding: const EdgeInsets.all(2.0), // Set the desired height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    border: Border.all(
                      color: Colors.white, // Set the border color
                      width: 1, // Set the border width
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: imgPath != 'null' && imgPath != ''
                        ? CachedNetworkImageProvider(imgPath) as ImageProvider
                        : const AssetImage("assets/Images/Profile.jpg"),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          storyAuthorname,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.04,
                        ),
                        Text(
                          getTime(widget.story.storyTime,
                                  widget.story.storyDate)
                              .toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.story.storyDescriptionId != '',
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ),
              child: Container(
                height: size.height * 0.1,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.015,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(220, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      storyBody,
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
      ],
    );
  }
}
