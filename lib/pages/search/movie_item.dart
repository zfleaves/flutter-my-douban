import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/router.dart';
import 'package:flutter_douban/tools/circularTool.dart';

class MovieItem extends StatelessWidget {
  final MovieFavorite entity;
  const MovieItem(this.entity, {super.key});

  ///构建电影item右边部分
  Widget _buildItemRight(MovieFavorite entity,double height){
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          getText(entity.movieName,textSize: 16.0,fontWeight: FontWeight.bold,color: Colors.black),
          const SizedBox(height: 10.0),
          getText(entity.movieCountry,textSize: 12.0),
          const SizedBox(height: 5.0),
          getText(entity.movieLanguage,textSize: 12.0),
          const SizedBox(height: 5.0),
          getText(entity.movieGenre.isNotEmpty ? entity.movieGenre : '未知',textSize: 12.0),
          const SizedBox(height: 5.0),
          Expanded(child: getText(entity.movieDescription,textSize: 12.0,color: Colors.grey,maxLine: 5)),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  ///构建每一个搜索列表item
  Widget _buildMovieItem(MovieFavorite entity, BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildMovieImage(entity.moviePoster, 200),
          const SizedBox(width: 10.0),
          Expanded(child: _buildItemRight(entity,200))
        ],
      ),
      onTap: () {
        MyRouter.push(context, MyRouter.movieDetailPage,
            {'doubanId': entity.doubanId, 'name': entity.movieName});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: _buildMovieItem(entity, context),
    );
  }
}
