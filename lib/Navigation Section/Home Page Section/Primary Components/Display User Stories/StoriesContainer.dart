import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Components Section/Colour Component/UIColours.dart';
import '../../../../Classes ( New ) Section/Create_New_Stories_Class.dart';
import '../../../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

class StroiesCard extends StatefulWidget {
  final Stories story;
  final String userId;

  const StroiesCard({
    super.key,
    required this.story,
    required this.userId,
  });

  @override
  State<StroiesCard> createState() => _StroiesCardState();
}

class _StroiesCardState extends State<StroiesCard> {
  late Stories story;

  late String imgPath = '';

  @override
  void initState() {
    super.initState();
    story = widget.story;

    getImage();
  }

  Future<void> getImage() async {
    final upload = await getProfileImg(widget.story.storyAuthorId);
    setState(() {
      imgPath = upload;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 246, 198, 234),
            Color.fromARGB(255, 196, 144, 228),
          ],
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
              backgroundImage: imgPath != 'null' && imgPath != ''
                  ? CachedNetworkImageProvider(
                      imgPath,
                    ) as ImageProvider
                  : const AssetImage("assets/Images/Profile.jpg"),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 30,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                side: const BorderSide(
                  color: kPrimaryColor,
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  fontSize: 9,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
