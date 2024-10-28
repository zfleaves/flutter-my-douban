import 'package:flutter/material.dart';
import 'package:flutter_douban/bean/i_search_entity.dart';
import 'package:flutter_douban/sql/sql_manager.dart';
import 'package:sqflite/sqflite.dart';

class SearchDao {
  static SearchDao? _instance;
  static SearchDao getInstance() => _instance ?? SearchDao();

  ///插入数据
  Future<int> insert(SearchRecord bean) async {
    Database db = await DBManager.getInstance().getDatabase;
    return await db.insert(DBManager.searchTable, bean.toJson());
  }

  ///删除数据
  Future<int> delete(String key) async {
    Database db = await DBManager.getInstance().getDatabase;
    return await db.delete(DBManager.searchTable,
        where: '${DBManager.searchKey} = ?', whereArgs: [key]);
  }

  ///删除全部数据
  Future<int> deleteAll() async {
    Database db = await DBManager.getInstance().getDatabase;
    return await db.delete(DBManager.searchTable);
  }

  ///查询数据
  Future<List<SearchRecord>> query(String key) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query(DBManager.searchTable,
        where: '${DBManager.searchKey} = ?', whereArgs: [key]);
    if (result.isNotEmpty) {
      return result.map((e) => SearchRecord.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  ///根据key查询判断是否存在
  Future<bool> isExist(String key) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query(DBManager.searchTable, where: '${DBManager.searchKey} = ?', whereArgs: [key]);
    return result.isNotEmpty;
  }

  ///查询所有数据
  Future<List<SearchRecord>> queryAll() async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query(DBManager.searchTable);
    if (result.isNotEmpty) {
      return result.map((e) => SearchRecord.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
