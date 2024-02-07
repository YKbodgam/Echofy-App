import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echofy_app/Notification%20Section/User_Notification_Services.dart';
import 'package:echofy_app/User%20Section/Authenticate%20User%20Section/Get_User_Unique_name.dart';

Future<void> UpdateToken(String userid) async {
  try {
    // Query the "Users" collection for the specified username

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Users')
            .where(
              'Username',
              isEqualTo: await getUsernameByUserId(userid),
            )
            .get();

    // Check if any matching documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the document reference for the first matching document
      final userReference = querySnapshot.docs.first;
      final UserRefId = userReference.id;

      // Update the "Device-Token" field with the new device token
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(UserRefId)
          .update(
        {
          'Device-Token': await GetDeviceToken(),
        },
      );
    } else {
      // Handle the case where no matching user is found
      print('No matching user found for username');
    }
  } catch (e) {
    print('Error updating Device Token: $e');
  }
}
