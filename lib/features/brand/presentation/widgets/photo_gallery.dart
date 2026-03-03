import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> photoUrls;

  const PhotoGallery({super.key, required this.photoUrls});

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photoUrls.length,
        itemBuilder: (context, index) {
          final url = photoUrls[index];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: url,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 120.w,
                  height: 120.h,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120.w,
                  height: 120.h,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
