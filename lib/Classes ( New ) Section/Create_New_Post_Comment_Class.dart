import 'package:firebase_database/firebase_database.dart';

import '../Authentication Section/Database_Authentication/Update User Database/Update_Post_Server.dart';

class Comments {
  String commentAuthorId;
  String commentBodyId;
  String commentedTime;
  String commentedDate;

  Set userLiked = {};
  DatabaseReference comment_Id;

  Comments(
    this.commentAuthorId,
    this.commentBodyId,
    this.commentedTime,
    this.commentedDate,
    this.comment_Id,
  );

  Future<void> Liked(String userId) async {
    if (userLiked.contains(userId)) {
      userLiked.remove(userId);
    } else {
      userLiked.add(userId);
    }
    update();
  }

  void update() {
    UpdateComment(this, comment_Id);
  }

  void setId(DatabaseReference id) {
    comment_Id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'Comment-Author-ID': commentAuthorId,
      'Comment-Body-ID': commentBodyId,
      'Comment-Time': commentedTime,
      'Comment-Date': commentedDate,
      'UserLiked': userLiked.toList(),
    };
  }
}

Comments createComment(Map<String, dynamic> record, DatabaseReference id) {
  for (var key in record.keys) {
    final firebaseValue = record[key.toLowerCase()];
    if (firebaseValue != null && firebaseValue.isNotEmpty) {
      record[key] = firebaseValue.toString();
    }
  }

  Comments comments = Comments(
    record['Comment-Author-ID'],
    record['Comment-Body-ID'],
    record['Comment-Time'],
    record['Comment-Date'],
    id,
  );

  // Initialize UserLiked and UserDisliked sets from the attributes
  comments.userLiked = Set<String>.from(record['UserLiked'] ?? []);

  return comments;
}
