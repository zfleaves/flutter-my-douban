import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

class LookConfirmButton extends StatefulWidget {
  final String btnText;
  final String iconAsset;
  final Color pressedColor;
  final VoidCallback? onPressed;
  final Color defaultColor;

  const LookConfirmButton(
      {super.key,
      required this.btnText,
      required this.iconAsset,
      required this.pressedColor,
      this.onPressed,
      required this.defaultColor});

  @override
  State<LookConfirmButton> createState() => _LookConfirmButtonState();
}

class _LookConfirmButtonState extends State<LookConfirmButton> {
  // ignore: prefer_typing_uninitialized_variables
  var _color;
  late Color _defaultColor;

  @override
  void initState() {
    super.initState();
    _color = widget.defaultColor;
    _defaultColor = widget.defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      onTapDown: (TapDownDetails details) {
        setState(() {
          _color = widget.pressedColor;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _color = _defaultColor;
        });
      },
      onTapCancel: ((){
        setState(() {
          _color = _defaultColor;
        });
      }),
      child: Container(
        alignment: Alignment.center,
        height: 35.0,
        decoration: BoxDecoration(
            color: _color,
            borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Image.asset(
                widget.iconAsset,
                width: 22.0,
                height: 22.0,
              ),
            ),
            Text(
              widget.btnText,
              style: const TextStyle(fontSize: 17.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
