import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> allowUserRequest(String currentUserId, String otherUserId) async {
  // Update the current user's "Following" list
  await usersReference.child(currentUserId).child('Followers').update({
    otherUserId: 'Accepted',
  });

  // Update the other user's "Followers" list
  await usersReference.child(otherUserId).child('Following').update({
    currentUserId: 'Accepted',
  });
}
