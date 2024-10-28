

import 'package:flutter_douban/bean/i_movie_favorite_entity.dart';
import 'package:flutter_douban/sql/sql_manager.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDao {
  static FavoriteDao? _instance;
  static FavoriteDao getInstance() => _instance ??= FavoriteDao();

  ///插入数据
  Future<int> insert(MovieFavorite bean) async {
    Database db = await DBManager.getInstance().getDatabase;
    return await db.insert(DBManager.favoriteTable, bean.toJson());
  }

  ///删除数据
  Future<int> delete(String doubanId) async{
    Database db = await DBManager.getInstance().getDatabase;
    return await db.delete(DBManager.favoriteTable,where:'${DBManager.doubanId} = ?',whereArgs:[doubanId]);
  }

  ///删除全部数据
  Future<int> deleteAll() async{
    Database db = await DBManager.getInstance().getDatabase;
    return await db.delete(DBManager.favoriteTable);
  }

  ///查询数据
  Future<List<MovieFavorite>> query(String doubanId) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query(DBManager.favoriteTable, where: '${DBManager.doubanId} = ?', whereArgs: [doubanId]);
    if (result.isNotEmpty) {
      return result.map((e) => MovieFavorite.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  ////根据doubanId查询判断是否存在
  Future<bool> isExist(String doubanId) async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query(DBManager.favoriteTable, where: '${DBManager.doubanId} = ?', whereArgs: [doubanId]);
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  ///查询所有数据
  Future<List<MovieFavorite>> queryAll() async {
    Database db = await DBManager.getInstance().getDatabase;
    var result = await db.query(DBManager.favoriteTable);
    if (result.isNotEmpty) {
      return result.map((e) => MovieFavorite.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}