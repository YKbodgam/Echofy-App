import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colour Component/UIColours.dart';

Widget buildImagewithRatioWidget(
    double RatioText, String aspectRatio, BuildContext context, bool Selected) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      border: Border.all(
        color: Selected ? kPrimaryColor : kPrimaryLightColor,
      ), // Border color // Border color
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
    ),
    child: aspectRatio == 'Custom'
        ? SizedBox(
            width: 70,
            child: Center(
              child: Text(
                aspectRatio,
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(fontSize: 9, color: kPrimaryColor),
                ),
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: RatioText,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  aspectRatio,
                  style: GoogleFonts.nunito(
                    textStyle:
                        const TextStyle(fontSize: 9, color: kPrimaryColor),
                  ),
                ),
              ),
            ),
          ),
  );
}
