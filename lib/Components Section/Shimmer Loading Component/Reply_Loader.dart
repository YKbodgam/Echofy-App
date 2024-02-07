import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReplySkeletonLoader extends StatelessWidget {
  final Size size;

  const ReplySkeletonLoader(this.size, {super.key});

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
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.01, horizontal: size.width * 0.02),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for the user's avatar
          Row(
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
              _buildTextPlaceholder(size.width * 0.2, size.height * 0.02),
              const Spacer(),
              _buildTextPlaceholder(size.width * 0.05, size.height * 0.02),
            ],
          ),
          // Placeholder for the post image
          SizedBox(height: size.height * 0.02),

          Row(
            children: [
              SizedBox(width: size.width * 0.12),
              Container(
                width: size.width * 0.7,
                height: size.height * 0.095,
                color: Colors.grey[300],
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for the user's avatar
                      Row(
                        children: [
                          Container(
                            width: 25.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.grey[200]!,
                            child: Container(
                              width: size.width * 0.2,
                              height: size.height * 0.02,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Placeholder for the post image
                      SizedBox(height: size.height * 0.012),

                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey[200]!,
                        child: Container(
                          width: size.width * 0.7,
                          height: size.height * 0.018,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: size.height * 0.02),

          // Placeholder for post details
          _buildTextPlaceholder(size.width * 0.9, size.height * 0.018),
          SizedBox(height: size.height * 0.012),
          // Placeholder for post content

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextPlaceholder(size.width * 0.6, size.height * 0.02),
            ],
          ),

          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }
}
