import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colour Component/UIColours.dart';

class ResendButton extends StatelessWidget {
  final String text;
  final Function press;

  const ResendButton({
    super.key,
    required this.text,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        child: ElevatedButton(
          onPressed: () {
            press(); // Call the function when the button is pressed
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
              side: const BorderSide(
                color: kPrimaryColor, // Set the desired border color here
                width: 2.0, // Set the desired border width
              ),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: kPrimaryColor,
                fontSize: 14, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
