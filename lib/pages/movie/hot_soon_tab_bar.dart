import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/color_constant.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/constant/text_size_constant.dart';

typedef TabCallBack = void Function(int index);

class HotSoonTabBar extends StatefulWidget {
  final state = _HotSoonTabBarState();

  HotSoonTabBar({super.key, required TabCallBack onTabCallBack}) {
    state.setTabCallBack(onTabCallBack);
  }

  @override
  State<HotSoonTabBar> createState() {
    // ignore: no_logic_in_create_state
    return state;
  }

  void setCount(List list) {
    state.setCount(list.length);
  }

  void setComingSoon(List list) {
    state.setComingSoonCount(list.length);
  }
  
}

class _HotSoonTabBarState extends State<HotSoonTabBar>
    with SingleTickerProviderStateMixin {
  int movieCount = 0;
  late Color selectColor, unselectedColor;
  late TextStyle selectStyle, unselectedStyle;
  late Widget tabBar;
  late TabController _tabController;
  var hotCount, soonCount; //热映数量、即将上映数量、
  late TabCallBack onTabCallBack;
  int comingSoonCount = 0;
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    selectColor = ColorConstant.colorDefaultTitle;
    unselectedColor = const Color.fromARGB(255, 5, 5, 5);
    selectStyle = TextStyle(
        fontSize: TextSizeConstant.BookAudioPartTabBar,
        color: selectColor,
        fontWeight: FontWeight.bold);
    unselectedStyle = TextStyle(
        fontSize: TextSizeConstant.BookAudioPartTabBar, color: unselectedColor);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(listener);
    tabBar = TabBar(
      tabs: const [
        Padding(
          padding: EdgeInsets.only(bottom: Constant.TAB_BOTTOM),
          child: Text('影院热映'),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Constant.TAB_BOTTOM),
          child: Text('即将上映'),
        )
      ],
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectStyle,
      unselectedLabelColor: unselectedColor,
      unselectedLabelStyle: unselectedStyle,
      indicatorSize: TabBarIndicatorSize.label,
      controller: _tabController,
      isScrollable: true,
    );
  }

  void listener() {
    if (_tabController.indexIsChanging) {
      var index = _tabController.index;
      selectIndex = index;
      setState(() {
        if (index == 0) {
          movieCount = hotCount;
        } else {
          movieCount = comingSoonCount;
        }
        if (onTabCallBack != null) {
          print(index);
          onTabCallBack(index);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(listener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: tabBar,
        ),
        Text(
          '全部 $movieCount > ',
          style: const TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)
        )
      ],
    );
  }

  ///影院热映数量
  void setCount(int count) {
    setState(() {
      this.hotCount = count;
      if (selectIndex == 0) {
        setState(() {
          movieCount = hotCount;
        });
      }
    });
  }

  ///即将上映数量
  void setComingSoonCount(int length) {
    setState(() {
      this.comingSoonCount = length;
      if (selectIndex == 1) {
        setState(() {
          movieCount = comingSoonCount;
        });
      }
    });
  }

  void setTabCallBack(TabCallBack onTabCallBack) {
    this.onTabCallBack = onTabCallBack;
  }
}
