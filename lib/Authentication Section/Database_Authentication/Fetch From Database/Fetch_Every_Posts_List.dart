import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

//
Future<List<dynamic>> getAllPostsAndReplies(String UserId) async {
  // Create a list to hold all items (posts and replies)
  List<dynamic> allItems = [];

  DataSnapshot postSnapshot =
      (await _databaseReference.child('posts').once()).snapshot;
  dynamic postMapDynamic = postSnapshot.value;

  if (postMapDynamic != null && postMapDynamic is Map) {
    postMapDynamic.forEach(
      (postKey, postValue) {
        if (postKey is String) {
          DatabaseReference postRef =
              _databaseReference.child('posts/$postKey');

          if (postValue is Map<Object?, Object?>) {
            Map<String, dynamic> convertedValue =
                postValue.cast<String, dynamic>();

            try {
              Post post = createPost(convertedValue, postRef);
              allItems.add(post);
            } catch (e) {
              print('Error parsing post: $e');
            }
          }
        }
      },
    );
  }

  DataSnapshot replySnapshot =
      (await _databaseReference.child('replies').once()).snapshot;
  dynamic replyMapDynamic = replySnapshot.value;

  if (replyMapDynamic != null &&
      replyMapDynamic is Map &&
      replyMapDynamic.isNotEmpty) {
    replyMapDynamic.forEach(
      (replyKey, replyValue) {
        DatabaseReference replyRef =
            _databaseReference.child('replies/$replyKey');

        if (replyValue is Map<Object?, Object?>) {
          Map<String, dynamic> convertedValue_2 =
              replyValue.cast<String, dynamic>();

          try {
            Reply reply = createReplyPost(convertedValue_2, replyRef);
            allItems.add(reply);
          } catch (e) {
            print('Error parsing timestamp: $e');
          }
        }
      },
    );
  }

  allItems.sort((a, b) {
    if (a is Post && b is Post) {
      DateTime aDateTime = parseDateTime(a.postedDate, a.postedTime);
      DateTime bDateTime = parseDateTime(b.postedDate, b.postedTime);
      return bDateTime.compareTo(aDateTime);
    } else {
      return 0;
    }
  });

  List<dynamic> result = [];

  for (var item in allItems) {
    if (item is Post) {
      result.add(item);

      // Check if the post contains UserReplied
      if (item.userReplyId.isNotEmpty) {
        // Filter replies from the existing list based on AuthorId and Body
        List<Reply> replies = allItems
            .whereType<Reply>()
            .where((reply) =>
                reply.originalAuthorId == item.postAuthorId &&
                reply.originalBodyId == item.postBodyId)
            .toList();

        // Sort replies by date and time in descending order
        replies.sort((a, b) {
          DateTime aDateTime = parseDateTime(a.repliedDate, a.repliedTime);
          DateTime bDateTime = parseDateTime(b.repliedDate, b.repliedTime);
          return bDateTime.compareTo(aDateTime);
        });

        // Take at most 2 newest replies
        List<Reply> newestReplies = replies.take(2).toList();
        result.addAll(newestReplies);

        // Take older replies if any
        List<Reply> olderReplies = replies.skip(2).toList();
        result.addAll(olderReplies);
      }
    }
  }

  return result;
}

DateTime parseDateTime(String dateString, String timeString) {
  DateTime date = DateFormat('EEE, MMM dd, yyyy').parse(dateString);
  TimeOfDay time = parseTime(timeString);

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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


// Future<List<Post>> getAllPosts(String Username) async {
//   List<Post> posts = [];

//   DataSnapshot dataSnapshot =
//       (await _databaseReference.child('posts').once()).snapshot;

//   dynamic postMapDynamic = dataSnapshot.value;

//   if (postMapDynamic != null && postMapDynamic is Map) {
//     postMapDynamic.forEach((key, value) {
//       if (key is String) {
//         DatabaseReference postRef = _databaseReference.child('posts/$key');
//         if (value is Map<Object?, Object?>) {
//           Map<String, dynamic> convertedValue = value.cast<String, dynamic>();

//           if (convertedValue.containsKey('Author') &&
//               convertedValue.containsKey('Body') &&
//               convertedValue.containsKey('Time') &&
//               convertedValue.containsKey('Date')) {
//             try {
//               Post post = createPost(convertedValue, postRef);
//               post.onViewed(Username); // Set the timestamp
//               posts.add(post);
//             } catch (e) {
//               // Handle the error (e.g., log it) and skip this post
//               print('Error parsing timestamp: $e');
//             }
//           }
//         }
//       }
//     });
//   } else {
//     Fluttertoast.showToast(
//       msg: "There are no posts yet! Try to be the first.",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 20,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   return posts;
// }

// Future<List<Reply>> getAllReplyPosts(String Username) async {
//   List<Reply> replies = [];

//   DataSnapshot dataSnapshot =
//       (await _databaseReference.child('replies').once()).snapshot;

//   dynamic postMapDynamic = dataSnapshot.value;

//   if (postMapDynamic != null && postMapDynamic is Map) {
//     postMapDynamic.forEach((key, value) {
//       if (key is String) {
//         DatabaseReference ReplyRef = _databaseReference.child('replies/$key');
//         if (value is Map<Object?, Object?>) {
//           Map<String, dynamic> convertedValue = value.cast<String, dynamic>();

//           if (convertedValue.containsKey('Author') &&
//               convertedValue.containsKey('Body') &&
//               convertedValue.containsKey('Time') &&
//               convertedValue.containsKey('Date')) {
//             try {
//               Reply reply = createReplyPost(convertedValue, ReplyRef);
//               reply.onViewed(Username); // Set the timestamp
//               replies.add(reply);
//             } catch (e) {
//               // Handle the error (e.g., log it) and skip this post
//               print('Error parsing timestamp: $e');
//             }
//           }
//         }
//       }
//     });
//   } else {
//     Fluttertoast.showToast(
//       msg: "Now You can Reply to posts but only if you follow them",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 20,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   return replies;
// }

// Future<void> updateAuthor(String userId, String newUsername) async {
//   // Update the username under the user's node
//   _databaseReference.child('users/$userId/username').set(newUsername);

//   // Query and update posts authored by the user
//   DataSnapshot postsSnapshot = (await _databaseReference
//           .child('posts')
//           .orderByChild('authorId')
//           .equalTo(userId)
//           .once())
//       .snapshot;

//   dynamic postMapDynamic = postsSnapshot.value;

//   if (postMapDynamic != null && postMapDynamic is Map) {
//     postMapDynamic.forEach((key, value) {
//       if (key is String) {
//         // Update the author ID in the post
//         _databaseReference.child('posts/$key/authorId').set(newUsername);
//       }
//     });
//   }
// }

// Future<void> updateLikes(String oldUsername, String newUsername) async {
//   DataSnapshot postsSnapshot = (await _databaseReference
//           .child('posts')
//           .orderByChild('UserLiked')
//           .equalTo(oldUsername)
//           .once())
//       .snapshot;

//   dynamic postMapDynamic = postsSnapshot.value;

//   if (postMapDynamic != null && postMapDynamic is Map) {
//     postMapDynamic.forEach(
//       (key, value) async {
//         if (key is String) {
//           // Update the "UserLiked" list for each post
//           DataSnapshot likesSnapshot =
//               (await _databaseReference.child('posts/$key/UserLiked').once())
//                   .snapshot;

//           dynamic postDynamic = likesSnapshot.value;

//           if (postDynamic != null) {
//             List<String> userLiked = List<String>.from(postDynamic);

//             // Replace the old username with the new username in the "UserLiked" list
//             userLiked.remove(oldUsername);
//             userLiked.add(newUsername);

//             // Update the "UserLiked" list in the database
//             _databaseReference.child('posts/$key/UserLiked').set(userLiked);
//           }
//         } else {
//           print('No posts found with the old username in Realtime Database');
//         }
//       },
//     );
//   }
//   print('Error updating UserLiked lists in Realtime Database');
// }


