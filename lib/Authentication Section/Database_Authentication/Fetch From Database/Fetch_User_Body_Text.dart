import 'package:firebase_database/firebase_database.dart';

Future<String> getPostBody(String bodyId) async {
  try {
    DataSnapshot snapshot = (await FirebaseDatabase.instance
            .ref()
            .child('Post-Body')
            .child(bodyId)
            .child('Post-Main-Body')
            .once())
        .snapshot;

    dynamic bodysnapshot = snapshot.value;

    if (bodysnapshot != null) {
      return bodysnapshot.toString(); // Return the main body text
    } else {
      return ''; // Return null if no data is found
    }
  } catch (e) {
    print("Error retrieving post main body: $e");
    return '';
  }
}
