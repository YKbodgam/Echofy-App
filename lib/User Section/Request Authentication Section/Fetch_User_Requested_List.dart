import 'package:firebase_database/firebase_database.dart';

final DatabaseReference usersReference =
    FirebaseDatabase.instance.ref().child('Users');

Future<List<String>> getRequestedList(String userId) async {
  DatabaseReference followersReference =
      usersReference.child(userId).child('Followers');
  DataSnapshot snapshot = (await followersReference.once()).snapshot;
  dynamic data = snapshot.value;

  List<String> followersList = [];

  if (data != null && data is Map) {
    data.forEach((key, value) {
      if (key is String) {
        if (value == 'Chance') {
          followersList.add(key);
        }
      }
    });
  }
  return followersList;
}
