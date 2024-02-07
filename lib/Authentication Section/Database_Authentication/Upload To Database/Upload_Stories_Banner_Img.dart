import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final Reference _storageRefrence = FirebaseStorage.instance.ref();

Future<String> uploadStoryImgToFirebase(
    String userId, String imagePath, String time, String date) async {
  try {
    Reference imageRef =
        _storageRefrence.child('$userId/Story Media/Image/$time $date.jpg');

    await imageRef.putFile(File(imagePath));

    String downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print("Error uploading image to Firebase Storage: $e");
    return '';
  }
}

Future<String> uploadStoryVidToFirebase(
    String userId, String imagePath, String time, String date) async {
  try {
    Reference imageRef =
        _storageRefrence.child('$userId/Story Media/Video/$time $date.jpg');

    await imageRef.putFile(File(imagePath));

    String downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print("Error uploading image to Firebase Storage: $e");
    return '';
  }
}
