import 'package:cached_network_image/cached_network_image.dart';
import 'package:echofy_app/User%20Section/Request%20Authentication%20Section/Allow_User_Follow_Request.dart';
import 'package:echofy_app/User%20Section/Request%20Authentication%20Section/Deny_User_Follow_Request.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colour Component/UIColours.dart';
import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

class RequestCard extends StatefulWidget {
  final String RequesterId;
  final String UserId;
  const RequestCard({
    super.key,
    required this.UserId,
    required this.RequesterId,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late String RequestName = '';
  late String alterUsername = '';
  late String Imgpath = '';

  @override
  void initState() {
    super.initState();
    getnames();
  }

  Future<void> getnames() async {
    final user = await getUsernameByUserId(widget.UserId);
    final requester = await getUsernameByUserId(widget.RequesterId);
    setState(() {
      RequestName = requester;
      alterUsername = user;
    });
  }

  Future<void> getImage() async {
    Imgpath = await getProfileImg(widget.RequesterId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
        elevation: 0, // Set the elevation to 0 to remove Card's default shadow
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Adjust the border radius as needed
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.012,
            horizontal: size.width * 0.03,
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
                    'Follow Request',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    '$RequestName Wants to follow you',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 30, // Margin of 20px
                        child: OutlinedButton(
                          onPressed: () {
                            allowUserRequest(widget.UserId, widget.RequesterId);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45),
                            ),
                            side: const BorderSide(
                              color: kPrimaryColor,
                            ),
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      SizedBox(
                        height: 30, // Margin of 20px
                        child: OutlinedButton(
                          onPressed: () {
                            rejectUserRequest(
                                widget.UserId, widget.RequesterId);
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
                            'Decline',
                            style: TextStyle(
                              fontSize: 11,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
