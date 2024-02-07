import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final Reference _storageRefrence = FirebaseStorage.instance.ref();

Future<String> uploadImageToFirebase(String userId, String imagePath) async {
  try {
    Reference imageRef =
        _storageRefrence.child('$userId/profileImage/Profile.jpg');

    await imageRef.putFile(File(imagePath));

    String downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print("Error uploading image to Firebase Storage: $e");
    return '';
  }
}
