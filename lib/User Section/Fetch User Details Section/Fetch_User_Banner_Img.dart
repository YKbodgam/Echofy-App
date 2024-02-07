import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<String> getProfileBannerImg(String userId) async {
  DataSnapshot userSnapshot =
      (await usersReference.child(userId).child('ProfileBannerImg').once())
          .snapshot;

  dynamic User = userSnapshot.value;

  if (User != null) {
    return User.toString();
  } else {
    return 'null'; // User not found with the given userId
  }
}
