// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<String> getUsernameByUserId(String userId) async {
  DataSnapshot userSnapshot =
      (await usersReference.child(userId).child('Username').once()).snapshot;

  dynamic User = userSnapshot.value;

  if (User != null) {
    return User.toString();
  } else {
    return 'null'; // User not found with the given userId
  }
}
