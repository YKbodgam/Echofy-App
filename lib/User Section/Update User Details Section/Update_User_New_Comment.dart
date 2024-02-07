import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> updateUserInfoComment(String userId, String commentId) async {
  try {
    // Get the current user data
    DatabaseReference userRef = usersReference.child(userId);

    DataSnapshot dataSnapshot = (await userRef.once()).snapshot;
    dynamic dataValue = dataSnapshot.value;

    if (dataValue != null) {
      // Get the current list of posts
      List<dynamic> comments = List.from(dataValue['_Comments'] ?? []);

      // Add the new post to the list
      comments.add(commentId);

      // Update the user data with the new list of posts
      await userRef.update({'_Comments': comments});
    }
  } catch (e) {
    print("Error updating User Info to Firebase database: $e");
  }
}
