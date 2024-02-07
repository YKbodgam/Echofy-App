import 'package:firebase_database/firebase_database.dart';

class PostBody {
  String postAuthorId;
  String postMainBody;
  DatabaseReference bodyId;

  PostBody(
    this.postAuthorId,
    this.postMainBody,
    this.bodyId,
  );

  void setBodyId(DatabaseReference id) {
    bodyId = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'Post-Body-Author-ID': postAuthorId,
      'Post-Main-Body': postMainBody,
    };
  }
}

PostBody createPostBody(Map<String, dynamic> record, DatabaseReference id) {
  for (var key in record.keys) {
    final firebaseValue = record[key.toLowerCase()];
    if (firebaseValue != null && firebaseValue.isNotEmpty) {
      record[key] = firebaseValue.toString();
    }
  }

  PostBody postBody = PostBody(
    record['Post-Body-Author-ID'],
    record['Post-Main-Body'],
    id,
  );

  return postBody;
}
