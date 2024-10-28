import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';

class FavoriteProvider extends ChangeNotifier {
  List<MovieFavorite> _favoriteList = [];

  List<MovieFavorite> get favoriteList => _favoriteList;

  set setList(List<MovieFavorite> value) {
    _favoriteList.addAll(value);
    notifyListeners();
  }


  initFavoriteList(List<MovieFavorite> value) {
    _favoriteList = value;
    notifyListeners();
  }


  set removeItem(int index){
    _favoriteList.removeAt(index);
    notifyListeners();
  }
}