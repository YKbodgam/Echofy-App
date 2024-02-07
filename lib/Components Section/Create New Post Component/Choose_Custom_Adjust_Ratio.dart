import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colour Component/UIColours.dart';

Widget buildImageFillerWidget(
    String Shape, BuildContext context, bool Selected) {
  Size size = MediaQuery.of(context).size;
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Selected ? kPrimaryColor : kPrimaryLightColor,
      ), // Border color // Border color
      borderRadius: BorderRadius.circular(45),
      color: kPrimaryLightColor,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selected
              ? const Icon(
                  Icons.done_outlined,
                  color: kPrimaryColor,
                  size: 14,
                )
              : const Icon(
                  Icons.flip_to_back_outlined,
                  color: kPrimaryColor,
                  size: 14,
                ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            width: 1.0,
            height: 15,
            color: kPrimaryColor,
          ),
          Text(
            Shape,
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(fontSize: 10, color: kPrimaryColor),
            ),
          ),
        ],
      ),
    ),
  );
}
