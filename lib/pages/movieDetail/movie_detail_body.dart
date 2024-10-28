import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_detail_entity.dart';
import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/main.dart';
import 'package:flutter_douban/provider/favorite_provider.dart';
import 'package:flutter_douban/sql/dao/favorite_dao.dart';
import 'package:flutter_douban/sql/exe/favorite_sql.dart';
import 'package:flutter_douban/tools/circularTool.dart';
import 'package:provider/provider.dart';

class MovieDetailBody extends StatefulWidget {
  final String doubanId;
  final IMovieDetailEntity movieDetailEntity;
  final Color pickColor;
  final String name;
  const MovieDetailBody(
      {super.key,
      required this.movieDetailEntity,
      required this.pickColor,
      required this.name,
      required this.doubanId});

  @override
  State<MovieDetailBody> createState() => _MovieDetailBodyState();
}

class _MovieDetailBodyState extends State<MovieDetailBody> {
  late IMovieDetailEntity movieDetailEntity;
  final ValueNotifier<String> _collectionNotifier = ValueNotifier<String>('收藏');

  @override
  void initState() {
    super.initState();
    movieDetailEntity = widget.movieDetailEntity;
    _isFavorite();
  }

  Future _isFavorite() async {
    bool flag = await FavoriteDao.getInstance().isExist(widget.doubanId);
    if (flag) {
      _collectionNotifier.value = '已收藏';
    } else {
      _collectionNotifier.value = '收藏';
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          title: Text(widget.name, style: const TextStyle(color: Colors.white),),
          centerTitle: true,
          pinned: true,
          backgroundColor: widget.pickColor,
          foregroundColor: Colors.white,
        ),
        SliverToBoxAdapter(
            child: SizedBox(
          width: width,
          height: height,
          // color: Colors.pink,
          child: Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.decal),
                child: Image.network(
                  movieDetailEntity.data[0].poster,
                  fit: BoxFit.fill,
                  width: width,
                  height: height,
                ),
              ),
              buildMovieDetail(context, movieDetailEntity)
            ],
          ),
          // child: buildMovieDetail(context, movieDetailEntity),
        ))
      ],
    );
  }

  Widget buildMovieDetail(BuildContext context, IMovieDetailEntity entity) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      reverse: false,
      child: Container(
        width: width,
        height: height,
        // color: Colors.yellow,
        padding: const EdgeInsets.only(top: 20.0),
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            _buildMovieDescribe(entity),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: buildMovieImage(entity.data[0].poster, 250.0))
          ],
        ),
      ),
    );
  }

  ///电影描述
  Widget _buildMovieDescribe(IMovieDetailEntity entity) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.only(
          top: 180.0, left: 15.0, right: 15.0, bottom: 20.0),
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          // color: Color(0xff00889d),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 100.0, left: 10, right: 10, bottom: 0),
        child: Column(
          children: [
            getText(entity.data[0].name,
                textSize: 20.0, fontWeight: FontWeight.bold),
            const SizedBox(height: 5.0),
            getText(entity.data.length > 1 ? entity.data[1].name : 'unknown',
                textSize: 16.0, color: Colors.grey),
            const SizedBox(height: 20.0),
            _buildYearCountryWidget(entity),
            const SizedBox(height: 10.0),
            _buildGenreWidget(entity),
            const SizedBox(height: 20.0),
            _buildCollection(entity),
            const SizedBox(height: 20.0),
            getText(entity.data[0].description,
                textSize: 12, color: Colors.black, maxLine: 10),
            const SizedBox(height: 10.0),
            getText(
                entity.data.length > 1
                    ? entity.data[1].description
                    : 'unknown...',
                textSize: 12,
                color: Colors.black,
                maxLine: 10),
            const SizedBox(height: 20.0),
            splitLine,
            const SizedBox(height: 20.0),
            _buildActorRowWidget('作者:', entity.writer, 0),
            const SizedBox(height: 10.0),
            _buildActorRowWidget('导演:', entity.director, 1),
            const SizedBox(height: 10.0),
            _buildActorRowWidget('演员:', entity.actor, 2),
            const SizedBox(height: 10.0),
            _buildMovieDateWidget('日期:', 0, 1,
                entity.dateReleased.isNotEmpty ? entity.dateReleased : '未知'),
            const SizedBox(height: 10.0),
            _buildMovieDateWidget('片长:', entity.duration, 2)
          ],
        ),
      ),
    );
  }

  ///年份+地区描述
  Row _buildYearCountryWidget(IMovieDetailEntity entity) {
    String country = '未知';
    String eCountry = 'unknown';
    if (entity.data.length > 1) {
      country = entity.data[0].country;
      eCountry = entity.data[1].country;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getBoxText(entity.year.isNotEmpty ? entity.year : 'unknown'),
        const SizedBox(width: 10.0),
        getBoxText('$country($eCountry)')
      ],
    );
  }

  ///电影类型，例如：悬疑/爱情
  Row _buildGenreWidget(IMovieDetailEntity entity) {
    String genre = '未知';
    String eGenre = 'unknown';
    if (entity.data[0].genre.isNotEmpty) {
      genre = entity.data[0].genre;
    }
    if (entity.data.length > 1) {
      eGenre = entity.data[1].genre;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Flexible(child: getBoxText('$genre($eGenre})'))],
    );
  }

  ///收藏按钮
  ///收藏文字会进行局部刷新
  ///如果该影片存在数据库中则显示'已收藏'，否则显示'收藏'
  Widget _buildCollection(IMovieDetailEntity entity) {
    return ValueListenableBuilder<String>(
      valueListenable: _collectionNotifier,
      builder: (context, value, child) {
        return Container(
          width: 200.0,
          height: 40.0,
          alignment: Alignment.center,
          decoration:
              gradientBackground(Colors.orangeAccent, Colors.deepOrange),
          child: ElevatedButton(
              style: ButtonStyle(
                //去除阴影
                elevation: WidgetStateProperty.all(0),
                //将按钮背景设置为透明
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                final favoriteProvide = context.read<FavoriteProvider>();
                exeFavoriteInsert(
                    MovieFavorite(
                        entity.doubanId,
                        entity.data[0].poster,
                        entity.data[0].name,
                        entity.data[0].country,
                        entity.data[0].language,
                        entity.data[0].genre,
                        entity.data[0].description),
                    favoriteProvide);
                _collectionNotifier.value = '已收藏';
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  const SizedBox(width: 5.0),
                  getText(value, color: Colors.white, textSize: 16.0)
                ],
              )),
        );
      },
    );
  }

  /// 导演、主演、作者
  Widget _buildActorRowWidget<T>(
      String defaultText, List<T> listText, int flag) {
    String displayText = '';
    switch (flag) {
      case 0:
        List<IMovieDetailWriter> writer =
            listText.cast<IMovieDetailWriter>().toList();
        for (var element in writer) {
          displayText += '${element.data[0].name}/';
        }
        break;
      case 1:
        List<IMovieDetailDirector> writer =
            listText.cast<IMovieDetailDirector>().toList();
        for (var element in writer) {
          displayText += '${element.data[0].name}/';
        }
        break;
      case 2:
        List<IMovieDetailActor> writer =
            listText.cast<IMovieDetailActor>().toList();
        for (var element in writer) {
          displayText += '${element.data[0].name}/';
        }
        break;
    }
    if (displayText.isNotEmpty) {
      displayText = displayText.substring(0, displayText.length - 1);
    } else {
      displayText = 'unknown';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getText(defaultText,
            textSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
        const SizedBox(width: 5.0),
        Expanded(
            child: getText(displayText,
                textSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal))
      ],
    );
  }

  /// 影片上映日期 or 片长
  Widget _buildMovieDateWidget(String defaultText, int second, int flag,
      [String? dateReleased]) {
    String date = '';
    if (flag == 1) {
      date = dateReleased.toString();
    } else {
      date = '${second / 60}分钟';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getText(defaultText,
            textSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
        const SizedBox(width: 5.0),
        getText(date,
            textSize: 12, color: Colors.black, fontWeight: FontWeight.normal),
      ],
    );
  }
}
