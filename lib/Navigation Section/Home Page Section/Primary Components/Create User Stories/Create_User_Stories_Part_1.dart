// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'Create_User_Stories_Part_2.dart';

import '../../../../Components Section/Bottom Sheet Component/Choose_Story_Content.dart';
import '../../../../Components Section/Colour Component/UIColours.dart';

import '../../../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';
import '../../../../User Section/Authenticate User Section/Get_User_Unique_name.dart';

class PersonalStoriesCard extends StatefulWidget {
  final Size size;
  final String Userid;
  final bool isPresent;

  const PersonalStoriesCard({
    super.key,
    required this.size,
    required this.Userid,
    this.isPresent = false,
  });

  @override
  State<PersonalStoriesCard> createState() => _PersonalStoriesCardState();
}

class _PersonalStoriesCardState extends State<PersonalStoriesCard> {
  late Size size;
  late String Altername = '';
  late String Imgpath = '';

  @override
  void initState() {
    super.initState();
    size = widget.size;
    getImage();
    getUsername();
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.Userid);
    setState(() {
      Altername = user;
    });
  }

  Future<void> getImage() async {
    Imgpath = await getProfileImg(widget.Userid);
  }

  Future<void> CreateNewStory() async {
    List result = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Adjust the radius as needed
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return const ChooseStoryContent();
      },
    );

    if (result[0] != 'Null') {
      if (result[0] == 'Image') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckStory(
              MediaType: 'Image',
              UserId: widget.Userid,
              Url: result[1],
            ),
          ),
        );
      } else if (result[0] == 'Text') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckStory(
              MediaType: 'Text',
              UserId: widget.Userid,
              Url: result[1],
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckStory(
              MediaType: 'Video',
              UserId: widget.Userid,
              Url: result[1],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CreateNewStory();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(15.0),
          dashPattern: const [10, 10],
          color: kPrimaryColor,
          strokeWidth: 1.5,
          child: Container(
            width: 95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 40, // Set the desired width
                  height: 40,
                  padding: const EdgeInsets.all(2.0), // Set the desired height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: kPrimaryColor, // Set the border color
                      width: 1, // Set the border width
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: Imgpath != 'null' && Imgpath != ''
                        ? CachedNetworkImageProvider(
                            Imgpath,
                          ) as ImageProvider
                        : const AssetImage("assets/Images/Profile.jpg"),
                  ),
                ),
                Container(
                  height: 30,
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
                      CreateNewStory();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      side: const BorderSide(
                        color: kPrimaryColor,
                      ),
                      backgroundColor: kPrimaryColor.withOpacity(0.8),
                    ),
                    child: const Text(
                      'Create',
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
      ),
    );
  }
}



// 