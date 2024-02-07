// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Colour Component/UIColours.dart';

class ChooseStoryContent extends StatefulWidget {
  const ChooseStoryContent({super.key});

  @override
  State<ChooseStoryContent> createState() => _ChooseStoryContentState();
}

class _ChooseStoryContentState extends State<ChooseStoryContent> {
  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  XFile? _video;
  XFile? get video => _video;

  Future<void> pickGalleryVideo(BuildContext context) async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      _video = XFile(pickedVideo.path);
      Navigator.pop(context, ['Video', _video?.path]);
    } else {
      Navigator.pop(context, ['Null', 'Null']);
    }
  }

  Future pickGalleryImg(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      Navigator.pop(context, ['Image', _image?.path]);
    } else {
      Navigator.pop(context, ['Null', 'Null']);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 4.0,
          width: 50.0,
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          child: Row(
            children: [
              Text(
                "Choose Story Content : ",
                style: GoogleFonts.lobster(
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context, ['Null', 'Null']);
                },
                icon: const Icon(
                  Icons.close_outlined,
                  size: 20,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  pickGalleryImg(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: kPrimaryLightColor,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: kPrimaryColor,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  pickGalleryVideo(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: kPrimaryLightColor,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.video_library_outlined,
                    color: kPrimaryColor,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, ['Text', 'Null']);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: kPrimaryLightColor,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.text_fields_outlined,
                    color: kPrimaryColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
