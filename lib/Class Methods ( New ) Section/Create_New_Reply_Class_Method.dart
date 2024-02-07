import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Classes ( New ) Section/Create_New_Post_Body_Class.dart';
import '../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';

import '../User Section/Update User Details Section/Update_User_New_Reply.dart';
import '../Authentication Section/Database_Authentication/Upload To Database/Upload_Posts_To_Server.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
DatabaseReference newReplyPostRef = _databaseReference.child('replies').push();

DatabaseReference saveReplyPost(Reply replies) {
  var id = _databaseReference.child('replies').push();
  id.set(replies.toJson());
  return id;
}

Future<String> createReplyMethod(
    String writer, String book, String userId, String body) async {
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

  // This method is used to Fetch Post Images For the Post
  Reply reply = Reply(
    writer,
    book,
    userId,
    postBodyRefId!,
    timepost,
    formatted,
    newReplyPostRef,
  );

  final replyIdReference = saveReplyPost(reply);
  final replyRefId = replyIdReference.key; // Get the key as a String
  reply.setReplyId(replyIdReference);

  await updateUserInfoReply(userId, replyRefId!);
  return replyRefId;
}
