// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Display New Posts/Create_Post_List.dart';
import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';
import '../../Components Section/Dialog Card Component/Greeting_Dialog.dart';
import '../../Components Section/Bottom Sheet Component/Choose_Story_Content.dart';

import '../../Screens/Stories Screen/Stories_Screen.dart';

import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_Every_Posts_List.dart';
import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_Every_Stories_List.dart';

import 'Primary Components/Display User Stories/StoriesContainer.dart';
import 'Primary Components/Display User Top Bar/Custom_Home_Navbar.dart';
import 'Primary Components/Create User Stories/Create_User_Stories_Part_1.dart';
import 'Primary Components/Display User Stories/Display_User_Story_Cards_List.dart';

import 'Secondary Components/First Login Cards/User_First_Login_Card_Four.dart';
import 'Secondary Components/First Login Cards/User_First_Login_Card_One.dart';
import 'Secondary Components/First Login Cards/User_First_Login_Card_Three.dart';
import 'Secondary Components/First Login Cards/User_First_Login_Card_Two.dart';

class HomePage extends StatefulWidget {
  final String UserId;
  const HomePage({
    super.key,
    required this.UserId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //

  bool IScontentVisible = false;
  bool allowNavigation = false;
  bool isLoading = false;

  int UserCount = 0;
  int NewPageIndex = 0;

  List<Post> posts = [];
  List<Reply> replies = [];
  List<dynamic> items = [];

  final DatabaseReference usersReference =
      FirebaseDatabase.instance.ref().child('Users');

  @override
  void initState() {
    super.initState();

    _checkFirstLogin();
    updatePosts();
  }

  @override
  void dispose() {
    // Dispose of resources here
    super.dispose();
    posts.clear();
    replies.clear();
  }

  Future<void> _checkFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final firstLogin = prefs.getBool('firstLogin');

    if (firstLogin == true) {
      DatabaseReference userCountSnapshot = usersReference.child(widget.UserId);
      DataSnapshot snapshot = (await userCountSnapshot.once()).snapshot;
      dynamic userCountData = snapshot.value;

      setState(() {
        IScontentVisible = true;
      });

      if (userCountData != null) {
        UserCount = userCountData['Number'] + 1;
      }

      // Show the congratulations dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FirstLoginGreet(Usercount: UserCount);
        },
      );

      // Update the preferences to indicate that the user has logged in
      prefs.setBool('firstLogin', false);
    }
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

  Future<void> updatePosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final updatedPosts = await getAllPostsAndReplies(widget.UserId);
      final results = await getallStories(widget.UserId);

      setState(() {
        posts = updatedPosts.whereType<Post>().toList();
        replies = updatedPosts.whereType<Reply>().toList();
        items = results.toList();
      });
    } catch (e) {
      // Handle errors here
      print('Error in updatePosts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: kPrimaryLightColor, // Set the desired background color
      child: RefreshIndicator(
        onRefresh: updatePosts,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: kPrimaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeNavbar(
                        size: size,
                        UserId: widget.UserId,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Visibility(
                        visible: IScontentVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                size.width * 0.03,
                                size.height * 0.01,
                                size.width * 0.03,
                                0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "New To Echofy : ",
                                    style: GoogleFonts.lobster(
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        IScontentVisible = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close_outlined,
                                      size: 15,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                enableInfiniteScroll:
                                    false, // Set to false to disable infinite scroll
                                disableCenter:
                                    true, // Set to true to disable centering on the current item
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    NewPageIndex = index;
                                  });
                                },
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index, realIndex) {
                                ///

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01,
                                      horizontal: size.width * 0.04),
                                  child: index == 0
                                      ? FirstLoginCardOne(size: size)
                                      : index == 1
                                          ? FirstLoginCardSecond(size: size)
                                          : index == 2
                                              ? FirstLoginCardThird(size: size)
                                              : FirstLoginCardFourth(
                                                  size: size),
                                );
                              },
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 4; i++)
                                  Container(
                                    height: 6.0,
                                    width: NewPageIndex == i ? 30.0 : 6.0,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.01),
                                    decoration: BoxDecoration(
                                      color: NewPageIndex == i
                                          ? kPrimaryColor
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                            horizontal: size.width * 0.03),
                        child: Row(
                          children: [
                            Text(
                              "Moments : ",
                              style: GoogleFonts.lobster(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'View All',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 140,
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        child: Row(
                          children: [
                            // Your additional item here
                            GestureDetector(
                              onTap: () {
                                const ChooseStoryContent();
                              },
                              child: PersonalStoriesCard(
                                  size: size, Userid: widget.UserId),
                            ),

                            // Your list of items
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  var item = items[index];

                                  if (item is List) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) => StoryScreen(
                                                  userid: widget.UserId,
                                                  storylist: item,
                                                )),
                                          ),
                                        );
                                      },
                                      child: displayStoryWidget(
                                        item,
                                        widget.UserId,
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) => StoryScreen(
                                                  userid: widget.UserId,
                                                  storylist: [item],
                                                )),
                                          ),
                                        );
                                      },
                                      child: StroiesCard(
                                        story: item,
                                        userId: widget.UserId,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          size.width * 0.05,
                          size.height * 0.02,
                          size.width * 0.03,
                          size.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Recent Posts : ",
                              style: GoogleFonts.lobster(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.black,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: size.height * 0.01),
                        color: kPrimaryLightColor,
                        child: PostList(widget.UserId),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
