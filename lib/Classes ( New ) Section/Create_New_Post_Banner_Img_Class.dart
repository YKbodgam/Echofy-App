import 'package:firebase_database/firebase_database.dart';

class PostBannerImg {
  String postAuthorId;
  Map<String, double?> postBannerImgId;
  DatabaseReference bannerImgId;

  PostBannerImg(
    this.postAuthorId,
    this.postBannerImgId,
    this.bannerImgId,
  );

  void setBannerImgId(DatabaseReference id) {
    bannerImgId = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'Post-Body-Author-ID': postAuthorId,
      'Post-Banner-IMG-Url': postBannerImgId,
    };
  }
}

PostBannerImg createPostBannerImg(
    Map<String, dynamic> record, DatabaseReference id) {
  for (var key in record.keys) {
    final firebaseValue = record[key.toLowerCase()];
    if (firebaseValue != null && firebaseValue.isNotEmpty) {
      record[key] = firebaseValue.toString();
    }
  }

  PostBannerImg postBannerImg = PostBannerImg(
    record['Post-Body-Author-ID'],
    Map<String, double?>.from(record['Post-Banner-IMG-Url'] ?? {}),
    id,
  );

  return postBannerImg;
}
