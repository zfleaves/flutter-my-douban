import 'package:flutter/material.dart';
import 'package:flutter_douban/pages/group/group_page.dart';
import 'package:flutter_douban/pages/home/home_page.dart';
import 'package:flutter_douban/pages/movie/book_audio_video_page.dart';
import 'package:flutter_douban/pages/top_250_net.dart';
import 'package:flutter_douban/pages/person/person_center_page.dart';
import 'package:flutter_douban/pages/shop_page.dart';

class _Item {
  String name, activeIcon, normalIcon;
  _Item(this.name, this.activeIcon, this.normalIcon);
}

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  var _pageController;
  final ShopPageWidget shopPageWidget = const ShopPageWidget();
  List<Widget> pages = [];
  final defaultItemColor = const Color.fromARGB(255, 125, 125, 125);

  final itemNames = [
    _Item('首页', 'assets/images/ic_tab_home_active.png',
        'assets/images/ic_tab_home_normal.png'),
    _Item('书影音', 'assets/images/ic_tab_subject_active.png',
        'assets/images/ic_tab_subject_normal.png'),
    _Item('小组', 'assets/images/ic_tab_group_active.png',
        'assets/images/ic_tab_group_normal.png'),
    _Item('TOP', 'assets/images/ic_top_active.png',
        'assets/images/ic_top_normal.png'),
    // _Item('市集', 'assets/images/ic_tab_shiji_active.png',
    //     'assets/images/ic_tab_shiji_normal.png'),
    _Item('我的', 'assets/images/ic_tab_profile_active.png',
        'assets/images/ic_tab_profile_normal.png')
  ];

  List<BottomNavigationBarItem> itemList = [];

  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectIndex);
    pages = [
      const HomePage(),
      // const BookAudioVideoPage(),
      const BookAudioVideoPage(),
      const GroupPage(),
      const MyTopNetPage(),
      // shopPageWidget,
      const PersonCenterPage()
    ];
    itemList = itemNames
        .map((item) => BottomNavigationBarItem(
            icon: Image.asset(
              item.normalIcon,
              width: 30,
              height: 30,
            ),
            activeIcon: Image.asset(
              item.activeIcon,
              width: 30,
              height: 30,
            ),
            label: item.name))
        .toList();
  }

  @override
  void didUpdateWidget(covariant ContainerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
        // 不滑动
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: itemList,
        onTap: (index) {
          setState(() {
            _selectIndex = index;
            _pageController.jumpToPage(index);
            shopPageWidget
                .setShowState(pages.indexOf(shopPageWidget) == _selectIndex);
          });
        },
        //图标大小
        iconSize: 24,
        //当前选中的索引
        currentIndex: _selectIndex,
        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
        fixedColor: const Color.fromARGB(255, 0, 188, 96),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
