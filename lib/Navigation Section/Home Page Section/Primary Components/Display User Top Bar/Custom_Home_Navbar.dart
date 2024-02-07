import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_Popular_Hashtags_List.dart';

import '../../../../Components Section/Colour Component/UIColours.dart';
import '../../../../Components Section/Checkbox Buttons Component/Select_Popular_Hashtag_Button.dart';

import '../../../Notification Page Section/NotificationPage.dart';
import '../../../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';
import '../../../../User Section/Authenticate User Section/Get_User_Unique_name.dart';

class HomeNavbar extends StatefulWidget {
  final Size size;
  final String UserId;

  const HomeNavbar({
    super.key,
    required this.size,
    required this.UserId,
  });

  @override
  State<HomeNavbar> createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {
  late String Imgpath = '';
  late String alterUsername = '';

  bool LoadTags = false;

  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    getImage();
    getUsername();
    GetTags();
  }

  Future<void> getImage() async {
    Imgpath = await getProfileImg(widget.UserId);
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.UserId);
    setState(() {
      alterUsername = user;
    });
  }

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Future<void> GetTags() async {
    setState(() {
      LoadTags = true;
    });
    tags = await getPopularHashtags();
    setState(() {
      LoadTags = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: widget.size.height * 0.02,
      ),
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Color.fromARGB(255, 242, 175, 229),
        //     Color.fromARGB(255, 196, 153, 243),
        //   ],
        // ),
        color: const Color.fromARGB(255, 222, 178, 253),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.04,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  width: 40, // Set the desired width
                  height: 40, // Set the desired height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: kPrimaryColor, // Set the border color
                      width: 1, // Set the border width
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(
                            Userid: widget.UserId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.size.width * 0.03,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60, // Set the desired width
                  height: 60,
                  padding: const EdgeInsets.all(2.0), // Set the desired height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
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
                SizedBox(
                  width: widget.size.width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi $alterUsername",
                      style: GoogleFonts.robotoSlab(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        color: kPrimaryColor.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      getGreeting(),
                      style: GoogleFonts.aladin(
                        textStyle: const TextStyle(fontSize: 35),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.size.height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widget.size.width * 0.04,
                vertical: widget.size.height * 0.01),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                border: Border.all(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                onChanged: (text) {
                  setState(() {});
                },
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: kPrimaryColor,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 10, 3),
                  border: InputBorder.none,
                  hintText: 'Search by Username or Hashtags :',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: widget.size.width * 0.05,
              top: widget.size.height * 0.01,
            ),
            child: Text(
              "Popular Hashtags : ",
              style: GoogleFonts.openSans(
                textStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                color: kPrimaryColor.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: widget.size.width * 0.02,
            ),
            child: SizedBox(
              height: 50, // Set a fixed height here
              child: LoadTags
                  ? ListView(
                      children: List.generate(
                        // Generate loading skeleton cards based on the length of the list
                        tags.length,
                        (index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child:
                                BuildPopularTags(tags[index], context, false),
                          ),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(
            height: widget.size.height * 0.02,
          ),
        ],
      ),
    );
  }
}
