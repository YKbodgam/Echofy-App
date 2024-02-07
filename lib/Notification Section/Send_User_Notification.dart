import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:echofy_app/User%20Section/Authenticate%20User%20Section/Get_User_Unique_name.dart';
import 'package:echofy_app/User%20Section/Authenticate%20User%20Section/Get_User_Device_Token.dart';
import 'package:echofy_app/User%20Section/Authenticate%20User%20Section/Get_All_Device_Token_List.dart';

Future<void> NotifyUser(
  String CurrentUserId,
  String OtherUserId,
  String Token,
  String NotifyType,
  String Message,
) async {
  // Get the user from the database

  String Username = await getUsernameByUserId(CurrentUserId);

  late String resultTitle;
  late String resultMessage;

  if (NotifyType == 'Post') {
    resultTitle = 'New post from ${Username.toString()}';
    resultMessage = Message.toString();
    //
  } else if (NotifyType == 'Like') {
    resultTitle = '$Username Liked your post';
    resultMessage = 'Check details about your post';
    //
  } else if (NotifyType == 'Reply') {
    resultTitle = '$Username Replied to your post';
    resultMessage = 'Check details about your post';
    //
  } else if (NotifyType == 'Comment') {
    resultTitle = '$Username Commented on your post';
    resultMessage = 'Check details about your post';
    //
  } else if (NotifyType == 'Request') {
    resultTitle = '$Username Requested to follow you';
    resultMessage = 'Check the follow request and verify';
    //
  } else {
    resultTitle = 'Something Happened';
    resultMessage = 'Someone Cooked Here !';
  }

  List<Map<String, dynamic>> dataList = [];

  if (Token == 'Special') {
    dataList.add({
      'to': await getUserToken(
        await getUsernameByUserId(OtherUserId),
      ),
      'priority': 'high',
      'notification': {
        'title': resultTitle,
        'body': resultMessage,
      },
      'data': {
        'type': NotifyType,
      }
    });
  } else {
    List<String> recipientTokens = await getUserTokenList();
    for (var recipientToken in recipientTokens) {
      dataList.add({
        'to': recipientToken,
        'priority': 'high',
        'notification': {
          'title': resultTitle,
          'body': resultMessage,
        },
        'data': {
          'type': NotifyType,
        }
      });
    }
  }

  for (var data in dataList) {
    await SendNotificationFurther(data);
  }
}

Future<void> SendNotificationFurther(Map<String, dynamic> data) async {
  await http.post(
    Uri.parse(
      'https://fcm.googleapis.com/fcm/send',
    ),
    body: jsonEncode(
      data,
    ),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization':
          'key=AAAA727VMJg:APA91bGP_5kNOCvB0DDl0--7hPZV6Um8TxiDoZD6x0pNdzTSy_GKKRgFxn5WVq85R-ox6775EHqZOsZV3Ixwdv1vq7GYcJeRuVBDDfwL5YghUwCpZQCBcdJji9KGoZyrY0w3_9YNjnO2',
    },
  );
}
