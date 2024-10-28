import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/subject_entity.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/http/API.dart';
import 'package:flutter_douban/http/mock_request.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/image/radius_img.dart';
import 'package:flutter_douban/widgets/search_text_field_widget.dart';
import 'package:flutter_douban/widgets/video_widget.dart';
import './home_app_bar.dart' as myapp;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }
}

var _tabs = ['动态', '推荐'];

DefaultTabController getWidget() {
  return DefaultTabController(
    initialIndex: 1,
    length: _tabs.length,
    child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: myapp.SliverAppBar(
                pinned: true,
                expandedHeight: 120.0,
                primary: true,
                titleSpacing: 0.0,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    color: Colors.green,
                    alignment: const Alignment(0, 0),
                    child: SearchTextFieldWidget(
                      hintText: '影视作品中你难忘的离别',
                      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                      onTab: () {
                        MyRouter.push(
                            context, MyRouter.searchPage, '影视作品中你难忘的离别');
                      },
                    ),
                  ),
                ),
                bottomTextString: _tabs,
                bottom: TabBar(
                    tabs: _tabs
                        .map((String name) => Container(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(name),
                            ))
                        .toList()),
              ),
            )
          ];
        },
        body: TabBarView(
            children: _tabs
                .map((String name) => SliverContainer(name: name))
                .toList())),
  );
}

class SliverContainer extends StatefulWidget {
  final String name;
  const SliverContainer({super.key, required this.name});

  @override
  State<SliverContainer> createState() => _SliverContainerState();
}

class _SliverContainerState extends State<SliverContainer> {
  List<Subject> list = [];

  @override
  void initState() {
    super.initState();

    ///请求动态数据
    if (list.isEmpty) {
      if (_tabs[0] == widget.name) {
        requestAPI();
      } else {
        ///请求推荐数据
        requestAPI();
      }
    }
  }

  void requestAPI() async {
    // var _request = HttpRequest(API.BASE_URL);
    // int start = math.Random().nextInt(220);
    // final Map result = await _request.get(API.TOP_250 + '?start=$start&count=30');
    // var resultList = result['subjects'];
    var _request = MockRequest();
    var result = await _request.get(API.TOP_250);
    var resultList = result['subjects'];
    list = resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
    // print(list);
    setState(() {});
  }

  getContentSliver(BuildContext context, List<Subject> list) {
    if (widget.name == _tabs[0]) {
      return _loginContainer(context);
    }
    if (list.isEmpty) {
      return const Text('暂无数据');
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            key: PageStorageKey<String>(widget.name),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return getCommonItem(list, index);
              }, childCount: list.length))
            ],
          );
        },
      ),
    );
  }

  double singleLineImgHeight = 180.0;
  double contentVideoHeight = 350.0;

  ///列表的普通单个item
  getCommonItem(List<Subject> items, int index) {
    Subject item = items[index];
    // bool showVideo = index == 1 || index == 3;
    bool showVideo = index == 1;
    return Container(
      height: showVideo ? contentVideoHeight : singleLineImgHeight,
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(
          left: Constant.MARGIN_LEFT,
          right: Constant.MARGIN_RIGHT,
          top: Constant.MARGIN_RIGHT,
          bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(item.casts![0].avatars?.medium),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(item.title),
              ),
              const Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                  size: 18,
                ),
              ))
            ],
          ),
          Expanded(
              child: Container(
            child: showVideo ? getContentVideo(index) : getItemCenterImg(item),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  '${Constant.ASSETS_IMG}ic_vote.png',
                  width: 25.0,
                  height: 25.0,
                ),
                Image.asset(
                  '${Constant.ASSETS_IMG}ic_notification_tv_calendar_comments.png',
                  width: 20.0,
                  height: 20.0,
                ),
                Image.asset(
                  '${Constant.ASSETS_IMG}ic_status_detail_reshare_icon.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getContentVideo(int index) {
    print(mounted);
    if (mounted) {
      return VideoWidget(
        index == 1 ? Constant.URL_MP4_DEMO_0 :  Constant.URL_MP4_DEMO_1,
        showProgressBar: false,
      );
    }
    return Container();
  }

  Widget getItemCenterImg(Subject item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(),
        Expanded(
            child: RadiusImg.get(item.images?.large, 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5))))),
        Expanded(
            child: RadiusImg.get(item.casts?[1].avatars?.medium, 0,
                radius: 0.0)),
        Expanded(
            child: RadiusImg.get(item.casts?[2].avatars?.medium, 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0))))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getContentSliver(context, list);
  }

  //动态TAB
  _loginContainer(context) {
    return Align(
      alignment: const Alignment(0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            '${Constant.ASSETS_IMG}ic_new_empty_view_default.png',
            width: 120,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
            child: Text(
              '登录后查看关注人动态',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ),
          GestureDetector(
            onTap: () {
              MyRouter.push(context, MyRouter.searchPage, '搜索笨啦灯');
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: const BorderRadius.all(Radius.circular(6.0))),
              child: const Text('去登录',
                  style: TextStyle(fontSize: 16.0, color: Colors.green)),
            ),
          )
        ],
      ),
    );
  }
}
