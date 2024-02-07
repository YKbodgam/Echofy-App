// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:echofy_app/Navigation%20Section/Home%20Page%20Section/HomePage2.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../Profile_Screen/Profile_Screen_main.dart';
import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Create New Post Component/Create_New_Post.dart';

import '../../Navigation Section/Home Page Section/HomePage.dart';
import '../../Navigation Section/Search Page Section/SearchPage.dart';
import '../../Navigation Section/Notification Page Section/NotificationPage.dart';
import '../../Navigation Section/Bottom Navigation Section/Custom_Bottom_Nav_Bar.dart';
import '../../Authentication Section/Database_Authentication/Update User Database/Update_Unique_Device_Token.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../Notification Section/User_Notification_Services.dart';

class HomeScreen extends StatefulWidget {
  final String UserId;
  final int index;

  const HomeScreen({
    super.key,
    required this.UserId,
    this.index = 2,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _navigationkey = GlobalKey<CurvedNavigationBarState>();

  bool isLoading = false;
  bool allowNavigation = false;

  late int _selectedIndex = 2;
  late String alterUsername = '';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    getUsername();
    UpdateToken(widget.UserId);
    IsTokenRefreshed(widget.UserId);
    SetUpInteractMessage(context, widget.UserId);
    firebaseNotificationInit(context, widget.UserId);
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.UserId);
    setState(() {
      alterUsername = user;
    });
  }

  Future _onItemTapped(int index) async {
    //

    setState(() {
      _selectedIndex = index;
    });

    //
    if (_selectedIndex == 2) {
      //
      final result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.85,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 4.0,
                      width: 40.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              CreatePost(
                                Username: alterUsername,
                                userId: widget.UserId,
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

      // final result = await showModalBottomSheet(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return CreatePost(Username: alterUsername);
      //   },
      // );

      if (result != null) {
        setState(() {
          _selectedIndex = 2;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _navigationkey,
          buttonBackgroundColor: kPrimaryColor,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            CustomNavBarItem(
              icon: Icons.home_filled,
              isActive: _selectedIndex == 0,
            ),
            CustomNavBarItem(
              icon: Icons.search_outlined,
              isActive: _selectedIndex == 1,
            ),
            CustomNavBarItem(
              icon: Icons.add_outlined,
              isActive: _selectedIndex == 2,
              isBig: true,
            ),
            CustomNavBarItem(
              icon: Icons.settings_outlined,
              isActive: _selectedIndex == 3,
            ),
            CustomNavBarItem(
              icon: Icons.person_outline_outlined,
              isActive: _selectedIndex == 4,
            ),
          ],
          height: 60,
          index: _selectedIndex,
          onTap: _onItemTapped,
        ),
        extendBody: true,
        body: _selectedIndex == 0
            ? HomePage(UserId: widget.UserId)
            : _selectedIndex == 1
                ? SearchPage(Userid: widget.UserId)
                : _selectedIndex == 2
                    ? HomeSectionPage2(userId: widget.UserId)
                    : _selectedIndex == 3
                        ? NotificationPage(Userid: widget.UserId)
                        : ProfileScreen(UserId: widget.UserId),
      ),
    );
    // Container(
    //   color: kPrimaryColor,
    //   child: SafeArea(
    //     top: false,
    //     child: ClipRect(
    //       child: Scaffold(
    //         appBar: AppBar(
    //           elevation: 3,
    //           toolbarHeight: 60,
    //           backgroundColor: Colors.white,
    //           automaticallyImplyLeading: false,
    //           title: Row(
    //             children: [
    //               GestureDetector(
    //                 onTap: () {
    //                   setState(() {
    //                     allowNavigation = true; // Enable navigation after login
    //                   });

    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => ProfileScreen(UserId: userId),
    //                     ),
    //                   );
    //                 },
    //                 child: Container(
    //                   width: 30, // Set the desired width
    //                   height: 30, // Set the desired height
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(45.0),
    //                     border: Border.all(
    //                       color: kPrimaryColor, // Set the border color
    //                       width: 1, // Set the border width
    //                     ),
    //                   ),
    //                   child: CircleAvatar(
    //                     backgroundImage: Imgpath != 'null' && Imgpath != ''
    //                         ? CachedNetworkImageProvider(
    //                             Imgpath,
    //                           ) as ImageProvider
    //                         : const AssetImage("assets/Images/Profile.jpg"),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(width: size.width * 0.04),
    //               Text(
    //                 "Echofy",
    //                 style: GoogleFonts.lobster(
    //                   textStyle: const TextStyle(fontSize: 22),
    //                   color: kPrimaryColor,
    //                 ),
    //               ),
    //               const Spacer(),
    //               Image.asset(
    //                 'assets/Images/Group.png', // Replace 'your_image.png' with the path to your image asset
    //                 width: 35, // Set the width of the image
    //                 height: 35, // Set the height of the image
    //               ),
    //             ],
    //           ),
    //         ),
  }
}
