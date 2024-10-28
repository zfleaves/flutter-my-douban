


import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_search_entity.dart';
import 'package:flutter_douban/provider/search_provider.dart';
import 'package:flutter_douban/sql/dao/search_dao.dart';
import 'package:flutter_douban/tools/toastTool.dart';

///点击搜索按钮，将此搜索记录添加到数据库
exeSearchInsert(SearchRecord entity, SearchProvider searchProvider) async {
  bool isExist = await SearchDao.getInstance().isExist(entity.searchKey);
  if (!isExist) {
    searchProvider.addSingleBean = entity;
    await SearchDao.getInstance().insert(entity);
  }
}

exeSearchRemove(SearchRecord entity, SearchProvider searchProvider) async {
  bool isExist = await SearchDao.getInstance().isExist(entity.searchKey);
  if (isExist) {
    int count = await SearchDao.getInstance().delete(entity.searchKey);
    if (count > 0) {
      searchProvider.removeItem(entity);
      return showSuccessToast('删除完成');
    } else {
      return showFailedToast('删除失败');
    }
  }
}

///清空搜索记录
exeSearchClear(SearchProvider searchProvider) async {
  if (searchProvider.searchList.isEmpty) {
    showFailedToast('记录为空，无需清空!');
    return;
  }
  int count = await SearchDao.getInstance().deleteAll();
  if (count > 0) {
    searchProvider.clear();
    return showSuccessToast('清空完成');
  }
  return showFailedToast('清空失败');
}



isSearchInserted(String key) async => await SearchDao.getInstance().isExist(key);