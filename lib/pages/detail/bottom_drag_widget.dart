import 'package:flutter/material.dart';
import 'package:flutter_douban/pages/detail/drag_container.dart';

class BottomDragWidget extends StatelessWidget {
  final Widget body;
  final DragContainer dragContainer;
  const BottomDragWidget({super.key, required this.body, required this.dragContainer});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        body,
        Align(
          alignment: Alignment.bottomCenter,
          child: dragContainer,
        )
      ],
    );
  }
}
