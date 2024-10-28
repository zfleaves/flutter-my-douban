import 'package:flutter/material.dart';
import 'package:flutter_douban/pages/douya_top_250_list_widget.dart';
import 'package:flutter_douban/pages/movie/movie_page.dart';

class FlutterTabBarView extends StatelessWidget {
  final TabController tabController;
  const FlutterTabBarView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    List<Widget> viewList = [
      const MoviePage(key: PageStorageKey<String>('MoviePage'),),
      const DouBanListView(key: PageStorageKey<String>('DouBanListView'),),
      const CustomPage('page1'),
    ];
    return TabBarView(
      controller: tabController,
      children: viewList,
    );
  }
}

class CustomPage extends StatelessWidget {
  final String text;
  const CustomPage(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}