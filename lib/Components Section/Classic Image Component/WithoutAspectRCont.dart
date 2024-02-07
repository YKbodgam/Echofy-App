import 'dart:io';
import 'package:flutter/material.dart';

class WithoutRatioContainer extends StatelessWidget {
  final String ImagePath;
  final Size size;
  final String Shape;

  const WithoutRatioContainer({
    super.key,
    required this.ImagePath,
    required this.size,
    required this.Shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: size.height * 0.3,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(
          image: FileImage(File(ImagePath)),
          fit: Shape == 'Fill '
              ? BoxFit.fill
              : Shape == 'Fit'
                  ? BoxFit.contain
                  : BoxFit.cover,
        ),
      ),
    );
  }
}
