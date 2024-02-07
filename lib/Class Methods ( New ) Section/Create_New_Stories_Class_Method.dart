import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Classes ( New ) Section/Create_New_Stories_Class.dart';
import '../Classes ( New ) Section/Create_New_Post_Body_Class.dart';

import '../User Section/Update User Details Section/Update_User_New_Stories.dart';
import '../Authentication Section/Database_Authentication/Upload To Database/Upload_Posts_To_Server.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
DatabaseReference newStoriesRef = _databaseReference.child('Stories').push();

DatabaseReference saveStories(Stories stories) {
  var id = _databaseReference.child('Stories').push();
  id.set(stories.toJson());
  return id;
}

Future<void> createStoriesMethod(String userId, String body, String mediaType,
    String mediaUrl, List<String> ratio) async {
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

  // Finaly This Metthod is used to create a database Post nd add these post to it

  final story = Stories(
    userId,
    postBodyRefId!,
    mediaType,
    mediaUrl,
    ratio,
    timepost,
    formatted,
    newStoriesRef,
  );

  // This method is used to add these post ID to its User
  final storyIdReference = saveStories(story);
  final storyRefId = storyIdReference.key;
  story.setId(storyIdReference);

  await updateUserInfoStories(userId, storyRefId!);
}
