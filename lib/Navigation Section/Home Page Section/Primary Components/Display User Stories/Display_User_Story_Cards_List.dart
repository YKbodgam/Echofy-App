import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

import 'StoriesContainer.dart';
import '../../../../User Section/Fetch User Details Section/Fetch_User_Profile_Img.dart';

Widget displayStoryWidget(List<dynamic> storyList, String userid) {
  return FutureBuilder(
    future: getProfileImg(storyList[0].storyAuthorId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 22,
            height: 22,
            color: Colors.grey[300],
          ),
        );
      } else if (snapshot.hasError) {
        return const Text('Error loading profile images');
      } else if (snapshot.hasData) {
        List<Widget> storyWidgets = [];

        for (int i = 0; i < storyList.length; i++) {
          storyWidgets.add(
            Padding(
              padding: EdgeInsets.only(
                left: i * 10.0,
                top: i * 3.0,
                bottom: i * 3.0,
              ), // Adjust the spacing as needed
              child: Align(
                alignment: Alignment.topLeft,
                child: StroiesCard(
                  story: storyList[i],
                  userId: userid,
                ),
              ),
            ),
          );
        }

        return Stack(
          children: storyWidgets.reversed.toList(),
        );
      } else {
        return const Text('Unknown user');
      }
    },
  );
}
