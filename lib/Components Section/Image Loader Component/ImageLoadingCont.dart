import 'package:flutter/material.dart';

import '../../Components Section/Colour Component/UIColours.dart';

Widget buildLoadingContainer() {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: 3.0,
      color: kPrimaryColor,
      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
    ),
  );
}
