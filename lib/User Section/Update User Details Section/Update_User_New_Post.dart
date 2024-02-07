import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> updateUserInfoPost(String userId, String postId) async {
  try {
    DatabaseReference userRef = usersReference.child(userId);

    DataSnapshot dataSnapshot = (await userRef.once()).snapshot;
    dynamic userData = dataSnapshot.value;

    List<dynamic> posts =
        userData != null ? List.from(userData['_Posts'] ?? []) : [];
    posts.add(postId);

    await userRef.update({'_Posts': posts});
  } catch (e) {
    print("Error updating User Info to Firebase database: $e");
  }
}
