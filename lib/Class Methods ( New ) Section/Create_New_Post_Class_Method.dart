import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Classes ( New ) Section/Create_New_Post_Banner_Img_Class.dart';
import '../Classes ( New ) Section/Create_New_Post_Body_Class.dart';
import '../Classes ( New ) Section/Create_New_Post_Main_Class.dart';

import '../User Section/Update User Details Section/Update_User_New_Post.dart';
import '../Authentication Section/Database_Authentication/Upload To Database/Upload_Posts_To_Server.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
DatabaseReference newPostRef = _databaseReference.child('posts').push();

DatabaseReference savePost(Post post) {
  var id = _databaseReference.child('posts').push();
  id.set(post.toJson());
  return id;
}

Future<void> createPostMethod(String userId, String body,
    Map<String, double?> finalImgContent, Set<String> hastags) async {
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

  String postBannerImgRefId = ''; // Declare outside the if statement

// This method is used to Fetch Post Images For the Post
  if (finalImgContent != {} && finalImgContent.isNotEmpty) {
    final postBannerImg =
        PostBannerImg(userId, finalImgContent, newPostBannerImg);

    final postBannerImgReference = savePostBannerImg(postBannerImg);
    postBannerImgRefId = postBannerImgReference.key!; // Assign the value
    postBannerImg.setBannerImgId(postBannerImgReference);
  }

// Finally, This Method is used to create a database Post and add these post to it

  final post = Post(
    userId,
    postBodyRefId!,
    postBannerImgRefId, // Now you can use it outside the if statement
    timepost,
    formatted,
    hastags,
    newPostRef,
  );

  // This method is used to add these post ID to its User
  final postIdReference = savePost(post);
  final postRefId = postIdReference.key;
  post.setPostId(postIdReference);

  await updateUserInfoPost(userId, postRefId!);
}
