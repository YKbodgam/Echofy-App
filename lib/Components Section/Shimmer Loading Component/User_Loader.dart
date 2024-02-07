import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserDataLoading extends StatelessWidget {
  final Size size;
  const UserDataLoading({super.key, required this.size});

  Widget _buildTextPlaceholder(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          size.width * 0.03, size.height * 0.01, size.width * 0.03, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.015,
          horizontal: size.width * 0.03,
        ),
        child: Row(
          children: [
            Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            _buildTextPlaceholder(size.width * 0.2, size.height * 0.015),
            const Spacer(),
            _buildTextPlaceholder(size.width * 0.1, size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
