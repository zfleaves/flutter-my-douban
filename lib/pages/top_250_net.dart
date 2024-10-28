import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';
import 'package:flutter_douban/constant/cache_key.dart';
import 'package:flutter_douban/constant/constant.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/provider/movie_provider.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/widgets/custom_shimmer.dart';
import 'package:flutter_douban/widgets/search_text_field_widget.dart';
import 'package:flutter_douban/widgets/top250/createMovieItem.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTopNetPage extends StatefulWidget {
  const MyTopNetPage({super.key});

  @override
  State<MyTopNetPage> createState() => _MyTopNetPageState();
}

class _MyTopNetPageState extends State<MyTopNetPage> {
  late EasyRefreshController _controller;
  final double _imageWidth = 120.0;
  final double _imageHeight = 150.0;
  int limit = 3;
  int skip = 0;
  String type = 'Imdb';

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    _getUseType();
  }
  
  _getUseType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useSourceData = prefs.getBool(CacheKey.USE_SOURCE_DATA) ?? false;
    type = useSourceData ? 'Douban' : 'Imdb';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///上拉加载
  Future _loadMovieData(callback) async {
    await NetRequest.getTopList(skip, limit).then((value) {
      callback(value);
    });
  }


  ///电影ListView
  ///电影Provider修改作用域
  Widget _buildMovie(List<ITopEntity> entityList) {
    return Consumer<MovieProvider>(builder: (ctx, movieProvider, child) {
      return EasyRefresh(
          controller: _controller,
          header: const ClassicHeader(),
          footer: const ClassicFooter(),
          onRefresh: () async {
            skip = 0;
            print('${skip}-onRefresh');
            _loadMovieData((value) {
              movieProvider.clearList();
              movieProvider.setList = value;
              _controller.finishRefresh();
              _controller.resetFooter();
            });
          },
          onLoad: () async {
            skip += limit;
             print('${skip}-onLoad');
            _loadMovieData((value) {
              bool hasData = value != null || value.isNotEmpty ? true : false;
              if (hasData) {
                movieProvider.setList = value;
              }
              _controller.finishLoad(hasData ? IndicatorResult.success : IndicatorResult.noMore);
            });
          },
          child: ListView.builder(
              itemCount: movieProvider.topList.length,
              itemBuilder: (BuildContext context, int index) {
                return CreateMovieItem(
                  entity: movieProvider.topList[index],
                  index: index,
                  imageHeight: _imageHeight,
                );
              }));
    });
  }

  void _loadMovieList(List<ITopEntity> entityList) {
    if (skip == 0) {
      final movieProvider = context.read<MovieProvider>();
      movieProvider.clearList();
      movieProvider.setList = entityList;
    }
  }

  ///FutureBuild+骨架屏
  ///FutureBuild会执行两次，第一次状态为waiting，第二次为done（在正常情况下）
  Widget _buildFutureBuild(
      BuildContext context, AsyncSnapshot<List<ITopEntity>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return const Text('未开始网络请求');
      case ConnectionState.active:
        return const Text('开始网络请求...');
      case ConnectionState.waiting:
        return const CustomShimmer(
          totalLines: 3,
        );
      case ConnectionState.done:
        // print(snapshot);
        // print(snapshot.data);
        if (snapshot.hasError) {
          return const Center(child: Text('请求发生错误,请稍后再试...'),);
        } else if (snapshot.data == null) {
          return const Center(child: Text('请求过于频繁,请稍后再试...'));
        } else {
          Widget widget = _buildMovie(snapshot.data!);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _loadMovieList(snapshot.data!);
          });
          return widget;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SearchTextFieldWidget(
             margin: const EdgeInsets.all(Constant.MARGIN_RIGHT),
             hintText: 'TOP250',
             onTab: () {
              MyRouter.push(context, MyRouter.searchPage, 'hintText');
            },
          ),
          // Container(
          //   alignment: Alignment.topLeft,
          //   padding: const EdgeInsets.only(left: 20),
          //   margin: const EdgeInsets.only(bottom: 20),
          //   child: const Text('TOP250'),
          // ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: FutureBuilder(
                future: NetRequest.getTopList(skip, limit),
                builder: _buildFutureBuild,
              ),
            ),
          )
        ],
      )),
    );
  }
}
