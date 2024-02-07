import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

Future<void> updateAuthor(
    String userId, String newUsername, String newpath) async {
  _databaseReference.child('Users/$userId/Username').set(newUsername);
  _databaseReference.child('Users/$userId/ProfileImg').set(newpath);
  //
}

// Future<void> updateAuthor_1(
//     String username, String newUsername, String newStatus) async {
//   DataSnapshot dataSnapshot = (await _databaseReference
//           .child('posts')
//           .orderByChild('AuthorId')
//           .equalTo(username)
//           .once())
//       .snapshot;

//   dynamic postMapDynamic = dataSnapshot.value;

//   if (postMapDynamic != null && postMapDynamic is Map) {
//     postMapDynamic.forEach(
//       (key, value) {
//         if (key is String) {
//           // Update the "author" field to the new email
//           _databaseReference.child('posts/$key/AuthorId').set(newUsername);
//           _databaseReference.child('posts/$key/Status').set(newStatus);

//           //
//         }
//       },
//     );
//   }

//   DataSnapshot replydataSnapshot = (await _databaseReference
//           .child('replies')
//           .orderByChild('Author_Replied_Id')
//           .equalTo(username)
//           .once())
//       .snapshot;

//   dynamic repliesMapDynamic = replydataSnapshot.value;

//   if (repliesMapDynamic != null && repliesMapDynamic is Map) {
//     repliesMapDynamic.forEach(
//       (key, value) {
//         if (key is String) {
//           // Update the "author" field to the new email
//           _databaseReference
//               .child('replies/$key/Author_Replied_Id')
//               .set(newUsername);
//         }
//       },
//     );
//   }
// }
