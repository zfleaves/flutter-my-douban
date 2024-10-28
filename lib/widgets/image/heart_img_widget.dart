import 'package:flutter/material.dart';

class HeartImgWidget extends StatefulWidget {
  final Image img;
  const HeartImgWidget(this.img, {super.key});

  @override
  State<HeartImgWidget> createState() => _HeartImgWidgetState();
}

class _HeartImgWidgetState extends State<HeartImgWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedImg(widget.img, animation: animation);
  }
}

class _AnimatedImg extends AnimatedWidget {
  static final _opacityTween = new Tween<double>(begin: 0.5, end: 1.0);
  static final _sizeTween = new Tween<double>(begin: 290.0, end: 300.0);
  final Image img;

  _AnimatedImg(
    this.img, {
    Key? key,
    required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    // final Listenable animation = listenable;
    final Animation<double> animation = listenable as Animation<double>;  
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
         child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          child: img,
         )
      ),
    );
  }
}
