import 'package:flutter/material.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/pages/person/tab_bar_widget.dart';

class VideoBookMusicBookWidget extends StatefulWidget {
  const VideoBookMusicBookWidget({super.key});

  @override
  State<VideoBookMusicBookWidget> createState() =>
      _VideoBookMusicBookWidgetState();
}

class _VideoBookMusicBookWidgetState extends State<VideoBookMusicBookWidget>
    with SingleTickerProviderStateMixin {
  final List<String> tabTxt = ['影视', '图书', '音乐'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTxt.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget _tabView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _tabBarItem('bg_videos_stack_default.png'),
          _tabBarItem('bg_books_stack_default.png'),
          _tabBarItem('bg_music_stack_default.png'),
        ],
      ),
    );
  }

  Widget _tabBarItem(String img) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getTabViewItem(img, '想看'),
        getTabViewItem(img, '在看'),
        getTabViewItem(img, '看过'),
      ],
    );
  }

  Widget getTabViewItem(String img, String txt) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 7.0),
          child: Image.asset(Constant.ASSETS_IMG + img, fit: BoxFit.contain,),
        )),
        Text(txt)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.0,
      margin: const EdgeInsets.only(bottom: 10),
      child: DefaultTabController(
          length: tabTxt.length,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child:
                    TabBarWidget(tabController: _tabController, tabTxt: tabTxt),
              ),
              _tabView()
            ],
          )),
    );
  }
}
