import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';
import 'package:flutter_douban/http/net_request.dart';
import 'package:flutter_douban/pages/search/movie_item.dart';

class SearchResultPage extends StatefulWidget {
  final String search;
  const SearchResultPage({super.key, required this.search});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {

  Widget _buildFutureBuilder(BuildContext context, AsyncSnapshot<List<ITopEntity>?> snapshot) {
    switch(snapshot.connectionState){
      case ConnectionState.none:
        return const Text('未开始网络请求...');
      case ConnectionState.active:
        return const Text('开始网络请求...');
      case ConnectionState.waiting:
        return const Center(child: CircularProgressIndicator());
      case ConnectionState.done:
        if(snapshot.hasError) {
          print(snapshot.hasError);
          return const Center(child: Text('请求过于频繁,请稍后再试...'));
        }else{
          return Container(
             margin: const EdgeInsets.all(10.0),
             child: _buildMovieList(snapshot.data),
          );
        }
    }
  }

  ///构建搜索结果list列表
  Widget _buildMovieList(List<ITopEntity>? entityList) { 
    if(entityList == null || entityList.isEmpty) return const Center(child: Text('没有搜索到相关内容!'));
    return ListView.builder(
      itemCount: entityList.length,
      itemBuilder: (BuildContext context, int index) {
        return MovieItem(
          MovieFavorite(
            entityList[index].doubanId,
            entityList[index].data[0].poster,
            entityList[index].data[0].name,
            entityList[index].data[0].country,
            entityList[index].data[0].language,
            entityList[index].data[0].genre,
            entityList[index].data[0].description
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索结果'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: FutureBuilder(
          future: NetRequest.getSearchList(widget.search), 
          builder: _buildFutureBuilder,
        ),
      )
    );
  }
}