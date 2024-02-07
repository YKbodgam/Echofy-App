import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Image Loader Component/ImageErrorCont.dart';
import '../Image Loader Component/ImageLoadingCont.dart';

class SliderNetImage extends StatelessWidget {
  final List Items;
  final Size size;
  final Function(int) onPageChangedCallback;

  const SliderNetImage({
    super.key,
    required this.Items,
    required this.size,
    required this.onPageChangedCallback,
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
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CachedNetworkImage(
              imageUrl: Items[index],
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => buildErrorContainer(),
              placeholder: (context, url) => buildLoadingContainer(),
            ),
          ),
        );
      },
    );
  }
}
