import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Check_User_Mediatype/Create_User_Stories_Img.dart';
import 'Check_User_Mediatype/Create_User_Stories_Vid.dart';
import '../../../../Components Section/Colour Component/UIColours.dart';

class CheckStory extends StatefulWidget {
  final String MediaType;
  final String UserId;

  final String Url;

  const CheckStory({
    super.key,
    required this.MediaType,
    required this.UserId,
    required this.Url,
  });

  @override
  State<CheckStory> createState() => _CheckStoryState();
}

class _CheckStoryState extends State<CheckStory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: kPrimaryLightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.MediaType == 'Video')
              Expanded(
                child: VideoCheckScreen(
                  size: size,
                  url: widget.Url,
                  userId: widget.UserId,
                ),
              ),
            if (widget.MediaType == 'Image')
              Expanded(
                child: PhotoCheckScreen(
                  size: size,
                  Url: widget.Url,
                  Userid: widget.UserId,
                ),
              ),
            if (widget.MediaType == 'Text')
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  maxLines: 5, // Allow multiple lines
                  onChanged: (text) {
                    setState(() {});
                  },
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Your Thoughts Here : ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Message cannot be empty \n";
                    } else if (value.length > 400) {
                      return "Cannot exceed 200 character count \n";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
