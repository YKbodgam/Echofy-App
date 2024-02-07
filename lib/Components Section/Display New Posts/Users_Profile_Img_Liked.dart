import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../User Section/Authenticate User Section/Get_User_Unique_name.dart';

// Assuming you have a reference to your Firebase Database
DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

Future<String?> getUsername(String userId) async {
  final username = await getUsernameByUserId(userId);
  return username;
}

Future<List<String>> getProfileImages(List<String> userLiked) async {
  List<String> profileImages = [];

  if (userLiked.isNotEmpty) {
    int numberOfUsers = userLiked.length > 3 ? 3 : userLiked.length;

    for (int i = userLiked.length - 1;
        i >= userLiked.length - numberOfUsers;
        i--) {
      final uid = userLiked[i];
      DataSnapshot snapshot =
          (await databaseReference.child('Users/$uid/ProfileImg').once())
              .snapshot;

      String profileImageUrl = snapshot.value.toString();
      profileImages.add(profileImageUrl);
    }
  }

  return profileImages;
}

Widget likedByWidget(List<String> userLiked) {
  int maxDisplay = 3; // Maximum number of users to display

  return FutureBuilder(
    future: getProfileImages(userLiked),
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
        List<String> profileImageUrls = snapshot.data as List<String>;

        List<Widget> likedByWidgets = [];

        for (int i = 0; i < profileImageUrls.length && i < maxDisplay; i++) {
          likedByWidgets.add(
            Padding(
              padding: EdgeInsets.only(
                left: i * 15.0,
              ), // Adjust the spacing as needed
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  // Adjust the spacing as needed
                  width: 22, // Set the desired width
                  height: 22, // Set the desired height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.0),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.5),
                      width: 1,
                    ),
                  ),

                  child: CircleAvatar(
                    backgroundImage: profileImageUrls[i] != 'null'
                        ? CachedNetworkImageProvider(profileImageUrls[i])
                            as ImageProvider
                        : const AssetImage("assets/Images/Profile.jpg"),
                  ),
                ),
              ),
            ),
          );
        }

        likedByWidgets.add(
          Container(
            margin: profileImageUrls.length == 1
                ? const EdgeInsets.fromLTRB(35, 5, 0, 0)
                : profileImageUrls.length == 2
                    ? const EdgeInsets.fromLTRB(50, 5, 0, 0)
                    : const EdgeInsets.fromLTRB(65, 5, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Liked by ',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(fontSize: 10),
                  ),
                ),
                FutureBuilder(
                  future: getUsername(userLiked[userLiked.length - 1]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 40,
                          height: 22,
                          color: Colors.grey[300],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading username');
                    } else if (snapshot.hasData) {
                      String username = snapshot.data as String;

                      return Text(
                        username,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      return const Text('Unknown user');
                    }
                  },
                ),
                userLiked.length - 1 == 0
                    ? Text(
                        ' And others',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                      )
                    : Text(
                        ' And ${userLiked.length - 1} others',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                      ),
              ],
            ),
          ),
        );

        return Stack(
          children: likedByWidgets,
        );
      } else {
        return const Text('Unknown user');
      }
    },
  );
}
