import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<bool> isCurrentUserFollowing(
    String currentUserId, String otherUserId) async {
  // Get the current user
  final followingSnapshot = (await usersReference
          .child(currentUserId)
          .child('Following')
          .child(otherUserId)
          .once())
      .snapshot;

  dynamic followingData = followingSnapshot.value;

  if (followingData != null) {
    // The current user is already following the user with otherUserId
    return true;
  } else {
    // The current user is not following the user with otherUserId
    return false;
  }
}
