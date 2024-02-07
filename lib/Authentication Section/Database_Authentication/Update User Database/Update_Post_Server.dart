import 'package:firebase_database/firebase_database.dart';

import '../../../Classes ( New ) Section/Create_New_Post_Comment_Class.dart';
import '../../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../../Classes ( New ) Section/Create_New_Post_Reply_Class.dart';
import '../../../Classes ( New ) Section/Create_New_Stories_Class.dart';

void UpdatePost(Post post, DatabaseReference id) {
  id.update(post.toJson());
}

void UpdateReplyPost(Reply replies, DatabaseReference id) {
  id.update(replies.toJson());
}

void UpdateComment(Comments comments, DatabaseReference id) {
  id.update(comments.toJson());
}

void UpdateStories(Stories stories, DatabaseReference id) {
  id.update(stories.toJson());
}
