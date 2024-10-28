import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final stars;
  final double size;
  final double fontSize;
  final Color color;
  const RatingBar(this.stars, {super.key, this.size = 18, this.fontSize = 13, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    var stars2 = stars * 1.0;
    List<Widget> startList = [];
    //实心星星
    var startNumber = stars2 ~/ 2;
    //半实心星星
    var startHalf = 0;
    if (stars2.toString().contains('.')) {
      int tmp = int.parse((stars2.toString().split('.')[1]));
      if (tmp >= 5) {
        startHalf = 1;
      }
    }
    //空心星星
    var startEmpty = 5 - startNumber - startHalf;
    for (var i = 0; i < startNumber; i++) {
      startList.add(Icon(
        Icons.star,
        color: const Color.fromARGB(255, 255, 170, 71),
        size: size,
      ));
    }
    if (startHalf > 0) {
      startList.add(Icon(
        Icons.star_half,
        color: const Color.fromARGB(255, 255, 170, 71),
        size: size,
      ));
    }
    for (var i = 0; i < startEmpty; i++) {
      startList.add(Icon(
        Icons.star_border,
        color: Colors.grey,
        size: size,
      ));
    }
    startList.add(Text(
      '$stars',
      style: TextStyle(color: color, fontSize: fontSize),
    ));
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: startList,
      ),
    );
  }
}