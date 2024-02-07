// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../Colour Component/UIColours.dart';

class ProfileImgChange extends StatelessWidget {
  ProfileImgChange({super.key});

  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;

  Future pickGalleryImg(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      Navigator.pop(context, _image?.path);
    } else {
      Navigator.pop(context, 'Null');
    }
  }

  Future pickCameraImg(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      Navigator.pop(context, _image?.path);
    } else {
      Navigator.pop(context, 'Null');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Profile Image",
                style: GoogleFonts.lobster(
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context, 'Delete');
                },
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  pickCameraImg(context);
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
                    Icons.camera_alt,
                    color: kPrimaryColor,
                    size: 22,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  pickGalleryImg(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: kPrimaryLightColor,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo,
                    color: kPrimaryColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
