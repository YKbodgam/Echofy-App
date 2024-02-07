import 'dart:io';

import 'package:flutter/material.dart';

class WithRatioContainer extends StatelessWidget {
  final double aspectRatio;
  final String ImagePath;
  final Size size;
  final bool inslider;
  final String Shape;

  const WithRatioContainer({
    super.key,
    required this.aspectRatio,
    required this.ImagePath,
    required this.size,
    this.inslider = false,
    required this.Shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: AspectRatio(
          aspectRatio:
              aspectRatio, // Adjust the aspect ratio based on your design
          child: Image(
            image: FileImage(
              File(ImagePath),
            ),
            fit: Shape == 'Fill '
                ? BoxFit.fill
                : Shape == 'Fit'
                    ? BoxFit.contain
                    : BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
