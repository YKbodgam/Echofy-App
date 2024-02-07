import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Classes ( New ) Section/Create_New_Post_Main_Class.dart';

class PostSkeletonLoader extends StatelessWidget {
  final Post post;
  final Size size;

  const PostSkeletonLoader({
    super.key,
    required this.post,
    required this.size,
  });
  Widget _buildTextPlaceholder(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(1, 2),
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
              _buildTextPlaceholder(size.width * 0.2, size.height * 0.015),
              const Spacer(),
              _buildTextPlaceholder(size.width * 0.05, size.height * 0.02),
            ],
          ),
          // Placeholder for the post image
          SizedBox(height: size.height * 0.02),

          Visibility(
            visible: post.postBannerImgId.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.02),

          // Placeholder for post details
          _buildTextPlaceholder(size.width * 0.9, size.height * 0.018),
          SizedBox(height: size.height * 0.012),
          // Placeholder for post content
          _buildTextPlaceholder(size.width * 0.9, size.height * 0.018),

          SizedBox(height: size.height * 0.02),

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
