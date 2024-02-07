import 'package:firebase_database/firebase_database.dart';

import '../Authentication Section/Database_Authentication/Update User Database/Update_Post_Server.dart';

class Stories {
  String storyAuthorId;
  String storyDescriptionId;
  String storyMediaType;
  String storyMediaUrl;

  List<String> storyContentRatio;
  String storyTime;
  String storyDate;

  Set userLiked = {};
  Set userViewed = {};
  DatabaseReference _id;

  Stories(
    this.storyAuthorId,
    this.storyDescriptionId,
    this.storyMediaType,
    this.storyMediaUrl,
    this.storyContentRatio,
    this.storyTime,
    this.storyDate,
    this._id,
  );

  void onViewed(String userId) {
    if (!userViewed.contains(userId)) {
      userViewed.add(userId);
    }
    update();
  }

  Future<void> likedStory(String userId) async {
    if (userLiked.contains(userId)) {
      userLiked.remove(userId);
    } else {
      userLiked.add(userId);
    }
    update();
  }

  void update() {
    UpdateStories(this, _id);
  }

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'Story-Unique-Author-ID': storyAuthorId,
      'Story-Unique-Body-ID': storyDescriptionId,
      'Story-Media-Type': storyMediaType,
      'Story-Media-URL': storyMediaUrl,
      'Story-Content-Ratio': storyContentRatio.toList(),
      'Story-Time': storyTime,
      'Story-Date': storyDate,
      'Story-UserLiked-IDs': userLiked.toList(),
      'Story-Viewed-IDs': userViewed.toList(),
    };
  }
}

Stories createStories(Map<String, dynamic> record, DatabaseReference id) {
  for (var key in record.keys) {
    final firebaseValue = record[key.toLowerCase()];
    if (firebaseValue != null &&
        firebaseValue.isNotEmpty &&
        firebaseValue is! List) {
      record[key] = firebaseValue.toString();
    }
  }

  Stories story = Stories(
    record['Story-Unique-Author-ID'],
    record['Story-Unique-Body-ID'],
    record['Story-Media-Type'],
    record['Story-Media-URL'],
    List<String>.from(record['Story-Content-Ratio']),
    record['Story-Time'],
    record['Story-Date'],
    id,
  );

  // Initialize UserLiked and UserDisliked sets from the attribute
  story.userLiked = Set<String>.from(record['UserLiked'] ?? []);
  story.userViewed = Set<String>.from(record['UserViewed'] ?? []);

  return story;
}
