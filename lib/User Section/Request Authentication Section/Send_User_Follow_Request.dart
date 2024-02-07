import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> sendUserRequest(String currentUserId, String otherUserId) async {
  // Update the current user's "Following" list
  await usersReference.child(currentUserId).child('Following').update({
    otherUserId: 'Requested',
  });

  // Update the other user's "Followers" list
  await usersReference.child(otherUserId).child('Followers').update({
    currentUserId: 'Chance',
  });
}
