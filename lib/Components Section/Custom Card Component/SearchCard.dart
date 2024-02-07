import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Notification Section/Send_User_Notification.dart';
import '../Colour Component/UIColours.dart';

import '../../User Section/Authenticate User Section/Get_User_Identification.dart';
import '../../User Section/Request Authentication Section/Send_User_Follow_Request.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Following_info.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Followers_List.dart';
import '../../User Section/Request Authentication Section/Fetch_User_Requested_List.dart';

class UserlistCard extends StatefulWidget {
  final String LoginAuthorId;
  final String Username;
  const UserlistCard(
      {super.key, required this.Username, required this.LoginAuthorId});

  @override
  State<UserlistCard> createState() => _UserlistCardState();
}

class _UserlistCardState extends State<UserlistCard> {
  late String Imgpath = '';
  late String userId = '';
  late String Status = '';

  List Followers = [];
  List Requested = [];

  @override
  void initState() {
    super.initState();
    getImage(widget.Username);
    GetStatus();
    getlist();
  }

  @override
  void dispose() {
    super.dispose();
    Followers.clear();
    Requested.clear();
  }

  Future<void> getImage(String name) async {
    userId = await getUserIdByUsername(name);
    Imgpath = await getProfileImg(userId);
  }

  Future<void> getlist() async {
    final userid = await getUserIdByUsername(widget.Username);
    final follower = await getFollowersList(userid);
    final Request = await getRequestedList(userid);

    setState(() {
      Followers = follower;
      Requested = Request;
    });
  }

  Future<void> GetStatus() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: widget.Username)
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != null &&
        verifiedStatus != '' &&
        verifiedStatus != 'None') {
      setState(() {
        Status = verifiedStatus;
      });
    } else {
      setState(() {
        Status = 'Available';
      });
    }
  }

  void Follows(String currentUserId) async {
    final postUserId = await getUserIdByUsername(widget.Username);
    final following = await isCurrentUserFollowing(currentUserId, postUserId);

    if (!following) {
      await sendUserRequest(currentUserId, postUserId);
      setState(() {
        Requested.add(currentUserId); // Refresh follower data
      });
    }
    setState(() {
      NotifyUser(
        currentUserId,
        postUserId,
        'Special',
        'Request',
        '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
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
              vertical: size.height * 0.01,
              horizontal: size.width * 0.025,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50, // Set the desired width
                  height: 50, // Set the desired height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: kPrimaryColor, // Set the border color
                      width: 1, // Set the border width
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.0),
                    child: Image(
                      image: Imgpath != 'null' && Imgpath != ''
                          ? CachedNetworkImageProvider(Imgpath) as ImageProvider
                          : const AssetImage("assets/Images/Profile.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.Username,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      Status,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 30, // Margin of 20px
                  child: Requested.contains(widget.LoginAuthorId)
                      ? OutlinedButton(
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: "You Can't unfollow Now",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
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
                              fontSize: 10,
                              color: kPrimaryColor,
                            ),
                          ),
                        )
                      : Followers.contains(widget.LoginAuthorId)
                          ? OutlinedButton(
                              onPressed: () {
                                Fluttertoast.showToast(
                                  msg: "You Can't unfollow Now",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 10,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: kPrimaryColor.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                              child: const Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () => Follows(widget.LoginAuthorId),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                side: const BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: kPrimaryColor,
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
