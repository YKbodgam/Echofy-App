import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<void> rejectUserRequest(String currentUserId, String otherUserId) async {
  // Update the current user's "Following" list
  await usersReference.child(currentUserId).child('Following').update({
    otherUserId: 'Rejected',
  });

  // Update the other user's "Followers" list
  await usersReference.child(otherUserId).child('Followers').update({
    currentUserId: 'Rejected',
  });
}
