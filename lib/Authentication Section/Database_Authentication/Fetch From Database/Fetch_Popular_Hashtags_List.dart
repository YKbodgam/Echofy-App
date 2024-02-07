import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.ref();

Future<List<String>> getPopularHashtags() async {
  // Assuming your posts are stored under the "Posts" node
  DataSnapshot snapshot =
      (await databaseReference.child('posts').once()).snapshot;

  dynamic hashshot = snapshot.value;

  // Collect all hashtags and count occurrences
  Map<String, int> hashtagCount = {};

  if (hashshot != null) {
    hashshot.forEach((key, post) {
      if (post != null &&
          post['Post-Hastags'] != null &&
          post['Post-Hastags'] is List) {
        // Make sure 'Hashtags' is not null and is a List
        List<dynamic> hashtags = post['Post-Hastags'];

        for (var hashtag in hashtags) {
          if (hashtag != null && hashtag != '' && hashtag is String) {
            // Make sure the individual hashtag is not null and is a String
            hashtagCount[hashtag] = (hashtagCount[hashtag] ?? 0) + 1;
          }
        }
      }
    });

    // Sort hashtags by popularity (occurrences)
    List<String> popularHashtags = hashtagCount.keys.toList();
    popularHashtags
        .sort((a, b) => hashtagCount[b]!.compareTo(hashtagCount[a]!));

    return popularHashtags;
  } else {
    return [];
  }
}
