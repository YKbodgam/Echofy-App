import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<String> getUserIdByUsername(String username) async {
  DataSnapshot userSnapshot =
      (await usersReference.orderByChild('Username').equalTo(username).once())
          .snapshot;

  dynamic User = userSnapshot.value;
  late String Userid = '';

  if (User != null && User is Map) {
    User.forEach(
      (key, value) {
        if (key is String) {
          Userid = key; // The first key is the user ID
        }
      },
    );
    return Userid;
  } else {
    return 'null'; // Username not found
  }
}
