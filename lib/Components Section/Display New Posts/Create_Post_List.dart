import 'package:flutter/material.dart';

import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';
import '../Custom Card Component/PostCard.dart';
import '../Custom Card Component/ReplyCard.dart';

import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_Every_Posts_List.dart';
import '../Shimmer Loading Component/Post_Loader.dart';
import '../Shimmer Loading Component/Reply_Loader.dart';

class PostList extends StatefulWidget {
  final String UserId;

  const PostList(this.UserId, {super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    // Call your method to fetch and prepare data
    List<dynamic> result = await getAllPostsAndReplies(widget.UserId);

    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];

        if (item is Post) {
          return buildPostUI(item, size);
        } else {
          // Render Reply UI
          return buildReplyUI(item, size);
        }
      },
    );
  }

  Widget buildPostUI(Post post, Size size) {
    // Call onViewed when post is displayed
    post.onViewed(widget.UserId);

    return FutureBuilder(
      future: initializeFollowingInfo(post),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Data has been fetched, now build the actual UI
          return PostCard(
            post: post,
            userId: widget.UserId,
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return Text("Error: ${snapshot.error}");
        } else {
          // Data is still being fetched, show the skeleton loader
          return PostSkeletonLoader(
            size: size,
            post: post,
          );
        }
      },
    );
  }

  Future<void> initializeFollowingInfo(Post post) async {
    try {
      // Perform the asynchronous initialization
      await post.initializeFollowingInfo();
    } catch (error) {
      // Handle any errors that occur during initialization
      print("Error initializing following info: $error");
      // You might want to throw the error or take appropriate action
    }
  }

  Widget buildReplyUI(Reply reply, Size size) {
    reply.onViewed(widget.UserId);
    return FutureBuilder(
      future: reply.initializeFollowingInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Data has been fetched, now build the actual UI
          return ReplyCard(
            reply: reply,
            size: size,
            userId: widget.UserId,
          );
        } else {
          // Data is still being fetched, show the skeleton loader
          return ReplySkeletonLoader(size);
        }
      },
    );
  }
}
