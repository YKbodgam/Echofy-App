import 'package:flutter/material.dart';

import '../../Components Section/Colour Component/UIColours.dart';

class CustomNavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isBig;

  const CustomNavBarItem({
    super.key,
    required this.icon,
    this.isActive = false,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: isBig && isActive ? 40 : 25,
      color: isActive ? Colors.white : kPrimaryColor,
    );
  }
}
