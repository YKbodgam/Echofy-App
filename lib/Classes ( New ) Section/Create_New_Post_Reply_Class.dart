import 'package:firebase_database/firebase_database.dart';

import '../Notification Section/Send_User_Notification.dart';
import '../User Section/Fetch User Details Section/Fetch_User_Following_info.dart';
import '../User Section/Request Authentication Section/Send_User_Follow_Request.dart';
import '../Authentication Section/Database_Authentication/Update User Database/Update_Post_Server.dart';

class Reply {
  String originalAuthorId;
  String originalBodyId;
  String replyAuthorId;
  String replyBodyId;
  String repliedTime;
  String repliedDate;

  Set userLiked = {};
  Set userDisliked = {};
  Set userCommentId = {};
  Set userReacted = {};

  Set userViewed = {};
  Set userRequested = {};
  Set userFollowers = {};
  Set userFollowings = {};
  DatabaseReference id;

  Reply(
    this.originalAuthorId,
    this.originalBodyId,
    this.replyAuthorId,
    this.replyBodyId,
    this.repliedTime,
    this.repliedDate,
    this.id,

// Initialize this property
  ) {
    initializeFollowingInfo();
  }

  final DatabaseReference usersReference =
      FirebaseDatabase.instance.ref().child('Users');

  Future<void> initializeFollowingInfo() async {
    await getFollowing();
    await getFollower();
    await getRequest();
  }

  Future<void> Request(String currentUserId) async {
    final following =
        await isCurrentUserFollowing(currentUserId, replyAuthorId);

    if (!following) {
      await sendUserRequest(currentUserId, replyAuthorId);
      userRequested.add(currentUserId);

      NotifyUser(
        currentUserId,
        replyAuthorId,
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
          usersReference.child(replyAuthorId).child('Following');
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
          usersReference.child(replyAuthorId).child('Followers');
      DataSnapshot snapshot = (await followersReference.once()).snapshot;
      dynamic data = snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (key is String) {
            if (value == 'Accepted') {
              userFollowers.add(key);
            }
          }
        });
      }
    } catch (error) {
      print('Error fetching follower data: $error');
    }
  }

  Future<void> getRequest() async {
    try {
      DatabaseReference RequestReference =
          usersReference.child(replyAuthorId).child('Requested');
      DataSnapshot snapshot = (await RequestReference.once()).snapshot;
      dynamic data = snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (key is String) {
            userRequested.add(key);
          }
        });
      }
    } catch (error) {
      print('Error fetching follower data: $error');
    }
  }

  void onViewed(String userId) {
    if (!userViewed.contains(userId)) {
      userViewed.add(userId);
      update();
    }
  }

  void disliked(String userId) {
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

  Future<void> likeRely(String userId) async {
    if (userLiked.contains(userId)) {
      userLiked.remove(userId);
    } else {
      userLiked.add(userId);

      NotifyUser(
        userId,
        replyAuthorId,
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
    UpdateReplyPost(this, id);
  }

  void setReplyId(DatabaseReference id) {
    id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      "Reply-Original-Author-ID": originalAuthorId,
      "Reply-Original-Body-ID": originalBodyId,
      "Reply-Unique-Author-ID": replyAuthorId,
      "Reply-Unique-Body-ID": replyBodyId,
      "Replied-Time": repliedTime,
      "Replied-Date": repliedDate,
      'Reply-Userliked-IDs': userLiked.toList(),
      'Reply-Userdisliked-IDs': userDisliked.toList(),
      'Reply-Comments-IDs': userCommentId.toList(),
      'Reply-Viewed-IDs': userViewed.toList(),
    };
  }
}

Reply createReplyPost(Map<String, dynamic> record, DatabaseReference id) {
  for (var key in record.keys) {
    final firebaseValue = record[key.toLowerCase()];
    if (firebaseValue != null && firebaseValue.isNotEmpty) {
      record[key] = firebaseValue.toString();
    }
  }

  Reply reply = Reply(
    record['Reply-Original-Author-ID'],
    record['Reply-Original-Body-ID'],
    record['Reply-Unique-Author-ID'],
    record['Reply-Unique-Body-ID'],
    record['Replied-Time'],
    record['Replied-Date'],
    id,
  );

  // Initialize UserLiked and UserDisliked sets from the attributes
  reply.userLiked = Set<String>.from(record['Reply-Userliked-IDs'] ?? []);
  reply.userDisliked = Set<String>.from(record['Reply-Userdisliked-IDs'] ?? []);

  reply.userCommentId = Set<String>.from(record['Reply-Comments-IDs'] ?? []);
  reply.userViewed = Set<String>.from(record['Reply-Viewed-IDs'] ?? []);

  return reply;
}
