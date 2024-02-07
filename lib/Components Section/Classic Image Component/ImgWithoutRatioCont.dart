import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Image Loader Component/ImageErrorCont.dart';
import '../Image Loader Component/ImageLoadingCont.dart';

Widget buildImgWithoutRContainer(
  Size size,
  String getImage,
) {
  return Container(
    margin: const EdgeInsets.all(5),
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
      child: CachedNetworkImage(
        imageUrl: getImage,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => buildErrorContainer(),
        placeholder: (context, url) => buildLoadingContainer(),
      ),
    ),
  );
}
