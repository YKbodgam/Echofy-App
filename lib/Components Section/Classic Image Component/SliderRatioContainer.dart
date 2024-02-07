import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderRatioContainer extends StatelessWidget {
  final List Items;
  final Size size;
  final Function(int) onPageChangedCallback;
  final String Shape;

  const SliderRatioContainer({
    super.key,
    required this.Items,
    required this.size,
    required this.onPageChangedCallback,
    required this.Shape, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        enableInfiniteScroll: false, // Set to false to disable infinite scroll
        disableCenter:
            true, // Set to true to disable centering on the current item
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          onPageChangedCallback(index); // Call the callback
        },
      ),
      itemCount: Items.length,
      itemBuilder: (context, index, realIndex) {
        ///

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
            child: Image(
              image: FileImage(File(Items[index])),
              fit: Shape == 'Fill '
                  ? BoxFit.fill
                  : Shape == 'Fit'
                      ? BoxFit.contain
                      : BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
