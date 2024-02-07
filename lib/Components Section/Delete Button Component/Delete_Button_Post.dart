import 'package:flutter/material.dart';

import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';
import '../../Components Section/Colour Component/UIColours.dart';
import '../../Authentication Section/Database_Authentication/Update User Database/Delete_Post_From_Server.dart';

Widget buildDeleteButton(Post post, BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.delete_outline,
      color: kPrimaryColor, // Set the color as needed
      size: 15,
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Are you sure you want to delete this post?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  deleteAuthorPost(post.postAuthorId, post.postBodyId);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    },
  );
}
