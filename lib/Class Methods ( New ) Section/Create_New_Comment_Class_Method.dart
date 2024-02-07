import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Classes ( New ) Section/Create_New_Post_Body_Class.dart';
import '../Classes ( New ) Section/Create_New_Post_Comment_Class.dart';
import '../Authentication Section/Database_Authentication/Upload To Database/Upload_Posts_To_Server.dart';
import '../User Section/Update User Details Section/Update_User_New_Comment.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
DatabaseReference newCommentRef = _databaseReference.child('Comments').push();

DatabaseReference saveCommentPost(Comments coments) {
  var id = _databaseReference.child('Comments').push();
  id.set(coments.toJson());
  return id;
}

Future<String> createCommentMethod(String userId, String body) async {
  // This method is Used To Fetch Time Component
  final timestamp = DateTime.now();
  final formatted = DateFormat.yMMMEd().format(timestamp);
  final timepost =
      "${timestamp.hour}:${timestamp.minute} ${timestamp.hour >= 12 ? 'PM' : 'AM'}";

  // This method is used to Fetch The Body For the Post

  final postBody = PostBody(userId, body, newPostBodyRef);
  final postBodyReference = savePostBody(postBody);
  final postBodyRefId = postBodyReference.key;
  postBody.setBodyId(postBodyReference);

  final coment = Comments(
    userId,
    postBodyRefId!,
    timepost,
    formatted,
    newCommentRef,
  );

  final commentIdReference = saveCommentPost(coment);
  final commentId = commentIdReference.key;
  coment.setId(commentIdReference);

  await updateUserInfoComment(userId, commentId!);
  return commentId;
}
