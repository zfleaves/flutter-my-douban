import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/color_constant.dart';
import 'package:flutter_douban/pages/movie/top_item_bean.dart';

class TopItemWidget extends StatelessWidget {
  final String title;
  final TopItemBean bean;
  final Color partColor;

  const TopItemWidget(
      {super.key,
      required this.title,
      required this.bean,
      this.partColor = Colors.brown});

  @override
  Widget build(BuildContext context) {
    if (bean == null) {
      return Container();
    }
    double _imgSize = MediaQuery.of(context).size.width / 5 * 3;

    return Container(
      width: _imgSize,
      height: _imgSize,
      padding: const EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: <Widget>[
            bean.imgUrl != '' ? CachedNetworkImage(
                width: _imgSize,
                height: _imgSize,
                fit: BoxFit.cover,
                imageUrl: bean.imgUrl) : Container(),
            Positioned(
                top: 8.0,
                right: 15.0,
                child: Text(
                  bean.count,
                  style: const TextStyle(fontSize: 12.0, color: Colors.white),
                )),
            Positioned(
              top: _imgSize / 2 - 40.0,
              left: 30.0,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 21.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: _imgSize / 2,
              child: Container(
                height: _imgSize / 2,
                width: _imgSize,
                color: partColor,
              ),
            ),
            Positioned(
                top: _imgSize / 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getChildren(bean.items),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  ///电影列表
  Widget getItem(Item item, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
          child: Text(
            '$i. ${item.title}',
            style: const TextStyle(fontSize: 13.0, color: Colors.white),
          ),
        ),
        Text(
          '${item.average}',
          style: const TextStyle(fontSize: 11.0, color: ColorConstant.colorOrigin),
        ),
      ],
    );
  }

  List<Widget> getChildren(List<Item> items) {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i++) {
      list.add(getItem(items[i], i + 1));
    }
    return list;
  }
}
