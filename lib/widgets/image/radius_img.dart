import 'package:flutter/material.dart';
import 'package:flutter_douban/tools/image_placeholder.dart';
import 'package:flutter_douban/widgets/image/placeholder_image.dart';

class RadiusImg {
  RadiusImg(small);

  static Widget get(String imgUrl, double? imgW, { double? imgH, Color? shadowColor, double? elevation, double radius = 6.0, RoundedRectangleBorder? shape} ) {
    shadowColor ??= Colors.transparent;
    return Card(
      //影音海报
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius))
      ),
      color: shadowColor,
      clipBehavior: Clip.antiAlias,
      elevation: elevation == null ? 0 : 5,
      // ignore: unnecessary_null_comparison
      child: imgW == 0 ? Image.network(
        imgUrl,
        height: imgH,
        fit: BoxFit.cover,
        // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        //   return FrameBuilder(context, child, frame, wasSynchronouslyLoaded, BoxFit.cover,);
        // },
        errorBuilder: (context, error, stackTrace)  {
          return const PlaceholderImage(fit: BoxFit.cover);
        },
      ) : Image.network(
        imgUrl,
        width: imgW,
        fit: imgH == 0 ? BoxFit.contain : BoxFit.cover,
        // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        //   return FrameBuilder(context, child, frame, wasSynchronouslyLoaded, imgH == 0 ? BoxFit.contain : BoxFit.cover,);
        // },
        // errorBuilder: (context, error, stackTrace) => ErrorBuilder(context, error, stackTrace, imgH == 0 ? BoxFit.contain : BoxFit.cover),
        errorBuilder: (context, error, stackTrace)  {
          return PlaceholderImage(fit: imgH == 0 ? BoxFit.contain : BoxFit.cover);
        },
      ),
    );
  }
}