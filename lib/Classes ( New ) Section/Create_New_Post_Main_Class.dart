import 'package:firebase_database/firebase_database.dart';
import 'Create_New_Post_Comment_Class.dart';

import '../Notification Section/Send_User_Notification.dart';
import '../User Section/Request Authentication Section/Send_User_Follow_Request.dart';
import '../User Section/Fetch User Details Section/Fetch_User_Following_info.dart';
import '../Authentication Section/Database_Authentication/Update User Database/Update_Post_Server.dart';

class Post {
  String postAuthorId;
  String postBodyId;
  String postBannerImgId;

  String postedTime;
  String postedDate;
  Set<String> postHashtags = {};

  Set userLiked = {};
  Set userDisliked = {};
  Set userReplyId = {};
  Set userCommentId = {};
  Set userReacted = {};

  Set userViewed = {};
  Set userRequested = {};
  Set userFollowers = {};
  Set userFollowings = {};
  DatabaseReference _id;

  Post(
    this.postAuthorId,
    this.postBodyId,
    this.postBannerImgId,
    this.postedTime,
    this.postedDate,
    this.postHashtags,
    this._id,
  ) {
    initializeFollowingInfo();
  }

  final DatabaseReference usersReference =
      FirebaseDatabase.instance.ref().child('Users');

  Future<void> initializeFollowingInfo() async {
    await getFollowing();
    await getFollower();
  }

  Future<void> Request(String currentUserId) async {
    final following = await isCurrentUserFollowing(currentUserId, postAuthorId);

    if (!following) {
      await sendUserRequest(currentUserId, postAuthorId);
      userRequested.add(currentUserId);

      NotifyUser(
        currentUserId,
        postAuthorId,
        'Special',
        'Request',
        '',
      );

      await initializeFollowingInfo(); // Refresh follower data
    }
    update();
  }

  Future<void> getFollowing() async {
    try {
      DatabaseReference followingReference =
          usersReference.child(postAuthorId).child('Following');

      DataSnapshot snapshot = (await followingReference.once()).snapshot;
      dynamic data = snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (key is String) {
            if (value == 'Accepted') {
              userFollowings.add(key);
            }
          }
        });
      }
    } catch (error) {
      print('Error fetching following data: $error');
    }
  }

  Future<void> getFollower() async {
    try {
      DatabaseReference followersReference =
          usersReference.child(postAuthorId).child('Followers');

      DataSnapshot snapshot = (await followersReference.once()).snapshot;
      dynamic data = snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (key is String) {
            if (value == 'Accepted') {
              userFollowers.add(key);
            }
            if (value == 'Chance') {
              userRequested.add(key);
            }
          }
        });
      }
    } catch (error) {
      print('Error fetching follower data: $error');
    }
  }

  Future<List<Comments>> fetchComments() async {
    final DatabaseReference reference = FirebaseDatabase.instance.ref();
    List<Comments> commentsList = [];

    for (var commentId in userCommentId) {
      DataSnapshot commentSnapshot =
          (await reference.child('Comments').child(commentId).once()).snapshot;

      dynamic coment = commentSnapshot.value;

      if (coment != null) {
        Map<String, dynamic> commentData = coment.cast<String, dynamic>();

        Comments comment = createComment(commentData, reference);
        commentsList.add(comment);
      }
    }

    return commentsList;
  }

  Future<void> addReply(String replyId, String currentUserId) async {
    if (!userReplyId.contains(replyId)) {
      userReplyId.add(replyId);

      NotifyUser(
        currentUserId,
        postAuthorId,
        'Special',
        'Reply',
        '',
      );
    }
    update();
  }

  Future<void> addComment(String commentId, String currentUserId) async {
    if (!userCommentId.contains(commentId)) {
      userCommentId.add(commentId);

      NotifyUser(
        currentUserId,
        postAuthorId,
        'Special',
        'Comment',
        '',
      );
    }
    update();
  }

  void onViewed(String userId) {
    if (!userViewed.contains(userId)) {
      userViewed.add(userId);
    }
    update();
  }

  void dislikedPost(String userId) {
    if (userDisliked.contains(userId)) {
      userDisliked.remove(userId);
    } else {
      userDisliked.add(userId);

      // Remove like if user is disliking the post
      if (userLiked.contains(userId)) {
        userLiked.remove(userId);
      }
    }
    update();
  }

  Future<void> likePost(String userId) async {
    if (userLiked.contains(userId)) {
      userLiked.remove(userId);
    } else {
      userLiked.add(userId);

      NotifyUser(
        userId,
        postAuthorId,
        'Special',
        'Like',
        '',
      );

      // Remove dislike if user is liking the post
      if (userDisliked.contains(userId)) {
        userDisliked.remove(userId);
      }
    }
    update();
  }

  void update() {
    UpdatePost(this, _id);
  }

  void setPostId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'Post-Unique-Author-ID': postAuthorId,
      'Post-Unique-Body-ID': postBodyId,
      'Post-Unique-Banner-IMG-ID': postBannerImgId,
      'Posted-Time': postedTime,
      'Posted-Date': postedDate,
      'Post-Hastags': postHashtags.toList(),
      'Post-UserLiked-IDs': userLiked.toList(),
      'Post-UserDisliked-IDs': userDisliked.toList(),
      'Post-Replies-IDs': userReplyId.toList(),
      'Post-Comments-IDs': userCommentId.toList(),
      'Post-Viewed-IDs': userViewed.toList(),
    };
  }
}

Post createPost(Map<String, dynamic> record, DatabaseReference id) {
  for (var key in record.keys) {
    final firebaseValue = record[key.toLowerCase()];
    if (firebaseValue != null && firebaseValue.isNotEmpty) {
      record[key] = firebaseValue.toString();
    }
  }

  Post post = Post(
    record['Post-Unique-Author-ID'],
    record['Post-Unique-Body-ID'],
    record['Post-Unique-Banner-IMG-ID'],
    record['Posted-Time'],
    record['Posted-Date'],
    Set<String>.from(record['Post-Hastags']),
    id,
  );

  // Initialize UserLiked and UserDisliked sets from the attributes
  post.userLiked = Set<String>.from(record['Post-UserLiked-IDs'] ?? []);
  post.userDisliked = Set<String>.from(record['Post-UserDisliked-IDs'] ?? []);
  post.userReplyId = Set<String>.from(record['Post-Replies-IDs'] ?? []);
  post.userCommentId = Set<String>.from(record['Post-Comments-IDs'] ?? []);
  post.userViewed = Set<String>.from(record['Post-Viewed-IDs'] ?? []);

  return post;
}
