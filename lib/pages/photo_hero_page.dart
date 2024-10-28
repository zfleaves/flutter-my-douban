import 'package:flutter/material.dart';


class PhotoHeroPage extends StatelessWidget {
  final String photoUrl;
  final double width;
  const PhotoHeroPage({super.key, required this.photoUrl, required this.width});

  @override
  Widget build(BuildContext context) {
    return const Text('图片预览页面');
  }
}