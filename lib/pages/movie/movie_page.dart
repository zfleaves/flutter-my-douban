import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/subject_entity.dart';
import 'package:flutter_douban/constant/color_constant.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/pages/movie/hot_soon_tab_bar.dart';
import 'package:flutter_douban/pages/movie/title_widget.dart';
import 'package:flutter_douban/pages/movie/today_play_movie_widget.dart';
import 'package:flutter_douban/pages/movie/top_item_bean.dart';
import 'package:flutter_douban/pages/movie/top_item_widget.dart';
import 'package:flutter_douban/repository/movie_repository.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/ItemCountTitle.dart';
import 'package:flutter_douban/widgets/image/cache_img_radius.dart';
import 'package:flutter_douban/widgets/loading_widget.dart';
import 'package:flutter_douban/widgets/rating_bar.dart';
import 'dart:math' as math;

import 'package:flutter_douban/widgets/subject_mark_image_widget.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey globalKey = GlobalKey();
  late Widget titleWidget, hotSoonTabBarPadding;
  late HotSoonTabBar hotSoonTabBar;

  List<Subject> hotShowBeans = []; //影院热映
  List<Subject> comingSoonBeans = []; //即将上映
  List<Subject> hotBeans = []; //豆瓣榜单
  List<SubjectEntity> weeklyBeans = []; //一周口碑电影榜
  List<Subject> top250Beans = []; //Top250

  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0; //选中的是热映、即将上映
  var itemW;
  var imgSize;
  List<String> todayUrls = [];
  late TopItemBean weeklyTopBean = TopItemBean('', '', []);
  late TopItemBean weeklyHotBean = TopItemBean('', '', []);
  late TopItemBean weeklyTop250Bean = TopItemBean('', '', []);
  late Color weeklyTopColor = Colors.white, weeklyHotColor = Colors.white, weeklyTop250Color = Colors.white;
  Color todayPlayBg = const Color.fromARGB(255, 47, 22, 74);

  @override
  void initState() {
    super.initState();
    titleWidget = const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TitleWidget(),
    );
    hotSoonTabBar = HotSoonTabBar(
      key: globalKey,
      onTabCallBack: (index) {
        setState(() {
          selectIndex = index;
        });
      },
    );
    hotSoonTabBarPadding = Padding(
      padding: const EdgeInsets.only(top: 35.0, bottom: 15.0),
      child: hotSoonTabBar,
    );
    requestAPI();
  }

  MovieRepository repository = MovieRepository();
  // late MovieRepository repository;
  bool loading = true;

  void requestAPI() async {
    Future(() => (repository.requestAPI())).then((value) {
      print(value.weeklyTopColor);
      hotShowBeans = value.hotShowBeans!;
      comingSoonBeans = value.comingSoonBeans!;
      hotBeans = value.hotBeans!;
      weeklyBeans = value.weeklyBeans!;
      top250Beans = value.top250Beans!;
      todayUrls = value.todayUrls!;
      weeklyTopBean = value.weeklyTopBean!;
      weeklyHotBean = value.weeklyHotBean!;
      weeklyTop250Bean = value.weeklyTop250Bean!;
      weeklyTopColor = value.weeklyTopColor!;
      weeklyHotColor = value.weeklyHotColor!;
      weeklyTop250Color = value.weeklyTop250Color!;
      todayPlayBg = value.todayPlayBg!;
      hotSoonTabBar.setCount(hotShowBeans);
      hotSoonTabBar.setComingSoon(comingSoonBeans);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (itemW == null || imgSize <= 0) {
      MediaQuery.of(context);
      double w = MediaQuery.of(context).size.width;
      imgSize = w / 5 * 3;
      itemW = (w - 30.0 - 20.0) / 3;
      hotChildAspectRatio = (377.0 / 674.0);
      comingSoonChildAspectRatio = (377.0 / 742.0);
    }
    return Stack(
      children: <Widget>[
        containerBody(),
        Offstage(
          offstage: !loading,
          child: LoadingWidget.getLoading(backgroundColor: Colors.transparent),
        )
      ],
    );
  }

  ///即将上映item
  Widget _getComingSoonItem(Subject comingSoonBean, var itemW) {
    if (comingSoonBean == null) {
      return Container();
    }
    String mainlandPubdate = comingSoonBean.mainland_pubdate;
    mainlandPubdate = mainlandPubdate.substring(5, mainlandPubdate.length);
    mainlandPubdate = '${mainlandPubdate.replaceFirst(RegExp(r'-'), '月')}日';
    return GestureDetector(
      onTap: () {
        MyRouter.push(context, MyRouter.movieDetailPage, {'doubanId': comingSoonBean.id, 'name': comingSoonBean.title});
      },
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubjectMarkImageWidget(
              comingSoonBean.images?.large,
              width: itemW,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(comingSoonBean.title,
                    softWrap: false, // 文本只显示一行
                    ///多出的文本渐隐方式
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: ColorConstant.colorRed277),
                    borderRadius: BorderRadius.all(Radius.circular(2.0))),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  comingSoonBean.mainland_pubdate,
                  style: const TextStyle(
                      fontSize: 12.0, color: ColorConstant.colorRed277),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///影院热映item
  Widget _getHotMovieItem(Subject hotMovieBean, var itemW, int index) {
    if (hotMovieBean == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          MyRouter.push(context, MyRouter.detailPage, {'doubanId': hotMovieBean.id, 'name': hotMovieBean.title});
        } else {
          MyRouter.push(context, MyRouter.movieDetailPage, {'doubanId': hotMovieBean.id, 'name': hotMovieBean.title});
        }
      },
      child: Column(
        children: <Widget>[
          SubjectMarkImageWidget(
            hotMovieBean.images?.large,
            width: itemW,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                hotMovieBean.title,
                ///文本只显示一行
                softWrap: false,
                ///多出的文本渐隐方式
                overflow: TextOverflow.fade,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          RatingBar(
            hotMovieBean.rating?.average,
            size: 12.0,
          )
        ],
      ),
    );
  }

  int _getChildCount() {
    if (selectIndex == 0) {
      return hotShowBeans.length;
    } else {
      return comingSoonBeans.length;
    }
  }

  double _getRadio() {
    if (selectIndex == 0) {
      return hotChildAspectRatio;
    } else {
      return comingSoonChildAspectRatio;
    }
  }

  ///图片+订阅+名称+星标
  SliverGrid getCommonSliverGrid(List<Subject> hotBeans) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return _getHotMovieItem(hotBeans[index], itemW, -1);
        }, childCount: math.min(hotBeans.length, 6)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 0.0,
            childAspectRatio: hotChildAspectRatio));
  }

  ///R角图片
  getCommonImg(String url, OnTab? onTab) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: CacheImgRadius(
          imgUrl: url,
          radius: 5.0,
          onTab: () {
            if (onTab != null) {
              onTab();
            }
          },
        ),
      ),
    );
  }

  Widget containerBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: titleWidget,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: TodayPlayMovieWidget(
                todayUrls,
                backgroundColor: todayPlayBg,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: hotSoonTabBarPadding,
          ),
          SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              var hotMovieBean;
              var comingSoonBean;
              if (hotShowBeans.isNotEmpty) {
                hotMovieBean = hotShowBeans[index];
              }
              if (comingSoonBeans.isNotEmpty) {
                comingSoonBean = comingSoonBeans[index];
              }
              return Stack(
                children: <Widget>[
                  // Text('data'),
                  Offstage(
                    offstage: !(selectIndex == 1 && comingSoonBeans.isNotEmpty),
                    child: _getComingSoonItem(comingSoonBean, itemW),
                  ),
                  Offstage(
                    offstage: !(selectIndex == 0 && hotShowBeans.isNotEmpty),
                    child: _getHotMovieItem(hotMovieBean, itemW, index),
                  ),
                ],
              );
            }, childCount: math.min(_getChildCount(), 6)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: _getRadio()),
          ),
          getCommonImg(Constant.IMG_TMP1, () {
            // MyRouter.pushNoParams(context, "http://www.flutterall.com");
          }),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: ItemCountTitle(
                '豆瓣热门',
                fontSize: 13.0,
                count: hotBeans == null ? 0 : hotBeans.length,
              ),
            ),
          ),
          getCommonSliverGrid(hotBeans),
          getCommonImg(Constant.IMG_TMP2, null),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: ItemCountTitle(
                '豆瓣榜单',
                count: weeklyBeans == null ? 0 : weeklyBeans.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: imgSize,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TopItemWidget(
                    title: '一周口碑电影榜',
                    bean: weeklyTopBean,
                    partColor: weeklyTopColor,
                  ),
                  TopItemWidget(
                    title: '一周热门电影榜',
                    bean: weeklyHotBean,
                    partColor: weeklyHotColor,
                  ),
                  TopItemWidget(
                    title: '豆瓣电影 Top250',
                    bean: weeklyTop250Bean,
                    partColor: weeklyTop250Color,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

typedef OnTab = void Function();
