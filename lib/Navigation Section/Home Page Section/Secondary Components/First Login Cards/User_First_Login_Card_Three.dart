import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Components Section/Colour Component/UIColours.dart';

class FirstLoginCardThird extends StatelessWidget {
  final Size size;
  const FirstLoginCardThird({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.02, horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 187, 208, 255),
            Color.fromARGB(255, 200, 182, 255),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 0,
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Reply : ",
            style: GoogleFonts.roboto(
              textStyle:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          const Divider(
            color: Colors.black,
            height: 3,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          SizedBox(
            height: size.height * 0.08,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  bottom: 15,
                ),
                child: Text(
                  "Replies are specific responses to individual comments, creating a threaded conversation. They allow users to engage in more focused discussions, respond directly to someone else's input, or address particular points within a larger conversation. Replies help organize discussions and make it easier for users to follow and participate in specific threads. Replies play a crucial role in fostering communication and engagement within online communities and platforms. Whether you're navigating a social media platform, participating in a discussion forum, or exploring a blog, understanding how replies work can greatly enhance your interactive experience.",
                  style: GoogleFonts.robotoSlab(
                    textStyle: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: kPrimaryColor,
                    ),
                  ),
                  child: const Text(
                    'Reply +',
                    style: TextStyle(
                      fontSize: 11,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: kPrimaryColor,
                    ),
                  ),
                  child: const Text(
                    'Read more ',
                    style: TextStyle(
                      fontSize: 11,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
