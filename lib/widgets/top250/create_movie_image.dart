import 'package:flutter/material.dart';
import 'package:flutter_douban/widgets/image/placeholder_image.dart';

///公用圆角图片
class CreateMovieImage extends StatelessWidget {
  final String imgUrl;
  final double imageHeight;
  final BoxFit fit;
  const CreateMovieImage({super.key, required this.imgUrl, this.imageHeight = 150.0, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Image.network(
        imgUrl,
        height: imageHeight,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return AnimatedSwitcher(
              duration: const Duration(microseconds: 500),
              child: frame != null ? child : PlaceholderImage(fit: fit));
        },
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return PlaceholderImage(fit: fit);
        },
      ),
    );
  }
}
