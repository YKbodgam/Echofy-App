import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> updateUserInfoStories(String userId, String storyId) async {
  try {
    DatabaseReference userRef = usersReference.child(userId);

    DataSnapshot dataSnapshot = (await userRef.once()).snapshot;
    dynamic dataValue = dataSnapshot.value;

    if (dataValue != null) {
      // Get the current list of posts
      List<dynamic> stories = List.from(dataValue['_Stories'] ?? []);

      // Add the new post to the list
      stories.add(storyId);

      // Update the user data with the new list of posts
      await userRef.update({'_Stories': stories});
    }
  } catch (e) {
    print("Error updating User Info to Firebase database: $e");
  }
}
