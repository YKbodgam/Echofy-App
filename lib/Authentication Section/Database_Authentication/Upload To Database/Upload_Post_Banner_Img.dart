import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

final Reference _storageRefrence = FirebaseStorage.instance.ref();

Future<String> uploadPostImgToFirebase(String userId, String imagePath,
    String Time, String Date, String Postno) async {
  try {
    Reference imageRef =
        _storageRefrence.child('$userId/PostImage/$Time $Date $Postno.jpg');

    await imageRef.putFile(File(imagePath));

    String downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print("Error uploading image to Firebase Storage: $e");
    return '';
  }
}
