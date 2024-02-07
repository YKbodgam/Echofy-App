import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CenteredTextWithPadding extends StatelessWidget {
  const CenteredTextWithPadding({super.key});

  @override
  Widget build(BuildContext context) {
    String text = "Welcome To\n Echofy App"; // Replace with your string

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20), // Adjust the padding as needed
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 28),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
