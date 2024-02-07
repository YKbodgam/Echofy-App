import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getUserToken(String username) async {
  // Query the "Users" collection for the specified username
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection('Users')
      .where('Username', isEqualTo: username)
      .get();

  final UserDoc = querySnapshot.docs.first;
  final DeviceToken = UserDoc.data()['Device-Token'];

  // Check if any matching documents were found
  if (DeviceToken != null && DeviceToken != '') {
    // Retrieve the first document and get the "Device-Token" field
    return DeviceToken;
  } else {
    return 'null'; // User not found with the given userId
  }
}
