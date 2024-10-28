import 'package:flutter/material.dart';
import 'package:flutter_douban/widgets/photo_hero.dart';

///点击图片放大显示
class AnimalPhoto {
  AnimalPhoto.show(BuildContext context, String url, {double? width}) {
    width ??= MediaQuery.of(context).size.width;
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Container(
        // The blue background emphasizes that it's a new route.
        color: Colors.transparent,
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: PhotoHero(
          photo: url,
          width: width!,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }));
  }
}