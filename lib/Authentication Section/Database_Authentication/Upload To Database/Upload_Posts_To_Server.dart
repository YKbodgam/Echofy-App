import 'package:firebase_database/firebase_database.dart';

import '../../../Classes ( New ) Section/Create_New_Post_Body_Class.dart';
import '../../../Classes ( New ) Section/Create_New_Post_Banner_Img_Class.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference newPostBodyRef =
    _databaseReference.child('Message-Body').push();

DatabaseReference newPostBannerImg =
    _databaseReference.child('Banner-Img').push();

DatabaseReference savePostBody(PostBody body) {
  var id = _databaseReference.child('Post-Body').push();
  id.set(body.toJson());
  return id;
}

DatabaseReference savePostBannerImg(PostBannerImg img) {
  var id = _databaseReference.child('Img-Urls').push();
  id.set(img.toJson());
  return id;
}
