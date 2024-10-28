import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double star;
  final int total;
  const StarRating(this.star, this.total, {super.key});

  List<Widget> getStarRating(double score, int total) {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < total; i++) {
      double factor = (score - i);
      if (factor >= 1) {
        factor = 1.0;
      } else if (factor < 0) {
        factor = 0;
      }
      list.add(Stack(
        children: <Widget>[
          const Icon(
            Icons.star,
            color: Colors.grey,
            size: 15.0,
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: factor,
              child: const Icon(
                Icons.star,
                size: 15.0,
                color: Colors.orange,
              ),
            ),
          )
        ],
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getStarRating(star, total),
    );
  }
}
