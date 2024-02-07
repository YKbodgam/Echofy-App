import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Colour Component/UIColours.dart';

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  bool loading;

  RoundedButton({
    super.key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ElevatedButton(
          onPressed: () async {
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.none) {
              // No internet connection, you can display a snackbar or dialog
              // to inform the user.
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No internet connection"),
                ),
              );
            } else {
              // Internet connection is available, call the press function.
              press();
            }
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 17.0, horizontal: 40.0),
            backgroundColor: color,
            // Replace 'primaryColor' with your desired color
          ),
          child: Container(
            height: 25,
            alignment: Alignment.center,
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: textColor,
                        fontSize: 16, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
