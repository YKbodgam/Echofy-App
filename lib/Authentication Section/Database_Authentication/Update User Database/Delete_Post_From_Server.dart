import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
Future<void> deleteAuthorPost(String authorName, String bodyText) async {
  DataSnapshot dataSnapshot = (await _databaseReference
          .child('posts')
          .orderByChild('AuthorId')
          .equalTo(authorName)
          .once())
      .snapshot;

  dynamic postMapDynamic = dataSnapshot.value;

  if (postMapDynamic != null && postMapDynamic is Map) {
    postMapDynamic.forEach(
      (key, value) {
        if (key is String) {
          // Check if the body text matches the text to be deleted
          if (value['Body'] == bodyText) {
            // Delete the post with matching author and body text
            _databaseReference.child('posts/$key').remove();
          }
        }
      },
    );
  }
}

Future<void> deleteAuthorReply(String authorName, String bodyText) async {
  DataSnapshot dataSnapshot = (await _databaseReference
          .child('replies')
          .orderByChild('Author_Replied_Id')
          .equalTo(authorName)
          .once())
      .snapshot;

  dynamic postMapDynamic = dataSnapshot.value;

  if (postMapDynamic != null && postMapDynamic is Map) {
    postMapDynamic.forEach(
      (key, value) {
        if (key is String) {
          // Check if the body text matches the text to be deleted
          if (value['Body_Replied'] == bodyText) {
            // Delete the post with matching author and body text
            _databaseReference.child('replies/$key').remove();
            checkForReplies(key);
          }
        }
      },
    );
  }
}

Future<void> checkForReplies(String Newkey) async {
  DataSnapshot postsSnapshot = (await _databaseReference
          .child('posts')
          .orderByChild(
              'UserReplied') // Filter posts where UserReplied contains Newkey
          .once())
      .snapshot;

  if (postsSnapshot.value != null) {
    dynamic postsMap = postsSnapshot.value;

    postsMap.forEach(
      (postKey, postData) {
        // Ensure the post has UserReplied set
        if (postData.containsKey('UserReplied') &&
            postData['UserReplied'] is List) {
          List<dynamic> userRepliedList = postData['UserReplied'];

          // Iterate through the list and remove entries matching Newkey
          for (int i = 0; i < userRepliedList.length; i++) {
            if (userRepliedList[i] == Newkey) {
              // Remove the specific entry from UserReplied list
              _databaseReference
                  .child('posts/$postKey/UserReplied/$i')
                  .remove();
            }
          }
        }
      },
    );
  }
}
