import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> updateUserInfoReply(String userId, String replyId) async {
  try {
    //  Get the current user data
    DatabaseReference userRef = usersReference.child(userId);

    DataSnapshot dataSnapshot = (await userRef.once()).snapshot;
    dynamic dataValue = dataSnapshot.value;

    if (dataValue != null) {
      // Get the current list of posts
      List<dynamic> replies = List.from(dataValue['_Replies'] ?? []);

      // Add the new post to the list
      replies.add(replyId);

      // Update the user data with the new list of posts
      await userRef.update({'_Replies': replies});
    }
  } catch (e) {
    print("Error updating User Info to Firebase database: $e");
  }
}
