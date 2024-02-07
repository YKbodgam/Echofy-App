import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colour Component/UIColours.dart';

Widget BuildPopularTags(String tagText, BuildContext context, bool Selected) {
  Size size = MediaQuery.of(context).size;
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: kPrimaryColor,
      ), // Border color // Border color
      boxShadow: [
        BoxShadow(
          color: kPrimaryColor.withOpacity(0.3),
          spreadRadius: 0,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(45),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selected
              ? const Icon(
                  Icons.done_outlined,
                  color: kPrimaryColor,
                  size: 12,
                )
              : const Text(
                  '#',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            width: 1.0,
            height: 15,
            color: kPrimaryColor,
          ),
          Text(
            tagText,
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                  fontSize: 9,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
