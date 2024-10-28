import 'package:flutter/material.dart';

class SearchTextFieldWidget extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTab;
  final String? hintText;
  final EdgeInsetsGeometry? margin;
  final bool readOnly;
  const SearchTextFieldWidget({super.key, this.onSubmitted, this.onTab, this.hintText, this.margin, this.readOnly = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0.0),
      width: MediaQuery.of(context).size.width,
      alignment: AlignmentDirectional.center,
      height: 37.0,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 236, 237),
          borderRadius: BorderRadius.circular(24.0)),
      child: TextField(
        onSubmitted: onSubmitted,
        onTap: onTab,
        readOnly: readOnly,
        cursorColor: const Color.fromARGB(255, 0, 189, 96),
        style: const TextStyle(fontSize: 17),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 0.0),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
                fontSize: 17, color: Color.fromARGB(255, 192, 191, 191)),
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
            color: Color.fromARGB(255, 128, 128, 128),
          )
        ),
      ),
    );
  }
}