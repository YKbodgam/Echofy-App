import 'package:flutter/material.dart';

import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_Every_Posts_List.dart';
import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_Every_Stories_List.dart';

import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';

import '../../Screens/Stories Screen/Stories_Screen.dart';
import '../../Components Section/Colour Component/UIColours.dart';
import '../../Components Section/Display New Posts/Create_Post_List.dart';
import '../../Components Section/Bottom Sheet Component/Choose_Story_Content.dart';

import 'Primary Components/Display User Stories/StoriesContainer.dart';
import 'Primary Components/Create User Stories/Create_User_Stories_Part_1.dart';
import 'Primary Components/Display User Stories/Display_User_Story_Cards_List.dart';

class HomeSectionPage2 extends StatefulWidget {
  final String userId;
  const HomeSectionPage2({super.key, required this.userId});

  @override
  State<HomeSectionPage2> createState() => _HomeSectionPage2State();
}

class _HomeSectionPage2State extends State<HomeSectionPage2> {
  List<Post> posts = [];
  List<Reply> replies = [];
  List<dynamic> items = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  @override
  void dispose() {
    // Dispose of resources here
    super.dispose();
    posts.clear();
    replies.clear();
  }

  Future<void> updatePosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final updatedPosts = await getAllPostsAndReplies(widget.userId);
      final results = await getallStories(widget.userId);

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
      margin: EdgeInsets.only(top: size.height * 0.01),
      color: Colors.white,
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
                                  size: size, Userid: widget.userId),
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
                                                  userid: widget.userId,
                                                  storylist: item,
                                                )),
                                          ),
                                        );
                                      },
                                      child: displayStoryWidget(
                                        item,
                                        widget.userId,
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) => StoryScreen(
                                                  userid: widget.userId,
                                                  storylist: [item],
                                                )),
                                          ),
                                        );
                                      },
                                      child: StroiesCard(
                                        story: item,
                                        userId: widget.userId,
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
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.01),
                        color: kPrimaryLightColor,
                        child: PostList(widget.userId),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
