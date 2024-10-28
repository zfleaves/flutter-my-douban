import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/color_constant.dart';
import 'package:flutter_douban/constant/text_size_constant.dart';

typedef OnClick = void Function();

///左边是豆瓣热门，右边是全部
class ItemCountTitle extends StatelessWidget {
  final int count;
  final OnClick? onClick;
  final String title;
  final double  fontSize;
  const ItemCountTitle(this.title, {super.key, this.onClick, this.count = 0, this.fontSize = TextSizeConstant.BookAudioPartTabBar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: ColorConstant.colorDefaultTitle),
            )
          ),
          Text(
            '全部 $count > ',
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, ),
          )
        ],
      ),
      onTap: () {
        if (onClick != null) {
          onClick!();
        }
      },
    );
  }
}