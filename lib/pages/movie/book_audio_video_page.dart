import 'package:flutter/material.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/my_tab_bar_widget.dart';
import 'dart:math' as math;

import 'package:flutter_douban/widgets/search_text_field_widget.dart';

var titleList = ['电影', '综艺', '读书'];

List<Widget> tabList = [];

class BookAudioVideoPage extends StatefulWidget {
  const BookAudioVideoPage({super.key});

  @override
  State<BookAudioVideoPage> createState() => _BookAudioVideoPageState();
}

late TabController _tabController;

class _BookAudioVideoPageState extends State<BookAudioVideoPage>
    with SingleTickerProviderStateMixin {
  var tabBar;

  @override
  void initState() {
    super.initState();
    tabBar = const HomePageTabBar();
    tabList = getTabList();
    _tabController = TabController(length: tabList.length, vsync: this);
  }

  List<Widget> getTabList() {
    return titleList
        .map((item) => Text(
              item,
              style: const TextStyle(fontSize: 15),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: DefaultTabController(
          length: tabList.length, 
          child: _getNestedScrollView(tabBar)
        )
      ),
    );
  }

  Widget _getNestedScrollView(Widget tabBar) {
    String hintText = '用一部电影来形容你的2018';
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget> [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: SearchTextFieldWidget(
                hintText: hintText,
                onTab: () {
                  MyRouter.push(context, MyRouter.searchPage, hintText);
                },
              ),
            ),
          ),
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: _SliverAppBarDelegate(49, 49, Container(
              color: Colors.white,
              child: tabBar,
            )),
          )
        ];
      },
      body: FlutterTabBarView(
        tabController: _tabController
      )
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  _SliverAppBarDelegate(
    this.minHeight,
    this.maxHeight,
    this.child,
  );

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max((minHeight), minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }
  
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomePageTabBar extends StatefulWidget {
  const HomePageTabBar({super.key});

  @override
  State<HomePageTabBar> createState() => _HomePageTabBarState();
}

class _HomePageTabBarState extends State<HomePageTabBar> {
  late Color selectColor, unselectedColor;
  late TextStyle selectStyle, unselectedStyle;

  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unselectedColor = const Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  Tab小部件列表
    //  List<Widget>  @required this.tabs,
    //  组件选中以及动画的状态
    //  TabController this.controller,
    //  Tab是否可滑动(false->整个tab会把宽度填满，true-> tab包裹)
    //  bool  this.isScrollable = false,
    //  选项卡下方的导航条的颜色
    //  Color this.indicatorColor,
    //  选项卡下方的导航条的线条粗细
    //  double this.indicatorWeight = 2.0,
    //  EdgeInsetsGeometry  this.indicatorPadding = EdgeInsets.zero,
    //  Decoration this.indicator,
    //  TabBarIndicatorSize this.indicatorSize,导航条的长度，（tab：默认等分；label：跟标签长度一致）
    //  Color  this.labelColor,所选标签标签的颜色
    //  TextStyle  this.labelStyle,所选标签标签的文本样式
    //  EdgeInsetsGeometry  this.labelPadding,,所选标签标签的内边距
    //  Color this.unselectedLabelColor,未选定标签标签的颜色
    //  TextStyle  this.unselectedLabelStyle,未选中标签标签的文字样式
    //  void Function(T value) this.onTap,按下时的响应事件

    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: TabBar(
        padding: const EdgeInsets.only(bottom: 10),
        tabs: tabList,
        isScrollable: true,
        controller: _tabController,
        indicatorColor: selectColor,
        labelColor: selectColor,
        labelStyle: selectStyle,
        unselectedLabelColor: unselectedColor,
        unselectedLabelStyle: unselectedStyle,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
