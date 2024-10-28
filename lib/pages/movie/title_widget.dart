import 'package:flutter/material.dart';
import 'package:flutter_douban/router.dart';

typedef TapCallback = void Function();

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _TextImgWidget(
          '找电影',
          'assets/images/find_movie.png',
          tabCallBack: () {
            MyRouter.push(context, MyRouter.searchPage, '找电影');
          },
        ),
        _TextImgWidget(
          '豆瓣榜单',
          'assets/images/douban_top.png',
          tabCallBack: () {
            print('点击豆瓣榜单');
            MyRouter.push(context, MyRouter.searchPage, '豆瓣榜单');
          },
        ),
        _TextImgWidget(
          '豆瓣猜',
          'assets/images/douban_guess.png',
          tabCallBack: () {
            MyRouter.push(context, MyRouter.searchPage, '豆瓣猜');
          },
        ),
        _TextImgWidget(
          '豆瓣片单',
          'assets/images/douban_film_list.png',
          tabCallBack: () {
            MyRouter.push(context, MyRouter.searchPage, '豆瓣片单');
          },
        )
      ],
    );
  }
}

class _TextImgWidget extends StatelessWidget {
  final String text;
  final String imgAsset;
  final TapCallback tabCallBack;
  const _TextImgWidget(this.text, this.imgAsset,{super.key, required this.tabCallBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tabCallBack,
      child: Column(
        children: <Widget>[
          Image.asset(
            imgAsset,
            width: 45,
            height: 45,
          ),
          Text(
            text,
            style: const TextStyle(
                fontSize: 13, color: Color.fromARGB(255, 128, 128, 128)),
          )
        ],
      ),
    );
  }
}
