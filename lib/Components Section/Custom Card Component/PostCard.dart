import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_User_Banner_Img.dart';
import '../../Authentication Section/Database_Authentication/Fetch From Database/Fetch_User_Body_Text.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';
import '../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

import '../Classic Image Component/ImgWithRatioCont.dart';
import '../Classic Image Component/ImgWithoutRatioCont.dart';
import '../Classic Image Component/SliderRatioContNet.dart';

import '../Colour Component/UIColours.dart';
import '../../Classes ( New ) Section/Create_New_Post_Comment_Class.dart';
import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../Class Methods ( New ) Section/Create_New_Comment_Class_Method.dart';
import '../../Class Methods ( New ) Section/Create_New_Reply_Class_Method.dart';

import '../Delete Button Component/Delete_Button_Post.dart';
import '../Dialog Card Component/New_Comment_Dialog.dart';
import '../Dialog Card Component/Reply_Dialog_Post.dart';
import '../Display New Posts/Users_Profile_Img_Liked.dart';
import '../Shimmer Loading Component/Comment_Loader.dart';
import 'CommentCard.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final String userId;

  const PostCard({super.key, required this.post, required this.userId});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post post;

  late String imgpath = '';
  late String postBody = '';

  bool ploading = false;
  bool isCommentVisible = false;
  late double? nullRatio;

  int newPageIndex = 0;

  late String status = '';
  late String timeAgo = '';
  late String postAuthorname = '';

  Map<String, double?> contentImgPath = {};
  List<MapEntry<String, double?>> contentImglist = [];
  List<String> originalKey = [];

  @override
  void initState() {
    super.initState();
    post = widget.post;
    getUsername().then(
      (value) => getStatus(),
    );
    getImage();
    getPostBannerImg();
    getLocalPostBody();
  }

  Future<void> getUsername() async {
    final user = await getUsernameByUserId(post.postAuthorId);
    setState(() {
      postAuthorname = user;
    });
  }

  Future<void> getPostBannerImg() async {
    if (post.postBannerImgId != '') {
      final postbanner = await getBannerImgUrl(post.postBannerImgId);

      setState(() {
        contentImgPath.addAll(postbanner);
        contentImglist = postbanner.entries.toList();
      });
    } else {
      contentImglist = [];
    }
  }

  Future<void> getImage() async {
    imgpath = await getProfileImg(post.postAuthorId);
  }

  Future<void> getStatus() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username', isEqualTo: postAuthorname)
        .get();

    final userDoc = querySnapshot.docs.first;
    final verifiedStatus = userDoc.data()['Status'];

    if (verifiedStatus != null &&
        verifiedStatus != '' &&
        verifiedStatus != 'None') {
      setState(() {
        status = verifiedStatus;
      });
    } else {
      setState(() {
        status = 'Available';
      });
    }
  }

  Future<void> getLocalPostBody() async {
    final lame = await getPostBody(post.postBodyId);
    setState(() {
      postBody = lame;
    });
  }

  void like(Function callback) {
    setState(() {
      callback();
    });
  }

  void follows(Function callback) {
    setState(() {
      callback();
    });
  }

  void dislike(Function callback) {
    setState(() {
      callback();
    });
  }

  TimeOfDay parseTime(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1].toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String getTime(String time, String dateString) {
    DateTime currentTime = DateTime.now();
    TimeOfDay originalPostTime = parseTime(time);
    DateTime originalDate = DateFormat('EEE, MMM dd, yyyy').parse(dateString);

    DateTime originalDateTime = DateTime(originalDate.year, originalDate.month,
        originalDate.day, originalPostTime.hour, originalPostTime.minute);

    Duration difference = currentTime.difference(originalDateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes == 1) {
      return '1 minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 14) {
      return '1 week ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  String unsanitizeKey(String sanitizedKey) {
    // Replace the substituted characters back to their original values
    String Semi = sanitizedKey.replaceAll('_', '/');
    return Semi.replaceAll('+', '.');
  }

  double? getRatio() {
    if (contentImglist.isNotEmpty) {
      MapEntry<String, double?> entry = contentImglist[0];
      return entry.value;
    } else {
      return null;
    }
  }

  List<String> getImagepath(int? index) {
    if (index == null) {
      originalKey.add(unsanitizeKey(contentImglist[0].key));
    } else {
      for (int i = 0; i < contentImglist.length; i++) {
        originalKey.add(unsanitizeKey(contentImglist[i].key));
      }
    }
    return originalKey;
  }

  // void getImageDimensions(String imageUrl) {
  //   if (imageUrl != '' && imageUrl != 'null') {
  //     final Image image = Image.network(imageUrl);

  //     image.image.resolve(const ImageConfiguration()).addListener(
  //       ImageStreamListener((ImageInfo info, bool _) {
  //         imageWidth = info.image.width.toDouble();
  //         imageHeight = info.image.height.toDouble();
  //         aspectRatio = imageWidth / imageHeight;
  //       }),
  //     );
  //   } else {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: GestureDetector(
        onDoubleTap: () => like(
          () => widget.post.likePost(widget.userId),
        ),
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
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Card(
            elevation:
                0, // Set the elevation to 0 to remove Card's default shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  15), // Adjust the border radius as needed
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.025,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: imgpath != 'null' && imgpath != ''
                                ? CachedNetworkImageProvider(imgpath)
                                    as ImageProvider
                                : const AssetImage("assets/Images/Profile.jpg"),
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    postAuthorname,
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  Text(
                                    getTime(post.postedTime, post.postedDate),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          post.postAuthorId == widget.userId
                              ? buildDeleteButton(post, context)
                              : post.userRequested.contains(widget.userId)
                                  ? OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        side: const BorderSide(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      child: const Text(
                                        'Requested',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    )
                                  : post.userFollowers.contains(widget.userId)
                                      ? const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            'Followed',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: kPrimaryColor,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 30,
                                          child: OutlinedButton(
                                            onPressed: () => follows(
                                              () => post.Request(widget.userId),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                              ),
                                              side: const BorderSide(
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                            child: const Text(
                                              'Follow',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                        ],
                      ),
                      Visibility(
                        visible: contentImgPath.isNotEmpty,
                        child: Column(
                          children: [
                            contentImgPath.length == 1
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.005,
                                        vertical: size.height * 0.01),
                                    child: (nullRatio = getRatio()) != null
                                        ? buildImgWithRContainer(
                                            size,
                                            getImagepath(null)[0],
                                            nullRatio!,
                                          )
                                        : buildImgWithoutRContainer(
                                            size,
                                            getImagepath(null)[0],
                                          ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.005,
                                        vertical: size.height * 0.01),
                                    child: (nullRatio = getRatio()) == null
                                        ? SizedBox(
                                            height: size.height * 0.3,
                                            child: SliderNetImage(
                                              Items: getImagepath(1),
                                              size: size,
                                              onPageChangedCallback: (index) {
                                                setState(() {
                                                  newPageIndex = index %
                                                      contentImgPath.length;
                                                });
                                              },
                                            ),
                                          )
                                        : AspectRatio(
                                            aspectRatio:
                                                nullRatio!, // Adjust the aspect ratio based on your design
                                            child: SliderNetImage(
                                              Items: getImagepath(1),
                                              size: size,
                                              onPageChangedCallback: (index) {
                                                setState(() {
                                                  newPageIndex = index %
                                                      contentImgPath.length;
                                                });
                                              },
                                            ),
                                          ),
                                  ),
                            contentImgPath.length > 1
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0;
                                          i < contentImgPath.length;
                                          i++)
                                        Container(
                                          height: 4.0,
                                          width: 30.0,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.01),
                                          decoration: BoxDecoration(
                                            color: newPageIndex == i
                                                ? kPrimaryColor
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                        ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: Text(
                          postBody,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.005,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (post.postHashtags.isNotEmpty)
                                  ...post.postHashtags
                                      .where((hashtag) => hashtag.isNotEmpty)
                                      .map((hashtag) {
                                    return Row(
                                      children: [
                                        Text(
                                          "#$hashtag",
                                          style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  Colors.blue.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.015,
                                        ), // Add space between hashtags
                                      ],
                                    );
                                  })
                                else
                                  const Spacer(),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45.0),
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  IconButton(
                                    onPressed: () => like(() =>
                                        widget.post.likePost(widget.userId)),
                                    icon: widget.post.userLiked
                                            .contains(widget.userId)
                                        ? const Icon(Icons.favorite_outlined)
                                        : const Icon(
                                            Icons.favorite_border_outlined),
                                    constraints: const BoxConstraints(
                                        minWidth: 35, maxWidth: 35),
                                    iconSize: 15,
                                    color: widget.post.userLiked
                                            .contains(widget.userId)
                                        ? kPrimaryColor
                                        : Colors.grey,
                                  ),
                                  // Add spacing between icon and text
                                  Text(
                                    widget.post.userLiked.length.toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.005,
                                  ),
                                  IconButton(
                                    onPressed: () => dislike(
                                      () => widget.post
                                          .dislikedPost(widget.userId),
                                    ),
                                    color: widget.post.userDisliked
                                            .contains(widget.userId)
                                        ? kPrimaryColor
                                        : Colors.grey,
                                    icon: widget.post.userDisliked
                                            .contains(widget.userId)
                                        ? const Icon(Icons.thumb_down)
                                        : const Icon(
                                            Icons.thumb_down_alt_outlined),
                                    constraints: const BoxConstraints(
                                        minWidth: 35, maxWidth: 35),
                                    iconSize: 15,
                                  ),
                                  Text(
                                    widget.post.userDisliked.length.toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.005,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.reply_outlined,
                                      color: post.postAuthorId != widget.userId
                                          ? kPrimaryColor // Set the color as needed
                                          : Colors.grey,
                                      size: 15,
                                    ),
                                    constraints: const BoxConstraints(
                                        minWidth: 35, maxWidth: 35),
                                    onPressed: () async {
                                      if (post.postAuthorId == widget.userId) {
                                        Fluttertoast.showToast(
                                          msg: "You Can't reply to yourself",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 10,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        if (!post.userFollowers
                                            .contains(widget.userId)) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "You Have To follow User To reply",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 10,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          final result = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ReplyDialogForPost(
                                                username: postAuthorname,
                                                userId: widget.userId,
                                                status: status,
                                                body: postBody,
                                                post: post,
                                              );
                                            },
                                          );

                                          if (result != 'Null') {
                                            final last =
                                                await createReplyMethod(
                                                    post.postAuthorId,
                                                    post.postBodyId,
                                                    widget.userId,
                                                    result);

                                            post.addReply(last, widget.userId);
                                          }
                                        }
                                      }
                                    },
                                  ),
                                  Text(
                                    post.userReplyId.length.toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      color: kPrimaryColor,
                                      size: 15,
                                    ),
                                    constraints: const BoxConstraints(
                                        minWidth: 35, maxWidth: 35),
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                        msg: "You Can't share Now...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 10,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final resultComment = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CommentDialog(
                                            username: postAuthorname,
                                            userId: widget.userId,
                                            status: status,
                                            body: postBody,
                                            post: post,
                                          );
                                        },
                                      );

                                      if (resultComment != 'Null') {
                                        final recoil =
                                            await createCommentMethod(
                                                widget.userId, resultComment);

                                        post.addComment(recoil, widget.userId);
                                      }
                                    },
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: kPrimaryLightColor,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/Flaticon/speech-bubble.png",
                                            height: 15,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.01,
                                          ),
                                          Text(
                                            '+',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45.0),
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.bookmark_outline_outlined,
                                  color: kPrimaryColor,
                                  size: 15,
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 30, maxWidth: 30),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                    msg: "You Can't Bookmark Post Now...",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 10,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      post.userLiked.isNotEmpty
                          ? likedByWidget(post.userLiked
                              .map((userId) => userId.toString())
                              .toList())
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02),
                              child: Text(
                                "* No One Liked Till Now",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isCommentVisible = !isCommentVisible;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isCommentVisible
                                    ? const Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      )
                                    : const Icon(
                                        Icons.keyboard_arrow_up_outlined,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                Text(
                                  " ${post.userCommentId.length}  comments",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${post.postedTime}  •  ${post.postedDate}  ",
                            style: const TextStyle(
                              fontSize: 9,
                            ),
                          ),
                          Text(
                            "•  ${post.userViewed.length} Views",
                            style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isCommentVisible,
                  child: FutureBuilder<List<Comments>>(
                    // Assuming you have a function that returns Future<List<Comments>>
                    future: post.fetchComments(), // Implement this function
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the data is being fetched, show a loading indicator
                        return CommentShimmerLoader(size: size);
                      } else if (snapshot.hasError) {
                        // If there's an error, display an error message
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // If there are no comments, display a message
                        return const SizedBox.shrink();
                      } else {
                        // If comments are available, build the CommentCard using the first comment
                        // Modify this part according to your needs
                        return CommentCard(
                          postComment: snapshot.data![0],
                          userId: widget.userId,
                        );
                      }
                    },
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
