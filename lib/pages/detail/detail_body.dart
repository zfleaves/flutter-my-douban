import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/comments_entity.dart';
import 'package:flutter_douban/bean/movie_detail_bean.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/pages/detail/detail_title_widget.dart';
import 'package:flutter_douban/pages/detail/score_start.dart';
import 'dart:math' as math;

import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/animal_photo.dart';
import 'package:flutter_douban/widgets/expandable_text%20.dart';
import 'package:flutter_douban/widgets/rating_bar.dart';

class DetailBody extends StatefulWidget {
  final MovieDetailBean movieDetailBean;
  final Color pickColor;
  final CommentsEntity commentsEntity;
  const DetailBody(
      {super.key,
      required this.movieDetailBean,
      required this.pickColor,
      required this.commentsEntity});

  @override
  State<DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  late MovieDetailBean _movieDetailBean;
  late CommentsEntity commentsEntity;

  @override
  void initState() {
    super.initState();
    _movieDetailBean = widget.movieDetailBean;
    commentsEntity = widget.commentsEntity;
    print(commentsEntity.comments);
  }

  @override
  Widget build(BuildContext context) {
    var details = _movieDetailBean.rating?.details;
    var allCount =
        details?.d1 + details?.d2 + details?.d3 + details?.d4 + details?.d5;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: const Text('电影详情'),
          centerTitle: true,
          pinned: true,
          backgroundColor: widget.pickColor,
        ),
        SliverToBoxAdapter(
          // child: getPadding(DetailTitleWidget(_movieDetailBean, widget.pickColor)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT),
            child: DetailTitleWidget(_movieDetailBean, widget.pickColor),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
            margin: padding(),
            child: ScoreStartWidget(
              score: _movieDetailBean.rating?.average,
              p1: details?.d1 / allCount,
              p2: details?.d2 / allCount,
              p3: details?.d3 / allCount,
              p4: details?.d4 / allCount,
              p5: details?.d5 / allCount,
            ),
          ),
        ),
        sliverTags(),
        sliverSummary(),
        sliverCasts(),
        trailers(context),
        sliverComments(),
      ],
    );
  }

  ///所属频道
  SliverToBoxAdapter sliverTags() {
    return SliverToBoxAdapter(
      child: Container(
        height: 30.0,
        padding: padding(),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _movieDetailBean.tags!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  alignment: Alignment.center,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '所属频道',
                      style: TextStyle(color: Colors.white70, fontSize: 13.0),
                    ),
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: const BoxDecoration(
                      color: Color(0x23000000),
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  child: Text(
                    '${_movieDetailBean.tags?[index - 1]}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
            }),
      ),
    );
  }

  ///剧情简介
  SliverToBoxAdapter sliverSummary() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0x44000000),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
              child: Text(
                '剧情简介',
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '${_movieDetailBean.summary}',
              style: const TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  ///演职员
  SliverToBoxAdapter sliverCasts() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
            left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  const Expanded(
                      child: Text('演职员',
                          style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                  Text(
                    '全部 ${_movieDetailBean.casts?.length} >',
                    style:
                        const TextStyle(fontSize: 12.0, color: Colors.white70),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 150.0,
              child: ListView.builder(
                itemBuilder: ((BuildContext context, int index) {
                  if (index == 0 && _movieDetailBean.directors!.isNotEmpty) {
                    //第一个显示导演
                    Director director = _movieDetailBean.directors![0];
                    if (director.avatars == null) {
                      return Container();
                    }
                    return getCast('${director.id}',
                        '${director.avatars!.large}', '${director.name}');
                  } else {
                    Cast cast = _movieDetailBean.casts![index - 1];
                    if (cast.avatars == null) {
                      return Container();
                    }
                    return getCast(
                        '${cast.id}', '${cast.avatars?.large}', '${cast.name}');
                  }
                }),
                itemCount: math.min(9, _movieDetailBean.casts!.length + 1),
                //最多显示9个演员
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
    );
  }

  ///预告片、剧照 727x488
  trailers(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 5 * 3;
    var h = w / 727 * 488;
    var bloopers = _movieDetailBean.bloopers;
    _movieDetailBean.trailers?.addAll(bloopers!);

    return SliverToBoxAdapter(
      child: Padding(
        padding: padding(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    '预告片 / 剧照',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                  Text('全部 ${_movieDetailBean.photos?.length} >',
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Color.fromARGB(255, 192, 193, 203)))
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              height: h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _movieDetailBean.photos!.length +
                    (_movieDetailBean.trailers!.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0 && _movieDetailBean.trailers!.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {
                        MyRouter.push(context, MyRouter.playListPage,
                            _movieDetailBean.trailers);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Stack(
                          children: <Widget>[
                            _getTrailers(w, h),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: h,
                              child: const Icon(
                                Icons.play_circle_outline,
                                size: 40.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 232, 145, 66),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                              ),
                              child: const Text(
                                '预告片',
                                style: TextStyle(
                                    fontSize: 11.0, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  Photo bean = _movieDetailBean.photos![
                      index - (_movieDetailBean.trailers!.isNotEmpty ? 1 : 0)];
                  return showBigImg(
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Image.network(
                          '${bean.cover}',
                          fit: BoxFit.cover,
                          width: w,
                          height: h,
                        ),
                      ),
                      '${bean.cover}');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ///演职表图片
  Widget getCast(String id, String imgUrl, String name) {
    return Hero(
        tag: imgUrl,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              MyRouter.push(context, MyRouter.personDetailPage,
                  {'personImgUrl': imgUrl, 'id': id});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, right: 14.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    child: Image.network(
                      imgUrl,
                      height: 120.0,
                      width: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 13.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _getTrailers(double w, double h) {
    if (_movieDetailBean.trailers!.isEmpty) {
      return Container();
    }
    return CachedNetworkImage(
        width: MediaQuery.of(context).size.width,
        height: h,
        fit: BoxFit.cover,
        imageUrl: '${_movieDetailBean.trailers![0].medium}');
  }

  //传入的图片组件，点击后，会显示大图页面
  Widget showBigImg(Widget widget, String imgUrl) {
    return Hero(
      tag: imgUrl,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: widget,
          onTap: () {
            AnimalPhoto.show(context, imgUrl);
          },
        ),
      ),
    );
  }

  ///短评，默认显示4个
  sliverComments() {
    if (commentsEntity.comments!.isEmpty) {
      return const SliverToBoxAdapter();
    }
    Color backgroundColor = const Color(0x44000000);
    int allCount = math.min(4, commentsEntity.comments!.length);
    allCount = allCount + 2; //多出来的2个表示头和脚
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      if (index == 0) {
        ///头布局
        return Container(
          margin: const EdgeInsets.only(
              top: 30.0,
              left: Constant.MARGIN_LEFT,
              right: Constant.MARGIN_RIGHT),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0))),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  '短评',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              Text(
                '全部短评 ${commentsEntity.total} >',
                style:
                    const TextStyle(color: Color(0x8FFFFFFF), fontSize: 12.0),
              )
            ],
          ),
        );
      }
      if (index == allCount - 1) {
        ///显示脚布局
        return Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(
              bottom: 20.0,
              left: Constant.MARGIN_LEFT,
              right: Constant.MARGIN_RIGHT),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0))),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  '查看全部评价',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              Icon(Icons.keyboard_arrow_right,
                  size: 20.0, color: Color(0x8FFFFFFF))
            ],
          ),
        );
      }
      CommantsBeanCommants bean = commentsEntity.comments![index - 1];
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // MyRouter.push(context, bean.author.alt, {'title': '个人主页'});
        },
        child: Container(
          margin: padding(),
          decoration: const BoxDecoration(
            color: Color(0x44000000),
            // color: Colors.white
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10.0, top: 10.0, bottom: 5.0),
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(bean.author.avatar),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bean.author.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                      RatingBar(
                        (bean.rating.value * 1.0) /
                            (bean.rating.max * 1.0) *
                            10.0,
                        size: 11.0,
                        fontSize: 0.0,
                      )
                    ],
                  )
                ],
              ),
              ExpandableText(
                text: bean.content, 
                maxLines: 3,
                textStyle: const TextStyle(color: Colors.white, fontSize: 16)
              ),
              const SizedBox(height: 5,),
              Row(
                //赞的数量
                children: <Widget>[
                  Image.asset(
                    '${Constant.ASSETS_IMG}ic_vote_normal_large.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  Text(
                    '${getUsefulCount(bean.usefulCount)}',
                    style: const TextStyle(color: Color(0x8FFFFFFF)),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }, childCount: allCount));
  }

  ///将34123转成3.4k
  getUsefulCount(int usefulCount) {
    double a = usefulCount / 1000;
    if (a < 1.0) {
      return usefulCount;
    } else {
      return '${a.toStringAsFixed(1)}k'; //保留一位小数
    }
  }

  padding() {
    return const EdgeInsets.only(
        left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT);
  }

  getPadding(Widget body) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT),
      child: body,
    );
  }
}
