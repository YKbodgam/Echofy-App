import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getUserTokenList() async {
  List<String> deviceTokens = [];

  // Query the "Users" collection
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();

  final userDoc = querySnapshot.docs;

  // Iterate through the documents and retrieve the "Device-Token" field
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in userDoc) {
    Map<String, dynamic>? userData = documentSnapshot.data();
    if (userData != '' && userData.containsKey('Device-Token')) {
      String deviceToken = userData['Device-Token'];
      deviceTokens.add(deviceToken);
    }
  }

  return deviceTokens;
}
