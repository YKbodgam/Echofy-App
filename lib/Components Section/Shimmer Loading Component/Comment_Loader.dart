import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentShimmerLoader extends StatelessWidget {
  final Size size;

  const CommentShimmerLoader({super.key, required this.size});

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
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          size.width * 0.01,
          size.height * 0.02,
          size.width * 0.01,
          0,
        ),
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 35.0,
                  height: 35.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                _buildTextPlaceholder(size.width * 0.2, size.height * 0.015),
                SizedBox(
                  width: size.width * 0.03,
                ),
                _buildTextPlaceholder(size.width * 0.1, size.height * 0.02),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              width: size.width * 0.8,
              margin: EdgeInsets.fromLTRB(
                  size.width * 0.09, 0, size.width * 0.02, 0),
              padding: EdgeInsets.all(size.width * 0.03),
              child:
                  _buildTextPlaceholder(size.width * 0.8, size.height * 0.05),
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  child: _buildTextPlaceholder(
                      size.width * 0.1, size.height * 0.015),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
