import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';

class PhotoGrid extends StatelessWidget {
  final List<String> photos;
  final Function(String)? onDelete;
  final VoidCallback? onAddPhoto;

  const PhotoGrid({
    super.key,
    required this.photos,
    this.onDelete,
    this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = photos.length + (onAddPhoto != null ? 1 : 0);

    if (itemCount == 0) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (onAddPhoto != null && index == 0) {
          // Add photo button
          return InkWell(
            onTap: onAddPhoto,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Icon(Icons.add_a_photo, color: AppColors.primary),
              ),
            ),
          );
        }

        final photoIndex = onAddPhoto != null ? index - 1 : index;
        final photoUrl = photos[photoIndex];

        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surface,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surface,
                  child: const Icon(Icons.error, color: AppColors.error),
                ),
              ),
            ),
            if (onDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: InkWell(
                  onTap: () => onDelete!(photoUrl),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
