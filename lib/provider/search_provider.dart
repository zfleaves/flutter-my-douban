import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_search_entity.dart';

class SearchProvider extends ChangeNotifier {
  final List<SearchRecord> _searchList = [];

  List<SearchRecord> get searchList => _searchList;

  set searchList(List<SearchRecord> value) {
    _searchList.addAll(value);
    notifyListeners();
  }

  set addSingleBean(SearchRecord key) {
    print(key);
    _searchList.add(key);
    notifyListeners();
  }

  removeItem(SearchRecord key) {
    for (var i = 0; i < _searchList.length; i++) {
      if (_searchList[i].searchKey == key.searchKey) {
        _searchList.removeAt(i);
        print(i);
        break;
      }
    }
    notifyListeners();
  }

  clear() {
    _searchList.clear();
    notifyListeners();
  }
}