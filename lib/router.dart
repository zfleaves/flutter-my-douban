import 'package:flutter/material.dart';
import 'package:flutter_douban/pages/container_page.dart';
import 'package:flutter_douban/pages/detail/detail_page.dart';
import 'package:flutter_douban/pages/favorite/my_favorite.dart';
import 'package:flutter_douban/pages/movieDetail/movie_detail.dart';
import 'package:flutter_douban/pages/person_detail_page.dart';
import 'package:flutter_douban/pages/photo_hero_page.dart';
import 'package:flutter_douban/pages/search/search_page.dart';
import 'package:flutter_douban/pages/search/search_result.dart';
import 'package:flutter_douban/pages/videos_play_page.dart';





class MyRouter { 
  static const homePage = 'app://';
  static const detailPage = 'app://DetailPage';
  static const movieDetailPage = 'app://MovieDetailPage';
  static const playListPage = 'app://VideosPlayPage';
  static const searchPage = 'app://SearchPage';
  static const searchResultPage = 'app://SearchResultPage';
  static const photoHero = 'app://PhotoHero';
  static const personDetailPage = 'app://PersonDetailPage';
  static const myFavorite = 'app://MyFavoritePage';


  Widget _getPage(String url, dynamic params) {
    switch(url) {
      case detailPage:
        return DetailPage(doubanId: params['doubanId'], name: params['name']);
      case movieDetailPage:
        return MovieDetailPage(doubanId: params['doubanId'], name: params['name']);
      case homePage:
        return const ContainerPage();
      case myFavorite:
        return const MyFavoritePage();
      case playListPage:
        return VideoPlayPage(params);
      case searchPage:
        return SearchPage(searchHintContent: params);
      case searchResultPage:
        return SearchResultPage(search: params);
      case photoHero:
        return PhotoHeroPage(photoUrl: params['photoUrl'], width: params['width']);
      case personDetailPage:
          return PersonDetailPage(params['personImgUrl'], params['id']);
    }
    return const ContainerPage();
  }

  MyRouter.pushNoParams(BuildContext context, String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, null);
    }));
  }

  MyRouter.push(BuildContext context, String url, dynamic params) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return _getPage(url, params);
    }));
  }
}