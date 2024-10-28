import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final BoxFit fit;
  const PlaceholderImage({super.key, this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        image: DecorationImage(image: AssetImage('assets/images/placeholder.png'), fit: BoxFit.fill)
      ),
    );
  }
}