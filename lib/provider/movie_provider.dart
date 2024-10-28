import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_top_entity.dart';

class MovieProvider extends ChangeNotifier {
  List<ITopEntity> _topList = [];

  List<ITopEntity> get topList => _topList;

  set setList(List<ITopEntity> list) {
    _topList.addAll(list);
    // _topList = list;
    notifyListeners();
  }

  clearList() {
    _topList = [];
    // notifyListeners();
  }
}