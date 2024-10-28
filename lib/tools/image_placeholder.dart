import 'package:flutter/material.dart';
import 'package:flutter_douban/widgets/image/placeholder_image.dart';

Widget FrameBuilder(context, child, frame, wasSynchronouslyLoaded, fit) {
  if (wasSynchronouslyLoaded) {
    return child;
  }
  return AnimatedSwitcher(
      duration: const Duration(microseconds: 500),
      child: frame != null ? child : PlaceholderImage(fit: fit));
}

Widget ErrorBuilder(context, error, stackTrace, fit) {
  return PlaceholderImage(fit: fit);
}
