import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Image Loader Component/ImageLoadingCont.dart';
import '../Login_Screen/Login_Screen_main.dart';
import '../Update_Profilr_Screen/Update_Profile_main.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

class ProfileScreen extends StatefulWidget {
  final String UserId;
  const ProfileScreen({
    super.key,
    required this.UserId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  bool ploading = false;
  bool allowNavigation = false;

  late String Status = "";
  late String alterUsername = '';

  late String Imgpath = 'null';
  late String UserIdAfter = '';

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(widget.UserId);
    setState(() {
      alterUsername = user;
    });
  }

  @override
  void initState() {
    super.initState();
    GetStatus();
    getUsername();
    getImage();
  }

  Future<void> getImage() async {
    setState(() {
      ploading = true;
    });
    Imgpath = await getProfileImg(widget.UserId);
    setState(() {
      ploading = false;
    });
  }

  String _getMonth(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> updateOnline(String username) async {
    // Get the current timestamp
    final DateTime now = DateTime.now();
    final formattedDate =
        "${_getMonth(now.month)} ${now.day}, ${now.year} ${_formatTime(now)}";

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;

        await FirebaseFirestore.instance.collection('Users').doc(userId).update(
          {
            'State': 'Offline',
            'Last_Online': formattedDate,
          },
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    await prefs.remove('userId');
    updateOnline(
      await getUsernameByUserId(widget.UserId),
    );
    // Update Firestore to mark the user as logged out.
  }

  Future<void> GetStatus() async {
    setState(() {
      isLoading = true;
    });
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: await getUsernameByUserId(widget.UserId))
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != 'None' || verifiedStatus != null) {
      setState(() {
        Status = verifiedStatus;
      });
    } else {
      Status = 'Available';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white, // Set the desired background color
      child: RefreshIndicator(
        onRefresh: GetStatus,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: kPrimaryColor,
                ),
              )
            : WillPopScope(
                onWillPop: () async {
                  // Prevent navigation when allowNavigation is false (during the login process)
                  if (!allowNavigation) {
                    return false;
                  }
                  return true; // Allow navigation for other screens
                },
                child: ListView(
                  // Use ListView for scrollability
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(size.width * 0.08),
                      child: Column(
                        children: <Widget>[
                          // Profile Picture and QR Code
                          Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProfileScreen(
                                        UserId: widget.UserId,
                                        Status: Status,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: kPrimaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: Imgpath != 'null' &&
                                            Imgpath != ''
                                        ? CachedNetworkImageProvider(Imgpath)
                                            as ImageProvider
                                        : const AssetImage(
                                            "assets/Images/Profile.jpg"),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: size.height * 0.08,
                                left: size.height * 0.08,
                                child: ploading
                                    ? buildLoadingContainer()
                                    : const SizedBox.shrink(),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.03),

                          Text(alterUsername,
                              style: const TextStyle(fontSize: 20)),
                          Text(Status, style: const TextStyle(fontSize: 16)),

                          SizedBox(height: size.height * 0.03),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              // Button 1
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.groups_outlined),
                                    color: kPrimaryColor,
                                    iconSize: size.height * 0.04,
                                    onPressed: () {
                                      // Handle button 1 press
                                    },
                                  ),
                                  const Text('Friends'),
                                ],
                              ),

                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(
                                        Icons.person_outline_outlined),
                                    color: kPrimaryColor,
                                    iconSize: size.height * 0.04,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateProfileScreen(
                                            UserId: widget.UserId,
                                            Status: Status,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Text('Profile'),
                                ],
                              ),

                              // Button 2
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.search_outlined),
                                    color: kPrimaryColor,
                                    iconSize: size.height * 0.04,
                                    onPressed: () {
                                      // Handle button 2 press
                                    },
                                  ),
                                  const Text('Search'),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.05),

                          ListTile(
                            leading: Container(
                              width: size.width * 0.12,
                              height: size.width * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: kPrimaryLightColor,
                              ),
                              child: const Icon(
                                Icons.settings_outlined,
                                color: kPrimaryColor,
                                size: 22.0,
                              ),
                            ),
                            title: const Text("Settings"),
                            trailing: Container(
                              width: size.width * 0.08,
                              height: size.width * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Colors.grey,
                                size: 18.0,
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.01),

                          ListTile(
                            leading: Container(
                              width: size.width * 0.12,
                              height: size.width * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: kPrimaryLightColor,
                              ),
                              child: const Icon(
                                Icons.account_circle_outlined,
                                color: kPrimaryColor,
                                size: 22.0,
                              ),
                            ),
                            title: const Text("Account"),
                            trailing: Container(
                              width: size.width * 0.08,
                              height: size.width * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Colors.grey,
                                size: 18.0,
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.02),

                          const Divider(
                            thickness: 1,
                            color: kPrimaryColor,
                          ),

                          SizedBox(height: size.height * 0.02),

                          ListTile(
                            leading: Container(
                              width: size.width * 0.12,
                              height: size.width * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: kPrimaryLightColor,
                              ),
                              child: const Icon(
                                Icons.info_outlined,
                                color: kPrimaryColor,
                                size: 22.0,
                              ),
                            ),
                            title: const Text("About App"),
                            trailing: Container(
                              width: size.width * 0.08,
                              height: size.width * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Colors.grey,
                                size: 18.0,
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.01),

                          ListTile(
                            onTap: () {
                              logout();
                              Fluttertoast.showToast(
                                msg: "Log Out successfully ! ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              setState(() {
                                allowNavigation =
                                    true; // Enable navigation after login
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            leading: Container(
                              width: size.width * 0.12,
                              height: size.width * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red.withOpacity(0.1),
                              ),
                              child: Icon(
                                Icons.logout_outlined,
                                color: Colors.red.withOpacity(0.5),
                                size: 22.0,
                              ),
                            ),
                            title: const Text(
                              "Log Out",
                              style: TextStyle(color: Colors.red),
                            ),
                            trailing: Container(
                              width: size.width * 0.08,
                              height: size.width * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red.withOpacity(0.1),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Colors.red.withOpacity(0.5),
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
